import 'package:task_manager/Model/User_Model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static UserModel? userModel;
  static String? accesstoken;

  static const String _user_data_key = 'user_data';
  static const String _access_token = 'access_token';

  static Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userDataJson = jsonEncode(model.toJson());

    await sharedPreferences.setString(_user_data_key, userDataJson);
    await sharedPreferences.setString(_access_token, token);

    userModel = model;
    accesstoken = token;
  }

  static Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userModel = UserModel.fromJson(
      jsonDecode(sharedPreferences.getString(_user_data_key)!),
    );
    accesstoken = sharedPreferences.getString(_access_token);
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    userModel = null;
    accesstoken = null;
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = await sharedPreferences.getString(_access_token);

    if (token != null) {
      await loadUserData();
      return true;
    } else {
      return false;
    }
  }
}
