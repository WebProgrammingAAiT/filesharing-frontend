import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/login_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

import 'admin_department_screen.dart';

class AdminUserScreen extends StatefulWidget {
  @override
  _AdminUserScreen createState() => _AdminUserScreen();
}

class _AdminUserScreen extends State<AdminUserScreen> {
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
    ));
  }
}
