part of 'add_resource_bloc.dart';

abstract class AddResourceState extends Equatable {
  const AddResourceState();

  @override
  List<Object> get props => [];
}

class AddResourceInitial extends AddResourceState {}

class AddResourceLoading extends AddResourceState {
  // final double progress;
  const AddResourceLoading();
  // @override
  // List<Object> get props => [progress];
}

class AddResourceError extends AddResourceState {
  final String message;
  const AddResourceError(this.message);
  @override
  List<Object> get props => [message];
}

class ResourceCreated extends AddResourceState {
  // final Resource resource;

  ResourceCreated();
  // @override
  // List<Object> get props => [resource];
}
