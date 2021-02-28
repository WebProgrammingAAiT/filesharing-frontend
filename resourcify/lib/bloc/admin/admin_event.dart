part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetCategories extends AdminEvent {
  const GetCategories();
}

class CreateYearCategory extends AdminEvent {
  final Category category;
  const CreateYearCategory(this.category);
}

class UpdateYearCategory extends AdminEvent {
  final Category category;
  const UpdateYearCategory(this.category);
}

class DeleteYearCategory extends AdminEvent {
  final String yearId;
  const DeleteYearCategory(this.yearId);
}
