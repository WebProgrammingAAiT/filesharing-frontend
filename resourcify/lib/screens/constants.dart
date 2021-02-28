import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  // color: Colors.black54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  // color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  // color: Colors.white,
  borderRadius: BorderRadius.circular(30.0),
  border: Border.all(color: Colors.grey[400], width: 1),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
