import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_department/admin_department_bloc.dart';
import 'package:resourcify/bloc/admin/admin_subject/admin_subject_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/admin_resources_screen.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';

class AdminSubjectScreen extends StatefulWidget {
  final Category department;

  const AdminSubjectScreen({Key key, this.department}) : super(key: key);
  @override
  _AdminSubjectScreenState createState() => _AdminSubjectScreenState();
}

class _AdminSubjectScreenState extends State<AdminSubjectScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  List<Category> subjectCategories;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    BlocProvider.of<AdminSubjectBloc>(context)
        .add(GetSubjectCategories(widget.department.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.department.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              departmentController.text = widget.department.name;
              _showEditDeleteDepartmentDialog(context, 'Edit');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              departmentController.text = widget.department.name;
              _showEditDeleteDepartmentDialog(context, 'Delete');
            },
          ),
        ],
      ),
      body: BlocListener<AdminDepartmentBloc, AdminDepartmentState>(
          listener: (context, state) {
            if (state is AdminDepartmentUpdated) {
              Navigator.pop(context);
            } else if (state is AdminDepartmentDeleted) {
              Navigator.pop(context);
            }
          },
          child: BlocConsumer<AdminSubjectBloc, AdminSubjectState>(
            listener: (context, state) {
              print(state);
              if (state is AdminSubjectCreated) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subject created successfully!'),
                  ),
                );
                BlocProvider.of<AdminSubjectBloc>(context)
                    .add(GetSubjectCategories(widget.department.id));
              } else if (state is AdminSubjectError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is AdminSubjectUpdated) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subject updated successfully!'),
                  ),
                );
                BlocProvider.of<AdminSubjectBloc>(context)
                    .add(GetSubjectCategories(widget.department.id));
              } else if (state is AdminSubjectDeleted) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subject deleted successfully!'),
                  ),
                );
                BlocProvider.of<AdminSubjectBloc>(context)
                    .add(GetSubjectCategories(widget.department.id));
              }
            },
            builder: (context, state) {
              if (state is AdminSubjectInitial ||
                  state is AdminSubjectLoading) {
                return _buildCircularProgressIndicator();
              } else if (state is AdminSubjectCategoriesLoaded) {
                this.subjectCategories = state.categories;

                return ListView.builder(
                  itemCount: subjectCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category subject = subjectCategories[index];
                    return ListTile(
                      title: Text(subject.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminResourcesScreen(subject: subject),
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
          )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showCreateSubjectDialog(context)),
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
  void _showCreateSubjectDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
            title: 'Create new subject',
            hintText: 'Name',
            buttonName: 'Create',
            context: context,
            controller: subjectController,
            onActionButtonPressed: _createCategory);
      },
    );
  }

  // Show Dialog function
  void _showEditDeleteDepartmentDialog(context, String action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
          context: context,
          name: 'Department',
          action: action,
          controller: departmentController,
          onActionButtonPressed: () => _updateDeleteDepartment(action),
        );
      },
    );
  }

  void _updateDeleteDepartment(String action) {
    if (departmentController.text.trim().isNotEmpty) {
      if (action == 'Edit') {
        BlocProvider.of<AdminDepartmentBloc>(context).add(
            UpdateDepartmentCategory(Category(
                name: departmentController.text, id: widget.department.id)));
      } else {
        if (subjectCategories == null || subjectCategories.length > 0) {
          SnackBar snackbar = SnackBar(
            content: Text('Please remove each subjects first'),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        } else {
          BlocProvider.of<AdminDepartmentBloc>(context)
              .add(DeleteDepartmentCategory(widget.department.id));
        }
      }

      Navigator.pop(context);
    }
  }

  void _createCategory() {
    if (subjectController.text.trim().isNotEmpty) {
      Category newCategory = Category(
        name: subjectController.text,
        type: 'subject',
        parentId: widget.department.id,
      );

      subjectController.clear();

      BlocProvider.of<AdminSubjectBloc>(context)
          .add(CreateSubjectCategory(newCategory));
      Navigator.of(context).pop();
    }
  }
}
