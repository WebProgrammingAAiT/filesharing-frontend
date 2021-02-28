import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadResourceDataProvider {
  static const String SERVER_IP = 'http://localhost:3000/public';
  final Dio dio;

  DownloadResourceDataProvider({@required this.dio}) : assert(dio != null);

  Stream<String> download(String fileUrl) async* {
    var dir = await getApplicationDocumentsDirectory();

    StreamController<String> streamController = new StreamController<String>();
    print('inside dp');
    try {
      dio.download(
        '$SERVER_IP/$fileUrl',
        '${dir.path}/$fileUrl',
        onReceiveProgress: (int received, int total) {
          print("$received / $total");
          streamController.add((received / total).toString());
        },
      ).then((Response response) {
        streamController.add("Download finished");
      }).catchError((ex) {
        throw Exception(ex.toString());
      }).whenComplete(() {
        streamController.close();
      });
      yield* streamController.stream;
    } catch (ex) {
      throw ex;
    }
  }

  Future<bool> isResourceDownloaded(String fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String savePath = '$dir/$fileName';

    if (await File(savePath).exists()) {
      return true;
    } else {
      return false;
    }
  }
}
