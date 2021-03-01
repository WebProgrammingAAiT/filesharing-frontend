import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_roles_event.dart';
part 'admin_roles_state.dart';

class AdminRolesBloc extends Bloc<AdminRolesEvent, AdminRolesState> {
  final AdminRepository adminRepository;
  AdminRolesBloc(this.adminRepository) : super(AdminRolesInitial());

  @override
  Stream<AdminRolesState> mapEventToState(
    AdminRolesEvent event,
  ) async* {
    if (event is GetAdminRoles) {
      try {
        yield AdminRolesLoading();
        var roles = await adminRepository.getRoles();
        yield AdminRolesLoaded(roles);
      } catch (e) {
        yield AdminRolesError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is CreateAdminRole) {
      try {
        yield AdminRolesLoading();
        await adminRepository.createRole(event.role);
        yield AdminRoleCreated();
      } catch (e) {
        yield AdminRolesError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DeleteAdminRole) {
      try {
        yield AdminRolesLoading();
        await adminRepository.deleteRole(event.roleId);
        yield AdminRoleDeleted();
      } catch (e) {
        yield AdminRolesError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
