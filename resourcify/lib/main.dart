import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/repository/admin_repository.dart';
import 'package:resourcify/repository/auth_repository.dart';
import 'package:resourcify/repository/resource_repository.dart';
import 'package:resourcify/screens/admin_home_screen.dart';
import 'package:resourcify/screens/home_screen.dart';
import 'package:resourcify/screens/screens.dart';

import 'bloc/admin/admin_bloc.dart';
import 'bloc/admin/admin_department/admin_department_bloc.dart';
import 'bloc/admin/admin_subject/admin_subject_bloc.dart';
import 'bloc/resource/resource_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(AuthRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => AdminBloc(AdminRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => AdminDepartmentBloc(AdminRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => AdminSubjectBloc(AdminRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => ResourceBloc(ResourceRepositoryImpl()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Resourcify',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: _DisplayScreen(),
        ));
  }
}

class _DisplayScreen extends StatefulWidget {
  @override
  __DisplayScreenState createState() => __DisplayScreenState();
}

class __DisplayScreenState extends State<_DisplayScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<AuthBloc>(context).add(CheckJwtExists());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text("State is $state"),
            ),
          );
        }
      },
      listener: (context, state) {
        print(state);
        if (state is AuthAdminJwtLoaded || state is AuthAdminLoaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AdminHomeScreen(),
            ),
          );
        } else if (state is AuthJwtLoaded || state is AuthLoaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ),
          );
        } else if (state is AuthNotLoggedIn || state is AuthJwtRemoved) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        }
      },
    );
  }
}
