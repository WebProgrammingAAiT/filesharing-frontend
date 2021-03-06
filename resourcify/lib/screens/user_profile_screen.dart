import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/bloc/user/user_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:resourcify/widgets/alert_dialog_container.dart';
import 'package:resourcify/widgets/resource_description_container.dart';
import 'package:resourcify/widgets/resource_image_container.dart';
import 'package:resourcify/widgets/widgets.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  UserProfileScreen({this.userId});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _toggleDisplayPosts = 0; // 0 - image, 1- pdf
  int _numberOfPost = 0;
  String _currentUserId = '';
  final storage = new FlutterSecureStorage();
  TextEditingController _resourceEditController = TextEditingController();
  Category year;
  Category department;
  Category subject;
  List<Category> categories = [];
  List<Category> departmentList = [];
  List<Category> yearList = [];
  List<Category> subjectList = [];

  @override
  void initState() {
    super.initState();
    storage.read(key: 'userId').then((value) => setState(() {
          _currentUserId = value;
        }));
    context.read<UserBloc>().add(GetUserResources(widget.userId));
    context.read<AdminBloc>().add(GetCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Resourcify",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: <Widget>[
          _currentUserId == widget.userId
              ? IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
                    // Navigator.pushReplacement(
                    //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  },
                )
              : SizedBox.shrink()
        ],
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminCategoriesLoaded) {
            categories = state.categories;
            yearList = categories.where((cat) => cat.type == 'year').toList();
          }
        },
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            print(state);
            if (state is UserResourcesLoaded) {
              if (state.resources.length == 0) {
                context.read<UserBloc>().add(GetUserInfo());
              }
              _numberOfPost = state.resources.length;
            } else if (state is UserResourceUpdated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Resource updated successfully!'),
                ),
              );
              BlocProvider.of<UserBloc>(context)
                  .add(GetUserResources(widget.userId));
            } else if (state is UserResourceDeleted) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Resource deleted successfully!'),
                ),
              );
              BlocProvider.of<UserBloc>(context)
                  .add(GetUserResources(widget.userId));
            } else if (state is UserInfoUpdated) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
              BlocProvider.of<UserBloc>(context)
                  .add(GetUserResources(widget.userId));
            } else if (state is UserError) {
              print(state.message);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
              BlocProvider.of<UserBloc>(context)
                  .add(GetUserResources(widget.userId));
            }
          },
          builder: (context, state) {
            if (state is UserResourcesLoaded) {
              if (state.resources.length > 0) {
                return ListView(
                  children: [
                    _upperHalf(state.resources[0].uploadedBy),
                    _buildToggleButtons(),
                    _lowerHalf(state.resources),
                  ],
                );
              }
            }
            if (state is UserInfoLoaded) {
              return ListView(children: [
                _upperHalf(state.user),
              ]);
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.image),
            iconSize: 30,
            color: _toggleDisplayPosts == 0 ? Colors.blueAccent : Colors.grey,
            onPressed: () {
              setState(() {
                _toggleDisplayPosts = 0;
              });
            },
          ),
          Container(
            height: 30,
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            iconSize: 30,
            color: _toggleDisplayPosts == 1 ? Colors.blueAccent : Colors.grey,
            onPressed: () {
              setState(() {
                _toggleDisplayPosts = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _upperHalf(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundImage: user.profilePicture.isEmpty
                    ? AssetImage("assets/images/person_placeholder.png")
                    : CachedNetworkImageProvider(
                        "http://localhost:8080/public/userProfilePictures/${user.profilePicture}"),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              _numberOfPost.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "posts",
                            ),
                          ],
                        ),
                      ],
                    ),
                    _currentUserId == widget.userId
                        ? Container(
                            padding: EdgeInsets.only(top: 18),
                            width: 200,
                            child: FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                "EditProfile",
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    userId: widget.userId,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 10),
          child: Text(
            user.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: 15,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _lowerHalf(List<Resource> resources) {
    // pdf
    if (_toggleDisplayPosts == 1) {
      List<ResourceWidget> pdfs = [];
      resources.forEach((resource) {
        if (resource.fileType == 'pdf')
          pdfs.add(ResourceWidget(
            resource: resource,
          ));
      });
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: pdfs,
      );
    } else {
      List<Widget> imageResources = [];
      resources.forEach((resource) {
        if (resource.fileType == 'image')
          imageResources.add(_buildResourceTile(resource));
      });

      return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: imageResources,
      );
    }
  }

  _buildResourceTile(Resource resource) {
    String uploadDate = '';
    DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .parse(resource.createdAt);
    tempDate = tempDate.add(tempDate.timeZoneOffset);
    uploadDate = DateFormat.yMEd().add_jm().format(tempDate);

    final GlobalKey<PopupMenuButtonState<String>> _key = GlobalKey();
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          resource.fileType == 'image'
              ? ResourceImageContainer(
                  imageUrl: resource.files[0],
                )
              : Text('Do for pdf'),
          ResourceDescriptionContainer(resource: resource),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UserProfileScreen(
                        userId: resource.uploadedBy.id,
                      )));
            },
            child: _buildResourceCreatorRowWidget(resource, uploadDate, _key),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          _buildResourceLikeDislikeStats(resource),
          const Divider(),
        ],
      ),
    );
  }

  Row _buildResourceCreatorRowWidget(Resource resource, String uploadDate,
      GlobalKey<PopupMenuButtonState<String>> _key) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: resource.uploadedBy.profilePicture.isEmpty
                ? AssetImage("assets/images/person_placeholder.png")
                : CachedNetworkImageProvider(
                    "http://localhost:8080/public/userProfilePictures/${resource.uploadedBy.profilePicture}"),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resource.uploadedBy.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                uploadDate,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        widget.userId == _currentUserId
            ? _buildPopupMenuButton(_key, resource)
            : SizedBox.shrink()
      ],
    );
  }

  Row _buildResourceLikeDislikeStats(Resource resource) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.arrow_drop_up,
          color: Colors.green,
        ),
        Text(resource.likes.toString(),
            style: TextStyle(
              color: Colors.green,
            )),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.red,
        ),
        Text(resource.dislikes.toString(),
            style: TextStyle(
              color: Colors.red,
            )),
      ],
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(
      GlobalKey<PopupMenuButtonState<String>> _key, Resource resource) {
    return PopupMenuButton<String>(
      key: _key,
      onSelected: (String value) {
        if (value == 'edit') {
          _showEditDeleteResourceDialog(context, resource, 'Edit');
        } else {
          _showEditDeleteResourceDialog(context, resource, 'Delete');
        }
      },
      child: IconButton(
          icon: Icon(Icons.more_horiz),
          color: Colors.white,
          onPressed: () {
            _resourceEditController.text = resource.resourceName;
            _key.currentState.showButtonMenu();
          }),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }

  // Show Dialog function
  void _showEditDeleteResourceDialog(
      context, Resource resource, String action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, dialogState) {
          return AlertDialog(
            title: action == 'Edit'
                ? Text('Edit resource')
                : Text('Are you sure you want to delete this resource?'),
            content: SingleChildScrollView(
              child: action == 'Edit'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          enabled: true,
                          controller: _resourceEditController,
                          textCapitalization: TextCapitalization.words,
                        ),
                        _BuildDropdownWidget(
                          resource: resource,
                          title: 'Year',
                          value: year,
                          categoryList: yearList,
                          onSelected: (cat) {
                            dialogState(() {
                              year = cat;
                              department = null;
                              departmentList.clear();
                            });
                            _setDepartmentList(cat.id);
                          },
                        ),
                        _BuildDropdownWidget(
                          resource: resource,
                          title: 'Department',
                          value: department,
                          categoryList: departmentList,
                          onSelected: (cat) {
                            dialogState(() {
                              department = cat;
                              subject = null;
                              subjectList.clear();
                            });
                            _setSubjectList(cat.id);
                          },
                        ),
                        _BuildDropdownWidget(
                          resource: resource,
                          title: 'Subject',
                          value: subject,
                          categoryList: subjectList,
                          onSelected: (cat) {
                            dialogState(() {
                              subject = cat;
                            });
                          },
                        ),
                      ],
                    )
                  : TextField(
                      enabled: false,
                      controller: _resourceEditController,
                      textCapitalization: TextCapitalization.words,
                    ),
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
                child: action == 'Edit'
                    ? Text('Update')
                    : Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _updateDeleteResource(resource.id, action);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _setDepartmentList(String id) {
    departmentList = categories.where((cat) => cat.parentId == id).toList();
  }

  void _setSubjectList(String id) {
    subjectList = categories.where((cat) => cat.parentId == id).toList();
  }

  void _updateDeleteResource(String resourceId, String action) {
    if (_resourceEditController.text.trim().isNotEmpty) {
      String departmentId = '';
      String yearId = '';
      String subjectId = '';
      if (year != null) {
        yearId = year.id;
      }
      if (department != null) {
        departmentId = department.id;
      }
      if (subject != null) {
        subjectId = subject.id;
      }
      Resource updateResource = Resource(
        id: resourceId,
        year: yearId,
        department: departmentId,
        subject: subjectId,
        resourceName: _resourceEditController.text,
      );
      departmentList.clear();
      subjectList.clear();
      year = null;
      department = null;
      subjectId = null;

      action == 'Edit'
          ? BlocProvider.of<UserBloc>(context)
              .add(UpdateUserResource(updateResource))
          : BlocProvider.of<UserBloc>(context)
              .add(DeleteUserResource(updateResource.id));
    }
  }
}

class _BuildDropdownWidget extends StatelessWidget {
  final Resource resource;
  final String title;
  final Category value;
  final List<Category> categoryList;
  final Function onSelected;

  const _BuildDropdownWidget(
      {Key key,
      this.resource,
      this.title,
      this.value,
      this.onSelected,
      this.categoryList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(
                // color: Colors.black54,
                // fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 16),
          ),
        ),
        Container(
          // margin: EdgeInsets.only(left: 40, right: 90),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: DropdownButton<Category>(
            isExpanded: true,
            hint: title == 'Year'
                ? Text(resource.year)
                : title == 'Department'
                    ? Text(resource.department)
                    : Text(resource.subject),
            underline: SizedBox.shrink(),
            value: value,
            onChanged: onSelected,
            items: categoryList
                .map<DropdownMenuItem<Category>>((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
