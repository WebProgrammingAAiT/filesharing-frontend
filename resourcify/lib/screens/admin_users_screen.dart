import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_user/admin_user_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/login_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

import '../bloc/admin/admin_bloc.dart';
import '../bloc/admin/admin_bloc.dart';
import '../models/user_model.dart';
import 'admin_department_screen.dart';

class AdminUserScreen extends StatefulWidget {
  @override
  _AdminUserScreen createState() => _AdminUserScreen();
}

class _AdminUserScreen extends State<AdminUserScreen> {
  List<User> users;
  TextEditingController userRoleController = TextEditingController();

  Future<void> onRefresh() async {
    return context.read<AdminUserBloc>().add(AdminGetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Years'),
        centerTitle: true,
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }),
        ],
      ),
      body: BlocConsumer<AdminUserBloc, AdminUserState>(
          // ignore: missing_return
          builder: (context, state) {
        if (state is AdminInitial || state is AdminLoading) {
          return _buildCircularProgressIndicator();
        } else if (state is AdminUserLoaded) {
          users = state.users;
          return _buildUsers(state.users);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong....',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                RaisedButton(
                  onPressed: onRefresh,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Click to refresh'),
                ),
              ],
            ),
          );
        }
      }, listener: (context, state) {
        print(state);
      }),
    );
  }

  Widget _buildUsers(List<User> users) {
    List<User> userList = [];
    users.map((u) {
      if (u.role == 'user') userList.add(u);
    }).toList();
    print(userList.length);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (BuildContext context, int index) {
          User cat = userList[index];
          return ListTile(
            title: Text(cat.firstName + "  " + cat.lastName),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              userRoleController.text = cat.role;
              _showChangeRoleDialog(context, cat.id, cat.role);
            },
          );
        },
      ),
    );
  }

  void _showChangeRoleDialog(context, String id, String role) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit role"),
            content: Text(
                'Do you want to change the role of this user, or delete them?'),
            actions: [
              FlatButton(
                onPressed: (role == 'user') ? _makeAdmin : _makeUser,
                child:
                    (role == 'user') ? Text('Make admin') : Text('Make user'),
              ),
              FlatButton(child: Text('Delete'), onPressed: _deleteUser)
            ],
          );
        });
  }

  void _deleteUser() {}
  void _makeAdmin() {}
  void _makeUser() {}

  Widget _buildCircularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1,
      ),
    );
  }
}
