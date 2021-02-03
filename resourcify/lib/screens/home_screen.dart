import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthJwtRemoved) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      },
      builder: (context, state) {
        if (state is AuthLoaded || state is AuthJwtLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text("This is user's home screen"),
              actions: [
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
                    })
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('Auth state isin homescreen =>> $state'),
            ),
          );
        }
      },
    );
  }
}
