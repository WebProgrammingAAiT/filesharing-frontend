import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_users_event.dart';
part 'admin_users_state.dart';

class AdminUsersBloc extends Bloc<AdminUsersEvent, AdminUsersState> {
  final AdminRepository adminRepository;

  AdminUsersBloc(this.adminRepository) : super(AdminUsersInitial());

  @override
  Stream<AdminUsersState> mapEventToState(
    AdminUsersEvent event,
  ) async* {
    if (event is GetAdminUsers) {
      try {
        yield AdminUsersLoading();
        var users = await adminRepository.getUsers();
        yield AdminUsersLoaded(users);
      } catch (e) {
        yield AdminUsersError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UpdateUserRole) {
      try {
        yield AdminUsersLoading();
        await adminRepository.updateUserRole(event.role, event.userId);
        yield AdminUserRoleUpdated();
      } catch (e) {
        yield AdminUsersError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
