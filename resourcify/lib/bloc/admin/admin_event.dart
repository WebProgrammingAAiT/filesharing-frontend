part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetCategories extends AdminEvent {
  const GetCategories();
}

class CreateCategory extends AdminEvent {
  final Category category;
  const CreateCategory(this.category);
}
