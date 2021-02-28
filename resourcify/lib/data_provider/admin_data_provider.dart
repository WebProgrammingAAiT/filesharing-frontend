import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

class AdminDataProvider {
  static const String SERVER_IP = 'http://localhost:3000/api';
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

  Future<Category> deleteCategory(String id) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await httpClient.delete(
      '$SERVER_IP/categories/$id',
      headers: <String, String>{
        'Content-Type': 'application/djson; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (res.statusCode == 204) {
      return Category.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
