import 'package:flutter/material.dart';
import 'package:resourcify/models/models.dart';

class ResourceDescriptionContainer extends StatelessWidget {
  final Resource resource;

  const ResourceDescriptionContainer({Key key, @required this.resource})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            Text(
              resource.year,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Department',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            Text(
              resource.department,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Subject',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            Text(
              resource.subject,
            ),
          ]),
        ],
      ),
    );
  }
}
