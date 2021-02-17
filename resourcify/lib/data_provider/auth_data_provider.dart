import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthDataProvider {
  static const String SERVER_IP = 'http://localhost:8080/api';
  final http.Client httpClient;
  // Create storage
  final storage = new FlutterSecureStorage();

  AuthDataProvider({@required this.httpClient});

  Future<User> signIn(String email, String password) async {
    print(email);
    print(password);
    var res = await httpClient.post('$SERVER_IP/signin',
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
    var splittedJwt = jwt.split(".");
    var payload = json
        .decode(ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      return jwt;
    } else {
      return '';
    }
  }

  Future<void> removeJwt() async {
    await storage.delete(key: 'jwt');
  }
}
