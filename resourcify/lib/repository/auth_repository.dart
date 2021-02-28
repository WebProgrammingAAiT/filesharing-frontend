import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/data_provider/auth_data_provider.dart';
import 'package:resourcify/models/user_model.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;

  AuthRepository({@required this.authDataProvider});

  Future<User> signIn(String email, String password) async {
    return await authDataProvider.signIn(email, password);
  }

  Future<String> jwtOrEmpty() async {
    return await authDataProvider.jwtOrEmpty();
  }

  Future<void> removeJwt() async {
    return await authDataProvider.removeJwt();
  }

  Future<User> signUp(String firstName, String lastName, String email,
      String password, String confirmPassword) async {
    return await authDataProvider.signUp(
        firstName, lastName, email, password, confirmPassword);
  }
}
