part of 'admin_user_bloc.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object> get props => [];
}

class AdminMakeAdmin extends AdminUserEvent {
  final User user;
  const AdminMakeAdmin(this.user);
}

class AdminRemoveAdmin extends AdminUserEvent {
  final User user;
  const AdminRemoveAdmin(this.user);
}

class AdminGetUsers extends AdminUserEvent {
  final List<User> users;
  const AdminGetUsers(this.users);
}

class AdminRemoveUser extends AdminUserEvent {
  final String subjectId;
  const AdminRemoveUser(this.subjectId);
}
