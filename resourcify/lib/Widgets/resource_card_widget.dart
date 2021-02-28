import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resourcify/bloc/download_resource_bloc/download_resource_bloc.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/models.dart';

class ResourceWidget extends StatefulWidget {
  final Resource resource;

  ResourceWidget({@required this.resource});

  @override
  _ResourceWidgetState createState() =>
      _ResourceWidgetState(resource: this.resource);
}

class _ResourceWidgetState extends State<ResourceWidget> {
  _ResourceWidgetState({this.resource});

  Resource resource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            child: ListTile(
              onTap: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ResourceDetailScreen(
                      resource: resource,
                    ),
                  ),
                );

                if (result is Resource) {
                  setState(() {
                    resource = result;
                  });
                }
              },

              // trailing: Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     // Icon(
              //     //   Icons.more_horiz,
              //     //   color: Color(0xff3967D6),
              //     // ),
              //     BlocBuilder<DownloadResourceBloc, DownloadResourceState>(
              //       builder: (context, state) {
              //         if (state is DownloadingResource) {
              //           return Row(
              //             children: [
              //               CircularProgressIndicator(
              //                 strokeWidth: 1,
              //                 value: double.parse(state.percent),
              //               ),
              //               Text('Downloading'),
              //             ],
              //           );
              //         } else if (state is DownloadedResource) {
              //           return GestureDetector(
              //             onTap: () async {
              //               String dir =
              //                   (await getApplicationDocumentsDirectory()).path;
              //               String filePath = '$dir/${resource.files[0]}';
              //               OpenFile.open(filePath);
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 18.0),
              //               child: Text("Open",
              //                   style: TextStyle(color: Color(0xff3967D6))),
              //             ),
              //           );
              //         }
              //         return GestureDetector(
              //           onTap: () => context
              //               .read<DownloadResourceBloc>()
              //               .add(DownloadResource(resource.files[0])),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 18.0),
              //             child: Text("download",
              //                 style: TextStyle(color: Color(0xff3967D6))),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              leading: Container(
                width: 80,
                child: resource.fileType == "pdf"
                    ? SizedBox(
                        height: 260,
                        child: Icon(
                          Icons.description,
                          size: 40,
                        ),
                      )
                    : Container(
                        child: CachedNetworkImage(
                          imageUrl:
                              "http://localhost:3000/public/${resource.files[0]}",
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 1,
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                padding: EdgeInsets.all(10),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    resource.resourceName,
                  ),
                  SizedBox(height: 5),
                ],
              ),
              dense: false,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('by @${resource.uploadedBy.username}',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
