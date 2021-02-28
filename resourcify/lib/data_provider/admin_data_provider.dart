import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

class AdminDataProvider {
  static const String SERVER_IP = 'http://localhost:8080/api';
  final http.Client httpClient;

  AdminDataProvider({@required this.httpClient});

  Future<List<Category>> getCategories() async {
    List<Category> categoryList = [];
    var res = await httpClient.get(
      '$SERVER_IP/categories',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      List<dynamic> categoriesInJson = json.decode(res.body);
      categoriesInJson
          .forEach((cat) => categoryList.add(Category.fromJson(cat)));

      return categoryList;
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<Category> createCategory(Category category) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.post('$SERVER_IP/categories',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "name": category.name,
          "parentId": category.parentId,
          "type": category.type
        }));
    if (res.statusCode == 201) {
      return Category.fromJson(json.decode(res.body)['category']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<Category> updateCategory(Category category) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.put('$SERVER_IP/categories/${category.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "name": category.name,
        }));
    if (res.statusCode == 200) {
      return Category.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteCategory(String id, String categoryType) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.delete(
      '$SERVER_IP/categories/$id?categoryType=$categoryType',
      headers: <String, String>{
        'Content-Type': 'application/djson; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (res.statusCode != 204) {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<Resource>> getSubjectResources(String id) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');
    var res = await httpClient.get(
      '$SERVER_IP/subjectResources/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var resourcesInJson = json.decode(res.body) as List;
      return resourcesInJson
          .map((resource) => Resource.fromJson(resource))
          .toList();
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<Role> createRole(Role role) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.post('$SERVER_IP/roles',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "name": role.name,
        }));
    if (res.statusCode == 201) {
      return Role.fromJson(json.decode(res.body)['role']);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<Role>> getRoles() async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.get(
      '$SERVER_IP/roles',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var rolesInJson = json.decode(res.body) as List;
      return rolesInJson.map((role) => Role.fromJson(role)).toList();
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteRole(String id) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.delete(
      '$SERVER_IP/roles/$id',
      headers: <String, String>{
        'Content-Type': 'application/djson; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (res.statusCode != 204) {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<User>> getUsers() async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.get(
      '$SERVER_IP/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var usersInJson = json.decode(res.body) as List;
      return usersInJson.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> updateUserRole(Role role, String userId) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.put(
      '$SERVER_IP/assignRoles/$userId?roleId=${role.id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (res.statusCode != 201) {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
