part of 'resource_bloc.dart';

abstract class ResourceState extends Equatable {
  const ResourceState();

  @override
  List<Object> get props => [];
}

class ResourceInitial extends ResourceState {
  const ResourceInitial();
}

class ResourceLoading extends ResourceState {
  const ResourceLoading();
}

class ResourceError extends ResourceState {
  final String message;
  const ResourceError(this.message);

  @override
  List<Object> get props => [message];
}

class ResourcesLoaded extends ResourceState {
  final List<Resource> resources;
  final List<Category> categories;
  ResourcesLoaded(this.resources, this.categories);
  List<Object> get props => [resources, categories];
}

class ResourceCreated extends ResourceState {
  final Resource resource;

  ResourceCreated(this.resource);
  @override
  List<Object> get props => [resource];
}

class ResourceCreating extends ResourceState {
  final int progress;
  const ResourceCreating(this.progress);
}
