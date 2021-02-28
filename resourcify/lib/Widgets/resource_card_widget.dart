import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resourcify/screens/screens.dart';
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
      margin: EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 2.0,
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
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon(
                //   Icons.more_horiz,
                //   color: Color(0xff3967D6),
                // ),
                GestureDetector(
                  onTap: () => print('pressed download'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text("download",
                        style: TextStyle(color: Color(0xff3967D6))),
                  ),
                ),
              ],
            ),
            leading: Container(
              child: resource.fileType == "pdf"
                  ? Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Icon(Icons.description))
                  : Container(
                      width: 80,
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://localhost:3000/public/${resource.files[0]}",
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
