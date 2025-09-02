import 'dart:convert';
import 'package:attandance_simple/core/models/login_public/user.dart';
import 'package:hive_flutter/hive_flutter.dart';


class LocalStorage {
  static const _boxName = 'user';
  static const _kToken = 'token';
  static const _kUser = 'user';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Box get _box => Hive.box(_boxName);

  // TOKEN
  Future<void> saveToken(String token) async {
    await _box.put(_kToken, token);
  }

  Future<String?> getToken() async {
    final v = _box.get(_kToken);
    return (v is String && v.isNotEmpty) ? v : null;
  }

  Future<void> removeToken() async {
    await _box.delete(_kToken);
  }

  Future<bool> hasToken() async {
    final v = _box.get(_kToken);
    return (v is String) && v.isNotEmpty;
  }

  // USER (disimpan sebagai JSON String)
  Future<void> saveUser(User user) async {
    // simpan sebagai String JSON valid, apapun bentuk toJson()
    final raw = user.toJson();
    final jsonString = raw is String ? raw : jsonEncode(raw);
    await _box.put(_kUser, jsonString);
  }

  Future<User?> getUser() async {
    final v = _box.get(_kUser);
    if (v is String && v.isNotEmpty) {
      return User.fromJson(v);
    }
    return null;
  }

  Future<void> removeUser() async {
    await _box.delete(_kUser);
  }

  Future<void> clearSession() async {
    await _box.delete(_kToken);
    await _box.delete(_kUser);
  }
}
