import 'package:dynamic_treeview/dynamic_treeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/screens/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<AdminBloc>(context).add(GetCategories());
  }

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
      body: BlocConsumer<AdminBloc, AdminState>(listener: (context, state) {
        print(state);
      }, builder: (context, state) {
        if (state is AdminInitial || state is AdminLoading) {
          return _buildCircularProgressIndicator();
        } else if (state is AdminCategoriesLoaded) {
          return _buildDynamicTree(state.categories);
        } else {
          return Center(
            child: Text('Auth state is =>> $state'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed:(){}),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildDynamicTree(List<BaseData> categories) {
    print(categories[0].getId());
    return Container(
      height: double.infinity,
      child: DynamicTreeView(
        data: categories,
        config: Config(
            parentTextStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            rootId: "1",
            parentPaddingEdgeInsets:
                EdgeInsets.only(left: 16, top: 0, bottom: 0)),
        onTap: (m) {
        print("onChildTap -> $m");
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (ctx) => ScreenTwo(
//                  data: m,
//                )));
        },
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

