import 'dart:convert';

import 'package:resourcify/models/models.dart';
import 'package:http/http.dart' as http;

abstract class ResourceRepository {
  Future<List<Resource>> getResources(String userId);
}

class ResourceRepositoryImpl implements ResourceRepository {
  static const String SERVER_IP = 'http://localhost:8080/api';

  @override
  Future<List<Resource>> getResources(String userId) async {
    return _fetchMockData();
    // List<Resource> resourceList = [];
    // var res = await http.get(
    //   '$SERVER_IP/resources?user=$userId',
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );

    // if (res.statusCode == 200) {
    //   List<dynamic> resourcesInJson = json.decode(res.body);
    //   resourcesInJson
    //       .forEach((cat) => resourceList.add(Resource.fromJson(cat)));

    //   return resourceList;
    // } else {
      // throw Exception(json.decode(res.body)['message']);
    // }
  }
}

List<Resource> _fetchMockData(){
      List<Resource> _resourceList = [];
      List<dynamic> resourcesInJson = [
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        },
        {
          "_id": "5e91751e832d0e2791565592",
          "resource_name": "Intro to HCI",
          "year": "3rd",
          "department": "ITSC",
          "subject": "HCI",
          "created_by": "username",
          "likes": 0,
          "dislikes": 0,
          "fileSize": 2.5,
          "fileType": "pdf",
          "files": ["intro"],
          "is_liked": true,
          "is_disliked": false
        }
      ];
      resourcesInJson
          .forEach((cat) => _resourceList.add(Resource.fromJson(cat)));

      return _resourceList;
}