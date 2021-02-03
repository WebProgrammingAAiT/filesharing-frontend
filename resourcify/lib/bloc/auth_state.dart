part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final User user;
  const AuthLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class AuthAdminLoaded extends AuthState {
  final User user;
  const AuthAdminLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class AuthAdminJwtLoaded extends AuthState {
  final String jwt;
  const AuthAdminJwtLoaded(this.jwt);
  @override
  List<Object> get props => [jwt];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

class AuthJwt extends AuthState {
  final String jwt;

  AuthJwt(this.jwt);
  @override
  List<Object> get props => [jwt];
}

class AuthJwtLoaded extends AuthState {
  final String jwt;

  AuthJwtLoaded(this.jwt);
  @override
  List<Object> get props => [jwt];
}

class AuthJwtRemoved extends AuthState {
  const AuthJwtRemoved();
}

class AuthNotLoggedIn extends AuthState {
  const AuthNotLoggedIn();
}
