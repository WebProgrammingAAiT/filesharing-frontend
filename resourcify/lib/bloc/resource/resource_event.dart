part of 'resource_bloc.dart';

class ResourceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchResources extends ResourceEvent {
  final userId;
  FetchResources(this.userId);
}

class FetchResourceDetail extends ResourceEvent {
  final resourceId;
  FetchResourceDetail(this.resourceId);
}

class ReloadResources extends ResourceEvent {
  final userId;
  ReloadResources(this.userId);
}


