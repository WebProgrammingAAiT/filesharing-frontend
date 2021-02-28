import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_resource/admin_resource_bloc.dart';
import 'package:resourcify/bloc/admin/admin_subject/admin_subject_bloc.dart';
import 'package:resourcify/bloc/user/user_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/widgets/widgets.dart';

class AdminResourcesScreen extends StatefulWidget {
  final Category subject;

  const AdminResourcesScreen({Key key, this.subject}) : super(key: key);
  @override
  _AdminResourcesScreenState createState() => _AdminResourcesScreenState();
}

class _AdminResourcesScreenState extends State<AdminResourcesScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController editSubjectController = TextEditingController();
  @override
  void initState() {
    context
        .read<AdminResourceBloc>()
        .add(GetAdminSubjectResources(widget.subject.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editSubjectController.text = widget.subject.name;
              _showEditDeleteSubjectDialog(context, 'Edit');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              editSubjectController.text = widget.subject.name;
              _showEditDeleteSubjectDialog(context, 'Delete');
            },
          ),
        ],
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          print(state);
          if (state is UserResourceDeleted) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Resource deleted Successfully'),
              ),
            );
            context
                .read<AdminResourceBloc>()
                .add(GetAdminSubjectResources(widget.subject.id));
          } else if (state is UserError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocListener<AdminSubjectBloc, AdminSubjectState>(
          listener: (context, state) {
            print(state);
            if (state is AdminSubjectUpdated) {
              Navigator.pop(context);
            } else if (state is AdminSubjectDeleted) {
              Navigator.pop(context);
            }
          },
          child: BlocConsumer<AdminResourceBloc, AdminResourceState>(
            listener: (context, state) {
              print(state);
              if (state is AdminResourceError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminResourcesLoaded) {
                return ListView.builder(
                    itemCount: state.resources.length,
                    itemBuilder: (context, index) {
                      Resource resource = state.resources[index];
                      return ResourceWidget(
                        resource: resource,
                        isAdmin: true,
                        onDeleteClicked: () =>
                            _showDeleteResourceDialog(context, resource),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Show Dialog function
  void _showDeleteResourceDialog(context, Resource resource) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this resource?'),
          content: Row(
            children: [
              Text('Resource Name:'),
              SizedBox(
                width: 10,
              ),
              Text(resource.resourceName)
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () => _deleteResource(resource),
            ),
          ],
        );
      },
    );
  }

  void _deleteResource(Resource resource) {
    BlocProvider.of<UserBloc>(context).add(DeleteUserResource(resource.id));
    Navigator.pop(context);
  }

  // Show Dialog function
  void _showEditDeleteSubjectDialog(context, String action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogContainer(
          context: context,
          name: 'subject',
          action: action,
          controller: editSubjectController,
          onActionButtonPressed: () => _updateDeleteSubject(action),
        );
      },
    );
  }

  void _updateDeleteSubject(String action) {
    if (editSubjectController.text.trim().isNotEmpty) {
      action == 'Edit'
          ? BlocProvider.of<AdminSubjectBloc>(context).add(
              UpdateSubjectCategory(Category(
                  name: editSubjectController.text, id: widget.subject.id)))
          : BlocProvider.of<AdminSubjectBloc>(context)
              .add(DeleteSubjectCategory(widget.subject.id));

      Navigator.pop(context);
    }
  }
}
