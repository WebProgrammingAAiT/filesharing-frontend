import 'package:flutter/material.dart';
import 'package:resourcify/bloc/admin/admin_roles/admin_roles_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_users/admin_users_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/models/role_model.dart';
import 'package:resourcify/widgets/widgets.dart';

class AdminUsersScreen extends StatefulWidget {
  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  TextEditingController roleController = TextEditingController();
  Role role;
  List<Role> roles = [];

  @override
  void initState() {
    context.read<AdminRolesBloc>().add(GetAdminRoles());
    context.read<AdminUsersBloc>().add(GetAdminUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roles'),
      ),
      body: BlocListener<AdminRolesBloc, AdminRolesState>(
          listener: (context, state) {
            print(state);
            if (state is AdminRolesLoaded) {
              roles = state.roles;
            } else if (state is AdminRolesError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocConsumer<AdminUsersBloc, AdminUsersState>(
            listener: (context, state) {
              print(state);
              if (state is AdminUserRoleUpdated) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User role changed successfully!'),
                  ),
                );
                BlocProvider.of<AdminUsersBloc>(context).add(GetAdminUsers());
              } else if (state is AdminUsersError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminUsersLoaded) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = state.users[index];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.role.name),
                      trailing: TextButton(
                        onPressed: () =>
                            _showChangeUserRoleDialog(context, user),
                        child: Text('Change role'),
                      ),
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  // Show Dialog function
  void _showChangeUserRoleDialog(context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, dialogState) {
          return AlertDialog(
            title: Text('Change user role'),
            content: DropdownButton<Role>(
              isExpanded: true,
              hint: Text(user.role.name),
              underline: SizedBox.shrink(),
              value: role,
              onChanged: (rol) {
                dialogState(() {
                  role = rol;
                });
              },
              items: roles.map<DropdownMenuItem<Role>>((Role r) {
                return DropdownMenuItem<Role>(
                  value: r,
                  child: Text(r.name),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Update'),
                onPressed: () {
                  context
                      .read<AdminUsersBloc>()
                      .add(UpdateUserRole(role, user.id));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }
}
