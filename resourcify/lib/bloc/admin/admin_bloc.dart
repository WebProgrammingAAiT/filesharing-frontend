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
    } else if (event is CreateYearCategory) {
      try {
        yield AdminLoading();
        Category category =
            await adminRepository.createCategory(event.category);
        if (category != null) {
          yield AdminYearCreated(category);
        } else {
          yield AdminError('Couldn\'t create category');
        }
      } catch (e) {
        yield AdminError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UpdateYearCategory) {
      try {
        yield AdminLoading();
        Category category =
            await adminRepository.updateCategory(event.category);
        if (category != null) {
          yield AdminYearUpdated(category);
        } else {
          yield AdminError('Couldn\'t update category');
        }
      } catch (e) {
        yield AdminError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DeleteYearCategory) {
      try {
        yield AdminLoading();
        await adminRepository.deleteCategory(event.yearId, 'year');
        yield AdminYearDeleted();
      } catch (e) {
        yield AdminError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
