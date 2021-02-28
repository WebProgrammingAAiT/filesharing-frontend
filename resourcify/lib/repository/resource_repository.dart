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
