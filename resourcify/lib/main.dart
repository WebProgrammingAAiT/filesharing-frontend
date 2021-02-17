import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/data_provider/data_provider.dart';
import 'package:resourcify/repository/repository.dart';
import 'package:resourcify/screens/screens.dart';
import 'bloc/add_resource/add_resource_bloc.dart';
import 'bloc/admin/admin_bloc.dart';
import 'bloc/admin/admin_department/admin_department_bloc.dart';
import 'bloc/admin/admin_subject/admin_subject_bloc.dart';
import 'bloc/resource/resource_bloc.dart';
import 'bloc/resource_detail/resource_detail_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  final ResourceRepository resourceRepository = ResourceRepository(
    ResourceDataProvider(
      httpClient: http.Client(),
    ),
  );

  final AdminRepository adminRepository =
      AdminRepository(AdminDataProvider(httpClient: http.Client()));

  final AuthRepository authRepository = AuthRepository(
      authDataProvider: AuthDataProvider(httpClient: http.Client()));
  runApp(MyApp(
    resourceRepository: resourceRepository,
    adminRepository: adminRepository,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ResourceRepository resourceRepository;
  final AdminRepository adminRepository;
  final AuthRepository authRepository;

  const MyApp(
      {Key key,
      this.resourceRepository,
      this.adminRepository,
      this.authRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(this.authRepository),
          ),
          BlocProvider(
            create: (context) => AdminBloc(this.adminRepository),
          ),
          BlocProvider(
              create: (context) => AdminDepartmentBloc(this.adminRepository)),
          BlocProvider(
              create: (context) => AdminSubjectBloc(this.adminRepository)),
          BlocProvider(
            create: (context) => ResourceBloc(this.resourceRepository),
          ),
          BlocProvider(
            create: (context) => AddResourceBloc(this.resourceRepository),
          ),
          BlocProvider(
            create: (context) => ResourceDetailBloc(this.resourceRepository),
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
