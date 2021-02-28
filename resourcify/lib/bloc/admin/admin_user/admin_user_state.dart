part of 'admin_user_bloc.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();

  @override
  List<Object> get props => [];
}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<User> users;
  AdminUserLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class AdminUserUpgraded extends AdminUserState {
  final User user;
  AdminUserUpgraded(this.user);
  @override
  List<Object> get props => [user];
}

class AdminUserDowngraded extends AdminUserState {
  final User user;
  AdminUserDowngraded(this.user);
  @override
  List<Object> get props => [user];
}

class AdminUserRemoved extends AdminUserState {
  final String result;
  AdminUserRemoved(this.result);
  @override
  List<Object> get props => [result];
}

class AdminUserError extends AdminUserState {
  final String message;
  AdminUserError(this.message);
  @override
  List<Object> get props => [message];
}
