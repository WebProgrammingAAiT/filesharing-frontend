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
