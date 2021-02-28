import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/admin_repository.dart';

part 'admin_user_event.dart';
part 'admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final AdminRepository adminRepository;
  AdminUserBloc(AdminUserState initialState, this.adminRepository)
      : super(initialState);

  @override
  Stream<AdminUserState> mapEventToState(AdminUserEvent event) async* {
    if (event is AdminGetUsers) {
      try {
        yield AdminUserLoading();
        var users;
        //do sth with proviers
        yield AdminUserLoaded(users);
      } catch (e) {
        yield AdminUserError(e);
      }
    } else if (event is AdminMakeAdmin) {
      try {
        yield AdminUserLoading();
        var user;
        // do sth with provider
        yield AdminUserUpgraded(user);
      } catch (e) {
        yield AdminUserError(e);
      }
    } else if (event is AdminRemoveAdmin) {
      try {
        yield AdminUserLoading();
        var user;
        // do sth with provider
        yield AdminUserDowngraded(user);
      } catch (e) {
        yield AdminUserError(e);
      }
    } else if (event is AdminRemoveUser) {
      try {
        yield AdminUserLoading();
        var result;
        // do sth with provider
        yield AdminUserRemoved(result);
      } catch (e) {
        yield AdminUserError(e);
      }
    }
  }
}
