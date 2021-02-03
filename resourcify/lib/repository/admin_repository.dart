import 'dart:convert';

import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

abstract class AdminRepository {
  Future<List<Category>> getCategories();
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
}
