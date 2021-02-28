part of 'admin_department_bloc.dart';

abstract class AdminDepartmentEvent extends Equatable {
  const AdminDepartmentEvent();

  @override
  List<Object> get props => [];
}

class CreateDepartmentCategory extends AdminDepartmentEvent {
  final Category category;
  const CreateDepartmentCategory(this.category);
}

class UpdateDepartmentCategory extends AdminDepartmentEvent {
  final Category category;
  const UpdateDepartmentCategory(this.category);
}

class GetDepartmentCategories extends AdminDepartmentEvent {
  final String yearId;
  const GetDepartmentCategories(this.yearId);
}

class DeleteDepartmentCategory extends AdminDepartmentEvent {
  final String departmentId;
  const DeleteDepartmentCategory(this.departmentId);
}
