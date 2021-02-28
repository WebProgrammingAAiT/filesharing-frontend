import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_department_event.dart';
part 'admin_department_state.dart';

class AdminDepartmentBloc
    extends Bloc<AdminDepartmentEvent, AdminDepartmentState> {
  final AdminRepository adminRepository;
  AdminDepartmentBloc(this.adminRepository) : super(AdminDepartmentInitial());

  @override
  Stream<AdminDepartmentState> mapEventToState(
    AdminDepartmentEvent event,
  ) async* {
    if (event is GetDepartmentCategories) {
      try {
        yield AdminDepartmentLoading();

        var categories = await adminRepository.getCategories();
        if (categories != null) {
          List<Category> departmentList = [];
          categories.forEach((mapCategory) {
            if (mapCategory.parentId == event.yearId) {
              departmentList.add(mapCategory);
            }
          });
          yield AdminDepartmentCategoriesLoaded(departmentList);
        } else {
          yield AdminDepartmentError('Couldn\'t load cateogries');
        }
      } catch (e) {
        yield AdminDepartmentError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is CreateDepartmentCategory) {
      try {
        yield AdminDepartmentLoading();
        Category category =
            await adminRepository.createCategory(event.category);
        if (category != null) {
          yield AdminDepartmentCreated(category);
        } else {
          yield AdminDepartmentError('Couldn\'t create category');
        }
      } catch (e) {
        yield AdminDepartmentError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UpdateDepartmentCategory) {
      try {
        yield AdminDepartmentLoading();
        Category category =
            await adminRepository.updateCategory(event.category);
        if (category != null) {
          yield AdminDepartmentUpdated(category);
        } else {
          yield AdminDepartmentError('Couldn\'t create category');
        }
      } catch (e) {
        yield AdminDepartmentError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DeleteDepartmentCategory) {
      try {
        yield AdminDepartmentLoading();
        await adminRepository.deleteCategory(event.departmentId, 'department');
        yield AdminDepartmentDeleted();
      } catch (e) {
        yield AdminDepartmentError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
