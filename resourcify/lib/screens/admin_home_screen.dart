import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/admin_year_screen.dart';
import 'package:resourcify/screens/login_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

import 'admin_department_screen.dart';
import 'admin_roles_screen.dart';
import 'admin_users_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        centerTitle: true,
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminYearScreen(),
                      ),
                    ),
                child: Text('Categories')),
            RaisedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminRolesScreen())),
                child: Text('Roles')),
            RaisedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminUsersScreen())),
                child: Text('Users')),
          ],
        ),
      ),
    );
  }
}
