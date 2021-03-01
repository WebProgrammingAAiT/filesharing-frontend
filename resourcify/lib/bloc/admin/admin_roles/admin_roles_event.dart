part of 'admin_roles_bloc.dart';

abstract class AdminRolesEvent extends Equatable {
  const AdminRolesEvent();

  @override
  List<Object> get props => [];
}

class CreateAdminRole extends AdminRolesEvent {
  final Role role;
  CreateAdminRole(this.role);
}

class GetAdminRoles extends AdminRolesEvent {}

class DeleteAdminRole extends AdminRolesEvent {
  final String roleId;
  DeleteAdminRole(this.roleId);
}
