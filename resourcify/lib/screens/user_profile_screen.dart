import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:resourcify/bloc/user/user_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/screens.dart';
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

  @override
  void initState() {
    super.initState();
    storage.read(key: 'userId').then((value) => setState(() {
          _currentUserId = value;
        }));
    context.read<UserBloc>().add(GetUserResources(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  onPressed: () {},
                )
              : SizedBox.shrink()
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          print(state);
          if (state is UserResourcesLoaded) {
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
          } else if (state is UserError) {
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
            return ListView(
              children: [
                _upperHalf(state.resources[0].uploadedBy),
                _buildToggleButtons(),
                _lowerHalf(state.resources),
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
    );
  }

  Row _buildToggleButtons() {
    return Row(
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
                        "http://localhost:8080/public/${user.profilePicture}"),
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
                                  color: Colors.white),
                            ),
                            Text(
                              "posts",
                              style: TextStyle(color: Colors.white),
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
                                    user: user,
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
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Divider(),
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
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          resource.fileType == 'image'
              ? ClipRect(
                  child: InteractiveViewer(
                      // boundaryMargin: EdgeInsets.all(20.0),
                      minScale: 0.1,
                      maxScale: 10,
                      child: Container(
                        height: 350,
                        child: CachedNetworkImage(
                          imageUrl:
                              "http://localhost:8080/public/${resource.files[0]}",
                          fit: BoxFit.fill,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            height: 400,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )),
                )
              : Text('Do for pdf'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.resourceName,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.2,
                    color: Colors.blueAccent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Year',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      Text(
                        resource.year,
                        style: TextStyle(color: Colors.white),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Department',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      Text(
                        resource.department,
                        style: TextStyle(color: Colors.white),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subject',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      Text(
                        resource.subject,
                        style: TextStyle(color: Colors.white),
                      ),
                    ]),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UserProfileScreen(
                        userId: resource.uploadedBy.id,
                      )));
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: resource.uploadedBy.profilePicture.isEmpty
                        ? AssetImage("assets/images/person_placeholder.png")
                        : CachedNetworkImageProvider(
                            resource.uploadedBy.profilePicture),
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
                            fontWeight: FontWeight.w600, color: Colors.white),
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
                    ? PopupMenuButton<String>(
                        key: _key,
                        onSelected: (String value) {
                          if (value == 'edit') {
                            _showEditDeleteResourceDialog(
                                context, resource.id, 'Edit');
                          } else {
                            _showEditDeleteResourceDialog(
                                context, resource.id, 'Delete');
                          }
                        },
                        child: IconButton(
                            icon: Icon(Icons.more_horiz),
                            color: Colors.white,
                            onPressed: () {
                              _resourceEditController.text =
                                  resource.resourceName;
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
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
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
          ),
          const Divider(),
        ],
      ),
    );
  }

  // Show Dialog function
  void _showEditDeleteResourceDialog(
      context, String resourceId, String action) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title:
              action == 'Edit' ? Text('Edit resource') : Text('DeleteResource'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                action == 'Delete'
                    ? Text('Are you sure you want to delete this resource?')
                    : SizedBox.shrink(),
                TextField(
                  enabled: action == 'Edit' ? true : false,
                  controller: _resourceEditController,
                  textCapitalization: TextCapitalization.words,
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
              child: action == 'Edit'
                  ? Text('Update')
                  : Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () => _updateDeleteResource(resourceId, action),
            ),
          ],
        );
      },
    );
  }

  void _updateDeleteResource(String resourceId, String action) {
    if (_resourceEditController.text.trim().isNotEmpty) {
      action == 'Edit'
          ? BlocProvider.of<UserBloc>(context)
              .add(UpdateUserResource(resourceId, _resourceEditController.text))
          : BlocProvider.of<UserBloc>(context)
              .add(DeleteUserResource(resourceId));

      Navigator.pop(context);
    }
  }
}
