import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/login_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

import 'admin_department_screen.dart';
import 'admin_users_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Category> categories;
  // Category parentCategory;
  // String categoryType;
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AdminBloc>(context).add(GetCategories());
    super.initState();
  }

  Future<void> onRefresh() async {
    return context.read<AdminBloc>().add(GetCategories());
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
          IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminUserScreen()));
              })
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          print(state);
          if (state is AdminYearCreated) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Category created successfully!'),
              ),
            );
            BlocProvider.of<AdminBloc>(context).add(GetCategories());
          } else if (state is AdminError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is AdminYearUpdated) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Category updated successfully!'),
              ),
            );
            BlocProvider.of<AdminBloc>(context).add(GetCategories());
          }
        },
        builder: (context, state) {
          if (state is AdminInitial ||
              state is AdminLoading ||
              state is AdminYearUpdated) {
            return _buildCircularProgressIndicator();
          } else if (state is AdminCategoriesLoaded) {
            categories = state.categories;
            return _buildYear(state.categories);
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
            ;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showCreateYearDialog(context)),
    );
  }

  Widget _buildYear(List<Category> categories) {
    List<Category> yearList = [];
    categories.map((cat) {
      if (cat.type == 'year') yearList.add(cat);
    }).toList();
    print(yearList.length);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: yearList.length,
        itemBuilder: (BuildContext context, int index) {
          Category cat = yearList[index];
          return ListTile(
            title: Text(cat.name),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AdminDepartmentScreen(
                        year: cat,
                      )));
            },
          );
        },
      ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1,
      ),
    );
  }

  // Show Dialog function
  void _showCreateYearDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
            title: 'Create new category',
            hintText: 'Name',
            buttonName: 'Create',
            context: context,
            controller: categoryNameController,
            onActionButtonPressed: _createCategory);
      },
    );
  }

  void _createCategory() {
    if (categoryNameController.text.trim().isNotEmpty) {
      Category newCategory = Category(
        name: categoryNameController.text,
        type: 'year',
      );

      categoryNameController.clear();

      BlocProvider.of<AdminBloc>(context).add(CreateYearCategory(newCategory));
      Navigator.of(context).pop();
    }
  }
}
