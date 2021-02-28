import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/bloc/user/user_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:resourcify/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  const EditProfileScreen({Key key, @required this.userId}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _profileImageFile;
  final _formKey = GlobalKey<FormState>();
  User user;
  String username;
  String firstName;
  String currentPassword;
  String newPassword;
  Category year;
  Category department;
  List<Category> categories = [];
  List<Category> departmentList = [];
  List<Category> yearList = [];
  String _currentUserId = '';
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserInfo());
    context.read<AdminBloc>().add(GetCategories());
    storage.read(key: 'userId').then((value) => setState(() {
          _currentUserId = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          context.read<UserBloc>().add(GetUserResources(widget.userId));
          return false;
        },
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            print(state);
            if (state is UserAccountDeleted) {
              context.read<AuthBloc>().add(RemoveJwt());
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          builder: (context, state) {
            if (state is UserInfoLoaded) {
              user = state.user;

              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _displayProfileImage(),
                          ),
                          FlatButton(
                            onPressed: _pickImage,
                            child: Text(
                              "Change Profile Image",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                          TextFormField(
                            initialValue: user.firstName,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              labelText: "First Name",
                            ),
                            validator: (input) => input.trim().length < 1
                                ? "Please enter a valid name"
                                : null,
                            onSaved: (input) => firstName = input,
                          ),
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              labelText: "Username",
                            ),
                            validator: (input) => input.trim().length < 5
                                ? "Username can't be less than 5 characters"
                                : null,
                            onSaved: (input) => username = input,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              labelText: "Current Password",
                            ),
                            onSaved: (input) => currentPassword = input,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              labelText: "New Password",
                            ),
                            onSaved: (input) => newPassword = input,
                          ),
                          BlocBuilder<AdminBloc, AdminState>(
                            builder: (context, state) {
                              if (state is AdminCategoriesLoaded) {
                                categories = state.categories;
                                yearList = categories
                                    .where((cat) => cat.type == 'year')
                                    .toList();

                                return Column(
                                  children: [
                                    _BuildDropdownWidget(
                                      user: user,
                                      title: 'Year',
                                      value: year,
                                      categoryList: yearList,
                                      onSelected: (cat) {
                                        setState(() {
                                          year = cat;
                                          department = null;
                                          departmentList.clear();
                                        });
                                        _setDepartmentList(cat.id);
                                      },
                                    ),
                                    _BuildDropdownWidget(
                                      user: user,
                                      title: 'Department',
                                      value: department,
                                      categoryList: departmentList,
                                      onSelected: (cat) {
                                        setState(() {
                                          department = cat;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: 100,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                    ),
                                    onPressed: _submit,
                                    color: Colors.blue,
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                              Container(
                                  // width: 100,
                                  child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                onPressed: () =>
                                    _showDeleteAccountDialog(context),
                                color: Colors.red,
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              );
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

  ImageProvider _displayProfileImage() {
    //No new profile image
    if (_profileImageFile == null) {
      //No existing profile image
      if (user.profilePicture.isEmpty) {
        return AssetImage("assets/images/person_placeholder.png");
      } else {
        //user profile already exists
        return CachedNetworkImageProvider(
            "http://localhost:8080/public/userProfilePictures/${user.profilePicture}");
      }
    } else {
      //New profile image
      return FileImage(_profileImageFile);
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _profileImageFile = File(result.files.single.path);
      });
    } else {
      // User canceled the picker
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //Update user in the database
      String _profileImageUrl = "";
      String departmentId = '';
      String yearId = '';

      if (department != null && year != null) {
        yearId = year.id;
        departmentId = department.id;
      }
      if (_profileImageFile != null) {
        _profileImageUrl = _profileImageFile.path;
      }
      context.read<UserBloc>().add(UpdateUserInfo(
          userId: widget.userId,
          firstName: firstName,
          username: username,
          currentPassword: currentPassword,
          newPassword: newPassword,
          year: yearId,
          department: departmentId,
          profilePicture: _profileImageUrl));

      Navigator.pop(context);
    }
  }

  void _setDepartmentList(String id) {
    departmentList = categories.where((cat) => cat.parentId == id).toList();
  }

  // Show Dialog function
  void _showDeleteAccountDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                    'Are you sure you want to delete this account? All the resources you created will be removed as well.'),
                Text(
                  'Note: This action is irreversible !!',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              color: Colors.red,
              child:
                  Text('Delete Account', style: TextStyle(color: Colors.white)),
              onPressed: _deleteAccount,
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    context.read<UserBloc>().add(DeleteUserAccount(_currentUserId));
  }
}

class _BuildDropdownWidget extends StatelessWidget {
  final User user;
  final String title;
  final Category value;
  final List<Category> categoryList;
  final Function onSelected;

  const _BuildDropdownWidget(
      {Key key,
      this.user,
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
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
          margin: EdgeInsets.only(left: 40, right: 90),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: DropdownButton<Category>(
            isExpanded: true,
            hint: title == 'Year'
                ? user.year.isNotEmpty
                    ? Text(user.year)
                    : Text('    ---', style: TextStyle(fontSize: 30))
                : user.department.isNotEmpty
                    ? Text(user.department)
                    : Text('    ---', style: TextStyle(fontSize: 30)),
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
