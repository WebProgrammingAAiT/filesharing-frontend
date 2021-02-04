part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends AuthEvent {
  final String email;
  final String password;

  const SignIn(this.email, this.password);
}

class CheckJwtExists extends AuthEvent {
  const CheckJwtExists();
}

class RemoveJwt extends AuthEvent {
  const RemoveJwt();
}
