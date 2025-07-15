import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';

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

  static Future<NetworkResponse> getRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      Response response = await get(uri);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
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

 static Future<NetworkResponse> postRequest({required String url, Map<String, String>? body}) async {

    try {
      Uri uri = Uri.parse(url);

      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
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

  static void _logRequest(String url, Map<String, String>? body) {
    debugPrint(
      '================== REQUEST ========================\n'
      'URL: $url\n'
      'BODY: $body\n'
      '=============================================',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint('=================== RESPONSE =======================\n'
        'URL: $url\n'
        'STATUS CODE: ${response.statusCode}\n'
        'BODY: ${response.body}\n'
        '=============================================');
  }
}
