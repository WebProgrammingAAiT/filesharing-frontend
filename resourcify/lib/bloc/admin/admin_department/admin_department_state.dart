part of 'admin_department_bloc.dart';

abstract class AdminDepartmentState extends Equatable {
  const AdminDepartmentState();

  @override
  List<Object> get props => [];
}

class AdminDepartmentInitial extends AdminDepartmentState {}

class AdminDepartmentLoading extends AdminDepartmentState {}

class AdminDepartmentError extends AdminDepartmentState {
  final String message;

  AdminDepartmentError(this.message);
  @override
  List<Object> get props => [message];
}

class AdminDepartmentCreated extends AdminDepartmentState {
  final Category category;

  AdminDepartmentCreated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminDepartmentCategoriesLoaded extends AdminDepartmentState {
  final List<Category> categories;

  AdminDepartmentCategoriesLoaded(this.categories);
  List<Object> get props => [categories];
}

class AdminDepartmentUpdated extends AdminDepartmentState {
  final Category category;

  AdminDepartmentUpdated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminDepartmentDeleted extends AdminDepartmentState {}
