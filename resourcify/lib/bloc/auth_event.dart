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

class SignUp extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUp(this.firstName, this.lastName, this.email, this.password,
      this.confirmPassword);
}

class CheckJwtExists extends AuthEvent {
  const CheckJwtExists();
}

class RemoveJwt extends AuthEvent {
  const RemoveJwt();
}
