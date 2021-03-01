part of 'admin_users_bloc.dart';

abstract class AdminUsersEvent extends Equatable {
  const AdminUsersEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserRole extends AdminUsersEvent {
  final Role role;
  final String userId;
  UpdateUserRole(this.role, this.userId);
}

class GetAdminUsers extends AdminUsersEvent {}
