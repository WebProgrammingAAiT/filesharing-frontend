part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;

  AdminError(this.message);
  @override
  List<Object> get props => [message];
}

class AdminCategoriesLoaded extends AdminState {
  final List<Category> categories;

  AdminCategoriesLoaded(this.categories);
  List<Object> get props => [categories];
}

class AdminYearCreated extends AdminState {
  final Category category;

  AdminYearCreated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminYearUpdated extends AdminState {
  final Category category;

  AdminYearUpdated(this.category);
  @override
  List<Object> get props => [category];
}

class AdminYearCategoriesLoaded extends AdminState {
  final List<Category> categories;

  AdminYearCategoriesLoaded(this.categories);
  List<Object> get props => [categories];
}
