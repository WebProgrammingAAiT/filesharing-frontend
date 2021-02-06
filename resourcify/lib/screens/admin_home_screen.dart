import 'package:dynamic_treeview/dynamic_treeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Category> categories;
  Category parentCategory;
  String categoryType;
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AdminBloc>(context).add(GetCategories());
    super.initState();
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
        if (state is AdminCategoryCreated) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          BlocProvider.of<AdminBloc>(context).add(GetCategories());
        }
      }, builder: (context, state) {
        if (state is AdminInitial || state is AdminLoading) {
          return _buildCircularProgressIndicator();
        } else if (state is AdminCategoriesLoaded) {
          categories = state.categories;
          return _buildDynamicTree(state.categories);
        } else {
          return Center(
            child: Text('Admin state is =>> $state'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _showDialog(context)),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildDynamicTree(List<BaseData> categories) {
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

  // Show Dialog function
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return StatefulBuilder(builder: (context, StateSetter dropdownState) {
          return AlertDialog(
            title: new Text('Create new category'),
            content: Container(
              height: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: categoryNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  DropdownButton<Category>(
                    hint: Text('select a parent category'),
                    value: parentCategory,
                    onChanged: (cat) {
                      dropdownState(() {
                        parentCategory = cat;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<Category>>((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                      hint: Text('select a type'),
                      value: categoryType,
                      onChanged: (type) {
                        dropdownState(() {
                          categoryType = type;
                        });
                      },
                      items: <String>['year', 'department', 'subject']
                          .map<DropdownMenuItem<String>>((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList())
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Create'),
                onPressed: _createCategory,
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
      },
    );
  }

  void _createCategory() {
    if (categoryNameController.text.trim().isNotEmpty &&
        parentCategory != null &&
        categoryType != null) {
      Category newCategory;
      if (parentCategory.name != 'Root') {
        newCategory = Category(
            name: categoryNameController.text,
            type: categoryType,
            parentId: parentCategory.id);
      } else {
        newCategory =
            Category(name: categoryNameController.text, type: categoryType);
      }
      categoryNameController.clear();
      parentCategory = null;
      categoryType = null;
      BlocProvider.of<AdminBloc>(context).add(CreateCategory(newCategory));
      Navigator.of(context).pop();
    }
  }
}
