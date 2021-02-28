import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/admin/admin_department/admin_department_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/admin_subject_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

class AdminDepartmentScreen extends StatefulWidget {
  final Category year;

  const AdminDepartmentScreen({Key key, this.year}) : super(key: key);
  @override
  _AdminDepartmentScreenState createState() => _AdminDepartmentScreenState();
}

class _AdminDepartmentScreenState extends State<AdminDepartmentScreen> {
  TextEditingController departmentController = TextEditingController();
  TextEditingController editYearController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Category> departmentCategories;

  @override
  void initState() {
    BlocProvider.of<AdminDepartmentBloc>(context)
        .add(GetDepartmentCategories(widget.year.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.year.name),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editYearController.text = widget.year.name;
                _showEditDeleteYearDialog(context, 'Edit');
              }),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              editYearController.text = widget.year.name;
              _showEditDeleteYearDialog(context, 'Delete');
            },
          ),
        ],
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminYearUpdated) {
            Navigator.pop(context);
          } else if (state is AdminYearDeleted) {
            Navigator.pop(context);
          }
        },
        child: BlocConsumer<AdminDepartmentBloc, AdminDepartmentState>(
          listener: (context, state) {
            print(state);
            if (state is AdminDepartmentCreated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Department created successfully!'),
                ),
              );
              BlocProvider.of<AdminDepartmentBloc>(context)
                  .add(GetDepartmentCategories(widget.year.id));
            } else if (state is AdminDepartmentUpdated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Department updated successfully!'),
                ),
              );
              BlocProvider.of<AdminDepartmentBloc>(context)
                  .add(GetDepartmentCategories(widget.year.id));
            } else if (state is AdminDepartmentDeleted) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Department deleted Successfully'),
                ),
              );
              BlocProvider.of<AdminDepartmentBloc>(context)
                  .add(GetDepartmentCategories(widget.year.id));
            } else if (state is AdminDepartmentError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminDepartmentInitial ||
                state is AdminDepartmentLoading) {
              return _buildCircularProgressIndicator();
            } else if (state is AdminDepartmentCategoriesLoaded) {
              this.departmentCategories = state.categories;
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
          child: Icon(Icons.add),
          onPressed: () => _showCreateDepartmentDialog(context)),
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
  void _showEditDeleteYearDialog(context, String action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
          context: context,
          name: 'Year',
          action: action,
          controller: editYearController,
          onActionButtonPressed: () => _updateDeleteYear(action),
        );
      },
    );
  }

  void _updateDeleteYear(String action) {
    if (editYearController.text.trim().isNotEmpty) {
      if (action == 'Edit') {
        BlocProvider.of<AdminBloc>(context).add(UpdateYearCategory(
            Category(name: editYearController.text, id: widget.year.id)));
      } else {
        if (departmentCategories == null || departmentCategories.length > 0) {
          SnackBar snackbar = SnackBar(
            content: Text('Please remove each departments first'),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        } else {
          BlocProvider.of<AdminBloc>(context)
              .add(DeleteYearCategory(widget.year.id));
        }
      }

      Navigator.pop(context);
    }
  }

  // Show Dialog function
  void _showCreateDepartmentDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
            title: 'Create new department',
            hintText: 'Name',
            buttonName: 'Create',
            context: context,
            controller: departmentController,
            onActionButtonPressed: _createCategory);
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
}
