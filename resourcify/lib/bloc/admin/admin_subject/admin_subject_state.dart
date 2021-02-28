part of 'admin_subject_bloc.dart';

abstract class AdminSubjectState extends Equatable {
  const AdminSubjectState();

  @override
  List<Object> get props => [];
}

class AdminSubjectInitial extends AdminSubjectState {}

class AdminSubjectLoading extends AdminSubjectState {}

class AdminSubjectError extends AdminSubjectState {
  final String message;

  AdminSubjectError(this.message);
  @override
  List<Object> get props => [message];
}

class AdminSubjectCreated extends AdminSubjectState {
  final Category category;

  AdminSubjectCreated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminSubjectCategoriesLoaded extends AdminSubjectState {
  final List<Category> categories;

  AdminSubjectCategoriesLoaded(this.categories);
  List<Object> get props => [categories];
}

class AdminSubjectUpdated extends AdminSubjectState {
  final Category category;

  AdminSubjectUpdated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminSubjectDeleted extends AdminSubjectState {}
