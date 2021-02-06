import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository adminRepository;
  AdminBloc(this.adminRepository) : super(AdminInitial());

  @override
  Stream<AdminState> mapEventToState(
    AdminEvent event,
  ) async* {
    if (event is GetCategories) {
      try {
        yield AdminLoading();
        var categories = await adminRepository.getCategories();
        if (categories != null) {
          yield AdminCategoriesLoaded(categories);
        } else {
          yield AdminError('Couldn\'t load cateogries');
        }
      } catch (e) {
        yield AdminError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is CreateCategory) {
      try {
        yield AdminLoading();
        String message = await adminRepository.createCategory(event.category);
        if (message != null) {
          yield AdminCategoryCreated(message);
        } else {
          yield AdminError('Couldn\'t create category');
        }
      } catch (e) {
        yield AdminError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
