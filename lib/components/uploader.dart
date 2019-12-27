import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => UploaderState();
}

class UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://bee-api-7e7b5.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: <Widget>[
              if (_uploadTask.isComplete)
                Text('Complete !'),
              LinearProgressIndicator(value: progressPercent),
              Text('${(progressPercent * 100).toStringAsFixed(2)} %')

            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
          onPressed: _startUpload,
          icon: Icon(Icons.cloud_upload),
          label: Text('Upload to firebase'));
    }
  }
}
