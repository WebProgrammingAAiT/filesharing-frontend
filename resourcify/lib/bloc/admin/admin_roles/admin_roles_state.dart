part of 'admin_roles_bloc.dart';

abstract class AdminRolesState extends Equatable {
  const AdminRolesState();

  @override
  List<Object> get props => [];
}

class AdminRolesInitial extends AdminRolesState {}

class AdminRolesLoading extends AdminRolesState {}

class AdminRoleLoaded extends AdminRolesState {
  final Role role;
  AdminRoleLoaded(this.role);
  @override
  List<Object> get props => [role];
}

class AdminRoleCreated extends AdminRolesState {}

class AdminRoleDeleted extends AdminRolesState {}

class AdminRolesLoaded extends AdminRolesState {
  final List<Role> roles;

  AdminRolesLoaded(this.roles);
  @override
  List<Object> get props => [roles];
}

class AdminRolesError extends AdminRolesState {
  final String message;

  AdminRolesError(this.message);
  @override
  List<Object> get props => [message];
}
