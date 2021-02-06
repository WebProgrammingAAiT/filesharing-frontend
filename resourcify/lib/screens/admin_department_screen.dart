import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/admin/admin_department/admin_department_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/admin_subject_screen.dart';

class AdminDepartmentScreen extends StatefulWidget {
  final Category year;

  const AdminDepartmentScreen({Key key, this.year}) : super(key: key);
  @override
  _AdminDepartmentScreenState createState() => _AdminDepartmentScreenState();
}

class _AdminDepartmentScreenState extends State<AdminDepartmentScreen> {
  TextEditingController departmentController = TextEditingController();
  TextEditingController editYearController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AdminDepartmentBloc>(context)
        .add(GetDepartmentCategories(widget.year.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.year.name),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editYearController.text = widget.year.name;
                _showEditYearDialog(context);
              })
        ],
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminLoading || state is AdminYearUpdated) {
            Navigator.pop(context);
          }
        },
        child: BlocConsumer<AdminDepartmentBloc, AdminDepartmentState>(
          listener: (context, state) {
            print(state);
            if (state is AdminDepartmentCreated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category created successfully!'),
                ),
              );
              BlocProvider.of<AdminDepartmentBloc>(context)
                  .add(GetDepartmentCategories(widget.year.id));
            } else if (state is AdminDepartmentUpdated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category updated successfully!'),
                ),
              );
              BlocProvider.of<AdminDepartmentBloc>(context)
                  .add(GetDepartmentCategories(widget.year.id));
            }
          },
          builder: (context, state) {
            if (state is AdminDepartmentInitial ||
                state is AdminDepartmentLoading) {
              return _buildCircularProgressIndicator();
            } else if (state is AdminDepartmentCategoriesLoaded) {
              List<Category> departmentCategories = state.categories;
              return ListView.builder(
                itemCount: departmentCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  Category department = departmentCategories[index];
                  return ListTile(
                    title: Text(department.name),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AdminSubjectScreen(
                            department: department,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('Admin state is =>> $state'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _showDialog(context)),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  // Show Dialog function
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: new Text('Create new department'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: departmentController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Create'),
              onPressed: _createCategory,
            ),
          ],
        );
      },
    );
  }

  // Show Dialog function
  void _showEditYearDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text('Edit department'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: editYearController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Department'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Update'),
              onPressed: _updateYear,
            ),
          ],
        );
      },
    );
  }

  void _createCategory() {
    if (departmentController.text.trim().isNotEmpty) {
      Category newCategory = Category(
          name: departmentController.text,
          type: 'department',
          parentId: widget.year.id);

      departmentController.clear();

      BlocProvider.of<AdminDepartmentBloc>(context)
          .add(CreateDepartmentCategory(newCategory));
      Navigator.of(context).pop();
    }
  }

  void _updateYear() {
    if (editYearController.text.trim().isNotEmpty &&
        widget.year.id.isNotEmpty) {
      BlocProvider.of<AdminBloc>(context).add(UpdateYearCategory(
          Category(name: editYearController.text, id: widget.year.id)));

      Navigator.pop(context);
    }
  }
}
