part of 'admin_resource_bloc.dart';

abstract class AdminResourceState extends Equatable {
  const AdminResourceState();

  @override
  List<Object> get props => [];
}

class AdminResourceInitial extends AdminResourceState {}

class AdminResourceLoading extends AdminResourceState {}

class AdminResourcesLoaded extends AdminResourceState {
  final List<Resource> resources;

  AdminResourcesLoaded(this.resources);
  List<Object> get props => [resources];
}

class AdminResourceError extends AdminResourceState {
  final String message;

  AdminResourceError(this.message);
  @override
  List<Object> get props => [message];
}
