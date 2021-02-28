import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_resource_event.dart';
part 'admin_resource_state.dart';

class AdminResourceBloc extends Bloc<AdminResourceEvent, AdminResourceState> {
  final AdminRepository adminRepository;
  AdminResourceBloc(this.adminRepository) : super(AdminResourceInitial());

  @override
  Stream<AdminResourceState> mapEventToState(
    AdminResourceEvent event,
  ) async* {
    if (event is GetAdminSubjectResources) {
      try {
        yield AdminResourceLoading();
        var resources = await adminRepository.getSubjectResources(event.id);
        yield AdminResourcesLoaded(resources);
      } catch (e) {
        yield AdminResourceError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
