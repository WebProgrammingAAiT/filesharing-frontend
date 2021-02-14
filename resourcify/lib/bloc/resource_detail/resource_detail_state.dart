part of 'resource_detail_bloc.dart';

abstract class ResourceDetailState extends Equatable {
  const ResourceDetailState();

  @override
  List<Object> get props => [];
}

class ResourceDetailInitial extends ResourceDetailState {}

class ResourceDetailLoading extends ResourceDetailState {
  const ResourceDetailLoading();
}

class ResourceDetailLoaded extends ResourceDetailState {
  final Resource resource;
  const ResourceDetailLoaded(this.resource);
  @override
  List<Object> get props => [resource];
}

class ResourceDetailError extends ResourceDetailState {
  final String message;
  const ResourceDetailError(this.message);
  @override
  List<Object> get props => [message];
}
