import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';

class FFmpegPage extends StatefulWidget {
  @override
  _FFmpegPageState createState() => _FFmpegPageState();
}

class _FFmpegPageState extends State<FFmpegPage> {
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  File _video;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FFmpeg page"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
              onPressed: () async {
                await getImage();
                _flutterFFmpeg.getMediaInformation(_video.path).then((info) => print(info));
              },
              child: Text("选择视频"))
        ],
      ),
    );
  }

  Future getImage() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = video;
    });
  }
}
