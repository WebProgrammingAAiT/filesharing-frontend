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

  Future<Role> createRole(Role role) async {
    return await adminDataProvider.createRole(role);
  }

  Future<void> deleteRole(String id) async {
    await adminDataProvider.deleteRole(id);
  }

  Future<List<Role>> getRoles() async {
    return await adminDataProvider.getRoles();
  }

  Future<List<User>> getUsers() async {
    return await adminDataProvider.getUsers();
  }

  Future<void> updateUserRole(Role role, String userId) async {
    await adminDataProvider.updateUserRole(role, userId);
  }
}
