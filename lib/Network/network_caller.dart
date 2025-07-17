import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_manager/App/app.dart';
import 'package:task_manager/Controller/Auth_controller.dart';
import 'package:task_manager/ui/screens/Sign_in_screen.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? body;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.message,
    this.body,
    this.errorMessage,
  });
}

class networkCaller {
  static const String _defaultErrorMessage = 'Something went wrong';
  static const String _unauthorizedErrorMessage = 'Unauthorized access';

  static Future<NetworkResponse> getRequest({
    required String url,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      final Map<String, String> headers = {
        'token': AuthController.accesstoken ?? '',
      };
      _logRequest(url, null, headers);
      Response response = await get(uri, headers: headers);
      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _onUnauthorized();
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          errorMessage: _unauthorizedErrorMessage,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? body,
    bool isFromlogin = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': AuthController.accesstoken ?? '',
      };

      _logRequest(url, body, headers);

      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        if (isFromlogin == false) {
          _onUnauthorized();
        }
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: _unauthorizedErrorMessage,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void _logRequest(String url, Map<String, String>? body,Map<String, String>? headers) {
    debugPrint(
      '================== REQUEST ========================\n'
      'URL: $url\n'
      'HEADER: $headers\n'
      'BODY: $body\n'
      '=============================================',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint(
      '=================== RESPONSE =======================\n'
      'URL: $url\n'
      'STATUS CODE: ${response.statusCode}\n'
      'BODY: ${response.body}\n'
      '=============================================',
    );
  }
}

Future<void> _onUnauthorized() async {
  await AuthController.clearUserData();
  Navigator.pushNamedAndRemoveUntil(
    TaskManager.navigator.currentContext!,
    SignInScreen.name,
    (predicate) => false,
  );
}
