import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:resourcify/models/models.dart';

class UserDataProvider {
  final http.Client httpClient;
  static const String SERVER_IP = 'http://localhost:8080/api';
  final storage = FlutterSecureStorage();
  UserDataProvider({@required this.httpClient}) : assert(httpClient != null);

  Future<String> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<User> getUserInfo() async {
    String token = await getToken();
    String userId = '';
    if (token.isNotEmpty) {
      var splittedJwt = token.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
      userId = payload['_id'];
    }
    var res = await httpClient.get(
      "$SERVER_IP/users/$userId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<Resource>> getUserResources(String userId) async {
    String token = await getToken();

    var res = await httpClient.get(
      "$SERVER_IP/userResources/$userId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      List<dynamic> resourcesInJson = json.decode(res.body);
      return resourcesInJson
          .map((resource) => Resource.fromJson(resource))
          .toList();
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<Resource> updateUserResource(String id, String updatedName) async {
    String token = await getToken();
    var res = await httpClient.put('$SERVER_IP/resources/$id/update',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{"name": updatedName}));

    if (res.statusCode == 201) {
      var resourceInJson = json.decode(res.body);
      return Resource.fromJson(resourceInJson);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<bool> updateUser(
    String userId,
    String firstName,
    String username,
    String currentPassword,
    String newPassword,
    String year,
    String department,
    String profilePicture,
  ) async {
    String token = await getToken();

    var request =
        http.MultipartRequest('PUT', Uri.parse('$SERVER_IP/users/$userId'));

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['firstName'] = firstName;
    request.fields['username'] = username;
    request.fields['currentPassword'] = currentPassword;
    request.fields['newPassword'] = newPassword;
    request.fields['year'] = year;
    request.fields['department'] = department;
    if (profilePicture.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          profilePicture,
        ),
      );
    }
    var res = await request.send();

    var responseString = await res.stream.bytesToString();
    if (res.statusCode == 201) {
      return true;
    } else {
      throw Exception(json.decode(responseString)['message']);
    }
  }

  Future<void> deleteUserResource(String id) async {
    String token = await getToken();
    var res = await httpClient.delete(
      '$SERVER_IP/resources/$id/delete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode != 204) {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteUserAccount(String userId) async {
    String token = await getToken();
    var res = await httpClient.delete(
      '$SERVER_IP/users/$userId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode != 204) {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
