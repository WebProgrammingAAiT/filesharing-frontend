import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<String> jwtOrEmpty();
  Future<void> removeJwt();
}

class AuthRepositoryImpl implements AuthRepository {
  static const String SERVER_IP = 'http://localhost:8080/api';
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<User> signIn(String email, String password) async {
    print(email);
    print(password);
    var res = await http.post('$SERVER_IP/signin',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"email": email.trim(), "password": password}));
    if (res.statusCode == 200) {
      await storage.write(key: 'jwt', value: json.decode(res.body)['token']);
      return User.fromJson(json.decode(res.body)['user']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<String> jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<void> removeJwt() async {
    await storage.delete(key: 'jwt');
  }
}
