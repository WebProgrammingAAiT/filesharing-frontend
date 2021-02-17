part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserInfo extends UserEvent {
  const GetUserInfo();
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
