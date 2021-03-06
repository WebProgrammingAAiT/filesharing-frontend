import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

class ResourceDataProvider {
  static const String SERVER_IP = 'http://localhost:8080/api';
  final storage = FlutterSecureStorage();
  final http.Client httpClient;

  ResourceDataProvider({@required this.httpClient})
      : assert(httpClient != null);

  Future<String> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<List<Resource>> getResources(String userId) async {
    // return _fetchMockData();
    List<Resource> resourceList = [];
    String token = await getToken();
    var res = await httpClient.get(
      '$SERVER_IP/resources',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      List<dynamic> resourcesInJson = json.decode(res.body);
      resourcesInJson
          .forEach((resource) => resourceList.add(Resource.fromJson(resource)));

      return resourceList;
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

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

  Future<bool> createResource(
      {String filename,
      String filePath,
      String year,
      String department,
      String subject,
      String fileType}) async {
    String token = await getToken();

    var request =
        http.MultipartRequest('POST', Uri.parse('$SERVER_IP/resources'));

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = filename;
    request.fields['year'] = year;
    request.fields['department'] = department;
    request.fields['subject'] = subject;
    request.fields['fileType'] = fileType;
    request.files.add(
      await http.MultipartFile.fromPath(
        'files',
        filePath,
      ),
    );
    var res = await request.send();
    // Extract String from Streamed Response

    var responseString = await res.stream.bytesToString();
    if (res.statusCode == 201) {
      return true;
    } else {
      throw Exception(json.decode(responseString)['message']);
    }
  }

  Future<Resource> getResource(String id) async {
    String token = await getToken();
    var res = await httpClient.get(
      '$SERVER_IP/resources/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var resourceInJson = json.decode(res.body);

      return Resource.fromJson(resourceInJson);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<Resource> likeUnlikeResource(String id, String action) async {
    String token = await getToken();
    var res = await httpClient.put(
      '$SERVER_IP/resources/$id?action=$action',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 201) {
      var resourceInJson = json.decode(res.body);
      return Resource.fromJson(resourceInJson);
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}

// List<Resource> _fetchMockData() {
//   List<Resource> _resourceList = [];
//   List<dynamic> resourcesInJson = [
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     },
//     {
//       "_id": "5e91751e832d0e2791565592",
//       "resource_name": "Intro to HCI",
//       "year": "3rd",
//       "department": "ITSC",
//       "subject": "HCI",
//       "created_by": "username",
//       "likes": 0,
//       "dislikes": 0,
//       "fileSize": 2.5,
//       "fileType": "pdf",
//       "files": ["intro"],
//       "is_liked": true,
//       "is_disliked": false
//     }
//   ];
//   resourcesInJson.forEach((cat) => _resourceList.add(Resource.fromJson(cat)));

//   return _resourceList;
// }
