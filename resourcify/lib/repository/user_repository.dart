import 'package:resourcify/data_provider/data_provider.dart';
import 'package:resourcify/models/models.dart';

class UserRepository {
  final UserDataProvider userDataProvider;

  UserRepository({this.userDataProvider});

  Future<User> getUserInfo() async {
    return await userDataProvider.getUserInfo();
  }

  Future<bool> updateUser(
    String userId,
    String firstName,
    String username,
    String currentPassword,
    String newPassword,
    String year,
    String department,
    String profilePicture,
  ) async {
    return await userDataProvider.updateUser(userId, firstName, username,
        currentPassword, newPassword, year, department, profilePicture);
  }

  Future<List<Resource>> getUserResources(String userId) async {
    return await userDataProvider.getUserResources(userId);
  }

  Future<void> deleteUserResource(String id) async {
    await userDataProvider.deleteUserResource(id);
  }

  Future<Resource> updateUserResource(String id, String updatedName) async {
    return await userDataProvider.updateUserResource(id, updatedName);
  }
}
