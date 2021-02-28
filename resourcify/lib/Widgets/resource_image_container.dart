import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ResourceImageContainer extends StatelessWidget {
  final String imageUrl;

  const ResourceImageContainer({Key key, @required this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: InteractiveViewer(
          // boundaryMargin: EdgeInsets.all(20.0),
          minScale: 0.1,
          maxScale: 10,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: "http://localhost:3000/public/$imageUrl",
              // fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                // height: 400,
                child: Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )),
    );
  }
}
