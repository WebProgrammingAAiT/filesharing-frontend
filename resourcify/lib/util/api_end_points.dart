class ResourceEndPoints {
  static String getResources(String userId) {
    // return "http://localhost:8080/api/resources?reqby=" +
    //     userId;
    return "["+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+","+getResourceDetail("")+"]";
  }

  static String getResourceDetail(String resourceId) {
    // return "http://localhost:8080/api/resources/" +
    //     resourceId;
    return '{"_id":"5e91751e832d0e2791565592", "resource_name": "Intro to HCI", "year": "3rd", "department": "ITSC", "subject": "HCI",    "created_by": "username","likes": 0, "dislikes": 0, "fileSize": 2.5, "fileType": "pdf", "files": ["intro"],"is_liked": true, "is_disliked": false}';
  }
}
