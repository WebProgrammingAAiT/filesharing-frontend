part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserInfo extends UserEvent {
  const GetUserInfo();
}

class UpdateUserInfo extends UserEvent {
  final String userId;
  final String firstName;
  final String username;
  final String currentPassword;
  final String newPassword;
  final String year;
  final String department;
  final String profilePicture;
  const UpdateUserInfo({
    this.userId,
    this.firstName,
    this.username,
    this.currentPassword,
    this.newPassword,
    this.year,
    this.department,
    this.profilePicture,
  });
}

class GetUserResources extends UserEvent {
  final String userId;
  const GetUserResources(this.userId);
}

class UpdateUserResource extends UserEvent {
  final String name;
  final String id;
  UpdateUserResource(this.id, this.name);
}

class DeleteUserResource extends UserEvent {
  final String id;
  DeleteUserResource(this.id);
}

class DeleteUserAccount extends UserEvent {
  final String userId;
  DeleteUserAccount(this.userId);
}
