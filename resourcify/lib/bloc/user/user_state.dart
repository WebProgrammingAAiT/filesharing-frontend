part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserInfoLoaded extends UserState {
  final User user;
  UserInfoLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class UserResourcesLoaded extends UserState {
  final List<Resource> resources;

  UserResourcesLoaded(this.resources);
  @override
  List<Object> get props => [resources];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
  @override
  List<Object> get props => [message];
}

class UserResourceUpdated extends UserState {
  final Resource resource;

  UserResourceUpdated(this.resource);
  @override
  List<Object> get props => [resource];
}

class UserResourceDeleted extends UserState {}

class UserInfoUpdated extends UserState {
  final String message;
  const UserInfoUpdated(this.message);
  List<Object> get props => [message];
}

class UserAccountDeleted extends UserState {}
