import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:resourcify/bloc/resource_detail/resource_detail_bloc.dart';
import 'package:resourcify/models/models.dart';

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
    // resource = widget.resource;
    // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    //     .parse(resource.createdAt);

    // tempDate = tempDate.add(tempDate.timeZoneOffset);
    // uploadDate = DateFormat.yMEd().add_jm().format(tempDate);
    // context.read<ResourceDetailBloc>().add(ResourceDetailInitialize());
    context
        .read<ResourceDetailBloc>()
        .add(GetResourceDetail(widget.resource.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     color: Colors.black,
      //     onPressed: () {},
      //   ),
      // ),
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
                            ? ClipRect(
                                child: InteractiveViewer(
                                    // boundaryMargin: EdgeInsets.all(20.0),
                                    minScale: 0.1,
                                    maxScale: 10,
                                    child: Container(
                                      height: 350,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://localhost:3000/public/${resource.files[0]}",
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          height: 400,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    )),
                              )
                            : Text('Do for pdf'),
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
                        Row(
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
                            _ReactButton(
                              icon: Icon(
                                Icons.download_rounded,
                                color: Colors.green,
                                size: 25.0,
                              ),
                              label: 'Download',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (state is ResourceDetailLoading ||
                    state is ResourceDetailInitial) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text('State is $state'),
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
      child: Material(
        color: Colors.white,
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
      ),
    );
  }
}
