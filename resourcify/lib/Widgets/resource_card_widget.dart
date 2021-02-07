import 'package:flutter/material.dart';
import '../models/models.dart';

class ResourceWidget extends StatefulWidget {
  Resource resource;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 2.0,
        child: Container(
          child: ListTile(
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.more_horiz,
                color: Color(0xff3967D6),),
                GestureDetector(
                      child: Text("download",
                          style: TextStyle(color: Color(0xff3967D6))),
                    ),
              ],
            ),
            leading: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                child: resource.fileType == "pdf"
                    ? Icon(Icons.description)
                    : Icon(Icons.image),
                padding: EdgeInsets.all(10),
              ),
              elevation: 5.0,
              borderOnForeground: false,
              //   ),
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
                Text(resource.uploadedBy,
                    style: TextStyle(color: Colors.grey,
                        )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.arrow_drop_up,
                      color: Colors.green,
                    ),
                    Text(resource.likes.toString(),
                        style: TextStyle(color: Colors.green,)),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.red,
                    ),
                    Text(resource.dislikes.toString(),
                        style: TextStyle(color: Colors.grey,)),
                    
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
