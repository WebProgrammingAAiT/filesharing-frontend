import '../models/models.dart';
import '../util/api_end_points.dart' as API;
import 'dart:convert';

class ResourceRepository {
  getResources(String userId) async {
      var response= API.ResourceEndPoints.getResources("userId");
      print(response);
      List<Resource> resourceList = [];
      print(resourceList);
        var resourceListResponse = json.decode(response);
        for (int index = 0; index < resourceListResponse.length; index++) {
          resourceList.add(Resource.fromJson(resourceListResponse[index]));
        }
      return resourceList;
  }

  getResourceDetails(String caseId) async {
    var response = API.ResourceEndPoints.getResourceDetail("resourceId");  
      Resource resource;
        resource = Resource.fromJson(json.decode(response));
      return resource;
  }
}
