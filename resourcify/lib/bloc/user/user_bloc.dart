import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetUserInfo) {
      yield UserLoading();
      try {
        User user = await userRepository.getUserInfo();
        yield UserInfoLoaded(user);
      } catch (e) {
        yield UserError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is GetUserResources) {
      yield UserLoading();
      try {
        List<Resource> resources =
            await userRepository.getUserResources(event.userId);
        yield UserResourcesLoaded(resources);
      } catch (e) {
        yield UserError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UpdateUserResource) {
      yield UserLoading();
      try {
        Resource resource =
            await userRepository.updateUserResource(event.id, event.name);

        yield UserResourceUpdated(resource);
      } catch (e) {
        yield UserError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DeleteUserResource) {
      yield UserLoading();
      try {
        await userRepository.deleteUserResource(event.id);
        yield UserResourceDeleted();
      } catch (e) {
        yield UserError(e.toString() ?? 'An unknown error occured');
      }
    }
  }
}
