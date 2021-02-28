part of 'admin_resource_bloc.dart';

abstract class AdminResourceEvent extends Equatable {
  const AdminResourceEvent();

  @override
  List<Object> get props => [];
}

class GetAdminSubjectResources extends AdminResourceEvent {
  final String id;

  GetAdminSubjectResources(this.id);
}
