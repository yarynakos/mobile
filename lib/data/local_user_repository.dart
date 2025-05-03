import 'dart:convert';

import 'package:my_project/data/user_repository.dart';
import 'package:my_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository implements UserRepository {
  static const String _userKey = 'user_data';

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromMap(map);
  }

  @override
  Future<bool> login(String email, String password) async {
    final user = await getUser();
    return user != null && user.email == email && user.password == password;
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userKey);
  }
}
