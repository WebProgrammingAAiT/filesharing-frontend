part of 'admin_subject_bloc.dart';

abstract class AdminSubjectEvent extends Equatable {
  const AdminSubjectEvent();

  @override
  List<Object> get props => [];
}

class CreateSubjectCategory extends AdminSubjectEvent {
  final Category category;
  const CreateSubjectCategory(this.category);
}

class UpdateSubjectCategory extends AdminSubjectEvent {
  final Category category;
  const UpdateSubjectCategory(this.category);
}

class GetSubjectCategories extends AdminSubjectEvent {
  final String departmentId;
  const GetSubjectCategories(this.departmentId);
}
