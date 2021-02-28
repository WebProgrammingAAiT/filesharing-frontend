import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_subject_event.dart';
part 'admin_subject_state.dart';

class AdminSubjectBloc extends Bloc<AdminSubjectEvent, AdminSubjectState> {
  final AdminRepository adminRepository;

  AdminSubjectBloc(this.adminRepository) : super(AdminSubjectInitial());

  @override
  Stream<AdminSubjectState> mapEventToState(
    AdminSubjectEvent event,
  ) async* {
    if (event is GetSubjectCategories) {
      try {
        yield AdminSubjectLoading();

        var categories = await adminRepository.getCategories();
        if (categories != null) {
          List<Category> subjectList = [];
          categories.forEach((mapCategory) {
            if (mapCategory.parentId == event.departmentId) {
              subjectList.add(mapCategory);
            }
          });
          yield AdminSubjectCategoriesLoaded(subjectList);
        } else {
          yield AdminSubjectError('Couldn\'t load cateogries');
        }
      } catch (e) {
        yield AdminSubjectError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is CreateSubjectCategory) {
      try {
        yield AdminSubjectLoading();
        Category category =
            await adminRepository.createCategory(event.category);
        if (category != null) {
          yield AdminSubjectCreated(category);
        } else {
          yield AdminSubjectError('Couldn\'t create category');
        }
      } catch (e) {
        yield AdminSubjectError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UpdateSubjectCategory) {
      try {
        yield AdminSubjectLoading();
        Category category =
            await adminRepository.updateCategory(event.category);
        if (category != null) {
          yield AdminSubjectUpdated(category);
        } else {
          yield AdminSubjectError('Couldn\'t update category');
        }
      } catch (e) {
        yield AdminSubjectError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DeleteSubjectCategory) {
      try {
        yield AdminSubjectLoading();
        await adminRepository.deleteCategory(event.subjectId, 'subject');
        yield AdminSubjectDeleted();
      } catch (e) {
        yield AdminSubjectError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
