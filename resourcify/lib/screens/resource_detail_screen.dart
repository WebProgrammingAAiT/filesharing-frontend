import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resourcify/bloc/download_resource_bloc/download_resource_bloc.dart';
import 'package:resourcify/bloc/resource_detail/resource_detail_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:resourcify/widgets/resource_image_container.dart';

class ResourceDetailScreen extends StatefulWidget {
  final Resource resource;

  const ResourceDetailScreen({Key key, @required this.resource})
      : super(key: key);
  @override
  _ResourceDetailScreenState createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  Resource resource;
  String uploadDate = '';
  @override
  void initState() {
    super.initState();

    context
        .read<ResourceDetailBloc>()
        .add(GetResourceDetail(widget.resource.id));
    context
        .read<DownloadResourceBloc>()
        .add(IsResourceDownloaded(widget.resource.files[0]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, resource);
          return false;
        },
        child: Stack(
          children: [
            BlocConsumer<ResourceDetailBloc, ResourceDetailState>(
              listener: (context, state) {
                print(state);
                if (state is ResourceDetailError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is ResourceDetailLoaded) {
                  DateTime tempDate =
                      new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(state.resource.createdAt);

                  tempDate = tempDate.add(tempDate.timeZoneOffset);
                  uploadDate = DateFormat.yMEd().add_jm().format(tempDate);
                }
              },
              builder: (context, state) {
                if (state is ResourceDetailLoaded) {
                  resource = state.resource;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        resource.fileType == 'image'
                            ? ResourceImageContainer(
                                imageUrl: resource.files[0],
                              )
                            : SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 130,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text('File name: ${resource.files[0]}'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                resource.resourceName,
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 1.2,
                                  color: Colors.blueAccent,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Year',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text(resource.year),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Department',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(resource.department),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Subject',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(resource.subject),
                                  ]),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => UserProfileScreen(
                                      userId: state.resource.uploadedBy.id,
                                    )));
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: resource
                                          .uploadedBy.profilePicture.isEmpty
                                      ? AssetImage(
                                          "assets/images/person_placeholder.png")
                                      : CachedNetworkImageProvider(
                                          "http://localhost:3000/public/userProfilePictures/${resource.uploadedBy.profilePicture}"),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ReactButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: resource.isLiked
                                    ? Colors.blue
                                    : Colors.grey[600],
                                size: 20.0,
                              ),
                              label: 'Like',
                              onTap: () => _likeResource(resource),
                            ),
                            _ReactButton(
                              icon: Icon(
                                Icons.thumb_down,
                                color: resource.isDisliked
                                    ? Colors.red
                                    : Colors.grey[600],
                                size: 25.0,
                              ),
                              label: 'Dislike',
                              onTap: () => _disLikeResource(resource),
                            ),
                            BlocConsumer<DownloadResourceBloc,
                                DownloadResourceState>(
                              listener: (ctx, state) {
                                print(state);
                              },
                              builder: (ctx, state) {
                                if (state is DownloadingResource) {
                                  return Row(
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 1,
                                        value: double.parse(state.percent),
                                      ),
                                      Text('Downloading'),
                                    ],
                                  );
                                } else if (state is DownloadedResource) {
                                  return _ReactButton(
                                    icon: Icon(
                                      Icons.description,
                                      color: Colors.green,
                                      size: 25.0,
                                    ),
                                    label: 'Open',
                                    onTap: () async {
                                      String dir =
                                          (await getApplicationDocumentsDirectory())
                                              .path;
                                      String filePath =
                                          '$dir/${resource.files[0]}';
                                      OpenFile.open(filePath);
                                    },
                                  );
                                }
                                return _ReactButton(
                                  icon: Icon(
                                    Icons.download_outlined,
                                    color: Colors.green,
                                    size: 25.0,
                                  ),
                                  label: 'Download',
                                  onTap: () {
                                    context.read<DownloadResourceBloc>().add(
                                        DownloadResource(resource.files[0]));
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (state is ResourceDetailLoading ||
                    state is ResourceDetailInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
              },
            ),
            Positioned(
              top: 30,
              left: 15,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context, resource),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _likeResource(Resource resource) {
    if (resource.isDisliked) {
      context
          .read<ResourceDetailBloc>()
          .add(RemoveDislikeThenLikeResource(resource.id));
    } else if (resource.isLiked) {
      context.read<ResourceDetailBloc>().add(UnLikeResource(resource.id));
    } else {
      context.read<ResourceDetailBloc>().add(LikeResource(resource.id));
    }
  }

  void _disLikeResource(Resource resource) {
    if (resource.isLiked) {
      context
          .read<ResourceDetailBloc>()
          .add(RemoveLikeThenDislikeResource(resource.id));
    } else if (resource.isDisliked) {
      context.read<ResourceDetailBloc>().add(UnDislikeResource(resource.id));
    } else {
      context.read<ResourceDetailBloc>().add(DislikeResource(resource.id));
    }
  }
}

class _ReactButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function onTap;

  const _ReactButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4.0),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
