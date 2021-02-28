part of 'admin_users_bloc.dart';

abstract class AdminUsersState extends Equatable {
  const AdminUsersState();

  @override
  List<Object> get props => [];
}

class AdminUsersInitial extends AdminUsersState {}

class AdminUsersLoading extends AdminUsersState {}

class AdminUsersLoaded extends AdminUsersState {
  final List<User> users;

  AdminUsersLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class AdminUserRoleUpdated extends AdminUsersState {}

class AdminUsersError extends AdminUsersState {
  final String message;

  AdminUsersError(this.message);
  @override
  List<Object> get props => [message];
}
