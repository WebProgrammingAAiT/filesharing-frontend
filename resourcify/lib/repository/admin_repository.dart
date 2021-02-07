import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

abstract class AdminRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
}

class AdminRepositoryImpl implements AdminRepository {
  static const String SERVER_IP = 'http://localhost:8080/api';

  @override
  Future<List<Category>> getCategories() async {
    List<Category> categoryList = [];
    categoryList.add(
      Category(
        id: '1',
        name: 'Root',
        parentId: '-1',
      ),
    );
    var res = await http.get(
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

  @override
  Future<Category> createCategory(Category category) async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');

    var res = await http.post('$SERVER_IP/categories',
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

    var res = await http.put('$SERVER_IP/categories/${category.id}',
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
}
