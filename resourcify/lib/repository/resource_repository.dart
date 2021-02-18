import 'package:resourcify/data_provider/resource_data_provider.dart';
import 'package:resourcify/models/models.dart';

class ResourceRepository {
  final ResourceDataProvider resourceDataProvider;

  const ResourceRepository(this.resourceDataProvider);

  Future<List<Resource>> getResources(String userId) async {
    return await resourceDataProvider.getResources('');
  }

  Future<List<Category>> getCategories() async {
    return await resourceDataProvider.getCategories();
  }

  Future<bool> createResource(
      {String filename,
      String filePath,
      String year,
      String department,
      String subject,
      String fileType}) async {
    return await resourceDataProvider.createResource(
        filename: filename,
        filePath: filePath,
        year: year,
        department: department,
        subject: subject,
        fileType: fileType);
  }

  Future<Resource> getResource(String id) async {
    return await resourceDataProvider.getResource(id);
  }

  Future<Resource> likeUnlikeResource(String id, String action) async {
    return await resourceDataProvider.likeUnlikeResource(id, action);
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
