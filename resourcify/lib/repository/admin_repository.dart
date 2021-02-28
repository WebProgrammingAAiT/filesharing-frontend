import 'package:resourcify/data_provider/admin_data_provider.dart';
import 'package:resourcify/models/models.dart';

class AdminRepository {
  final AdminDataProvider adminDataProvider;
  const AdminRepository(this.adminDataProvider);

  Future<List<Category>> getCategories() async {
    return await adminDataProvider.getCategories();
  }

  Future<Category> createCategory(Category category) async {
    return await adminDataProvider.createCategory(category);
  }

  Future<Category> updateCategory(Category category) async {
    return await adminDataProvider.updateCategory(category);
  }

  Future<void> deleteCategory(String id, String categoryType) async {
    await adminDataProvider.deleteCategory(id, categoryType);
  }

  Future<List<Resource>> getSubjectResources(String id) async {
    return await adminDataProvider.getSubjectResources(id);
  }
}
