import 'package:flutter/material.dart';

class AlertDialogContainer extends StatelessWidget {
  final BuildContext context;
  final String action;
  final TextEditingController controller;
  final String title;
  final String buttonName;
  final Function onActionButtonPressed;
  final String hintText;

  const AlertDialogContainer({
    Key key,
    @required this.context,
    this.action,
    @required this.controller,
    this.title,
    this.buttonName,
    this.hintText,
    @required this.onActionButtonPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: action != null
          ? action == 'Edit'
              ? Text('Edit resource')
              : Text('DeleteResource')
          : Text(title),
      content: Container(
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            action != null
                ? action == 'Delete'
                    ? Text('Are you sure you want to delete this resource?')
                    : SizedBox.shrink()
                : SizedBox.shrink(),
            TextField(
              enabled: action != null
                  ? action == 'Edit'
                      ? true
                      : false
                  : true,
              controller: controller,
              decoration: hintText != null
                  ? InputDecoration(hintText: hintText)
                  : InputDecoration(),
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
          child: action != null
              ? action == 'Edit'
                  ? Text('Update')
                  : Text('Delete', style: TextStyle(color: Colors.red))
              : Text(buttonName),
          onPressed: onActionButtonPressed,
        ),
      ],
    );
  }
}
