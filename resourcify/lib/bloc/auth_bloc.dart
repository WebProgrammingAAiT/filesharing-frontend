import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignUp) {
      try {
        yield AuthLoading();
        var user = await authRepository.signUp(event.firstName, event.lastName,
            event.email, event.password, event.confirmPassword);
        if (user != null) {
          yield AuthLoaded(user);
        } else {
          yield AuthError('Invalid credentials...');
        }
      } catch (e) {
        yield AuthError(e.toString() ?? 'An unknown error occured');
      }
    }
    if (event is SignIn) {
      try {
        yield AuthLoading();
        var user = await authRepository.signIn(event.email, event.password);
        if (user != null) {
          if (user.role.name == 'admin') {
            yield AuthAdminLoaded(user);
          } else {
            yield AuthLoaded(user);
          }
        } else {
          yield AuthError('Invalid credentials...');
        }
      } catch (e) {
        yield AuthError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is CheckJwtExists) {
      yield AuthLoading();
      var jwt = await authRepository.jwtOrEmpty();
      if (jwt == '') {
        yield AuthNotLoggedIn();
      } else {
        var splittedJwt = jwt.split(".");
        var payload = json.decode(
            ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
        if (payload['role'] == 'admin') {
          yield AuthAdminJwtLoaded(jwt);
        } else {
          yield AuthJwtLoaded(jwt);
        }
      }
    } else if (event is RemoveJwt) {
      await authRepository.removeJwt();
      yield AuthJwtRemoved();
    }
  }
}
