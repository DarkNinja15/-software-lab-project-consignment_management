import 'dart:convert';
import 'package:flutter_consignment/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userKey = 'user';

  // Save the user to shared preferences
  static Future<void> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toMap());
    prefs.setString(userKey, userJson);
  }

  // Load the user from shared preferences
  static Future<UserModel?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(userKey);

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromMap(userMap);
    }

    return null;
  }

  // Remove the user from shared preferences
  static Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userKey);
  }
}
