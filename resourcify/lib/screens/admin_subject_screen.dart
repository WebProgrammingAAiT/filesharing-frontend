import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_department/admin_department_bloc.dart';
import 'package:resourcify/bloc/admin/admin_subject/admin_subject_bloc.dart';
import 'package:resourcify/models/models.dart';

class AdminSubjectScreen extends StatefulWidget {
  final Category department;

  const AdminSubjectScreen({Key key, this.department}) : super(key: key);
  @override
  _AdminSubjectScreenState createState() => _AdminSubjectScreenState();
}

class _AdminSubjectScreenState extends State<AdminSubjectScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController editSubjectController = TextEditingController();

  TextEditingController departmentController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AdminSubjectBloc>(context)
        .add(GetSubjectCategories(widget.department.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.department.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              departmentController.text = widget.department.name;
              _showEditDepartmentDialog(context);
            },
          ),
        ],
      ),
      body: BlocListener<AdminDepartmentBloc, AdminDepartmentState>(
          listener: (context, state) {
            if (state is AdminDepartmentLoading ||
                state is AdminDepartmentUpdated) {
              Navigator.pop(context);
            }
          },
          child: BlocConsumer<AdminSubjectBloc, AdminSubjectState>(
            listener: (context, state) {
              print(state);
              if (state is AdminSubjectCreated) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Category created successfully!'),
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
                    content: Text('Category updated successfully!'),
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
                List<Category> subjectCategories = state.categories;

                return ListView.builder(
                  itemCount: subjectCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category subject = subjectCategories[index];
                    return ListTile(
                      title: Text(subject.name),
                      onTap: () {
                        editSubjectController.text = subject.name;
                        _showEditSubjectDialog(context, subject.id);
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
          title: Text('Create new subject'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: subjectController,
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
  void _showEditSubjectDialog(context, String subjectId) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text('Edit subject'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: editSubjectController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Subject'),
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
              onPressed: () => _updateSubject(subjectId),
            ),
          ],
        );
      },
    );
  }

  // Show Dialog function
  void _showEditDepartmentDialog(context) {
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
                  controller: departmentController,
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
              onPressed: _updateDepartment,
            ),
          ],
        );
      },
    );
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

  void _updateSubject(String subjectId) {
    if (editSubjectController.text.trim().isNotEmpty && subjectId.isNotEmpty) {
      BlocProvider.of<AdminSubjectBloc>(context).add(UpdateSubjectCategory(
          Category(name: editSubjectController.text, id: subjectId)));
      Navigator.pop(context);
    }
  }

  void _updateDepartment() {
    if (departmentController.text.trim().isNotEmpty &&
        widget.department.id.isNotEmpty) {
      BlocProvider.of<AdminDepartmentBloc>(context).add(
          UpdateDepartmentCategory(Category(
              name: departmentController.text, id: widget.department.id)));

      Navigator.pop(context);
    }
  }
}
