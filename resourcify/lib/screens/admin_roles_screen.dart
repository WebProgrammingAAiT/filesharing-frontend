import 'package:flutter/material.dart';
import 'package:resourcify/bloc/admin/admin_roles/admin_roles_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/models/role_model.dart';
import 'package:resourcify/widgets/widgets.dart';

class AdminRolesScreen extends StatefulWidget {
  @override
  _AdminRolesScreenState createState() => _AdminRolesScreenState();
}

class _AdminRolesScreenState extends State<AdminRolesScreen> {
  TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    context.read<AdminRolesBloc>().add(GetAdminRoles());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roles'),
      ),
      body: BlocConsumer<AdminRolesBloc, AdminRolesState>(
        listener: (context, state) {
          print(state);
          if (state is AdminRoleCreated) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Role created successfully!'),
              ),
            );
            BlocProvider.of<AdminRolesBloc>(context).add(GetAdminRoles());
          } else if (state is AdminRolesError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is AdminRoleDeleted) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Role deleted successfully!'),
              ),
            );
            BlocProvider.of<AdminRolesBloc>(context).add(GetAdminRoles());
          }
        },
        builder: (context, state) {
          if (state is AdminRolesLoaded) {
            return ListView.builder(
              itemCount: state.roles.length,
              itemBuilder: (BuildContext context, int index) {
                Role role = state.roles[index];
                return ListTile(
                  title: Text(role.name),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => context
                        .read<AdminRolesBloc>()
                        .add(DeleteAdminRole(role.id)),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showCreateRoleDialog(context)),
    );
  }

  // Show Dialog function
  void _showCreateRoleDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
            title: 'Create new role',
            hintText: 'Name',
            buttonName: 'Create',
            context: context,
            controller: roleController,
            onActionButtonPressed: _createRole);
      },
    );
  }

  void _createRole() {
    if (roleController.text.trim().isNotEmpty) {
      Role newRole = Role(
        name: roleController.text,
      );

      roleController.clear();

      BlocProvider.of<AdminRolesBloc>(context).add(CreateAdminRole(newRole));
      Navigator.of(context).pop();
    }
  }
}
