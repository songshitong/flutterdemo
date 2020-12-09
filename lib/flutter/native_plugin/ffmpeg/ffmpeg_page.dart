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
  late File _video;
  Map? info;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () async {
                  await getImage();
                  _flutterFFmpeg.getMediaInformation(_video.path).then((tinfo) {
                    info = tinfo;
                    print(info);
                    setState(() {});
                  });
                },
                child: Text("选择视频")),
            Builder(
              builder: (context) {
                dynamic rotate;
                if (null != info && info!['streams'] != null) {
                  final streamsInfoArray = info!['streams'];
                  if (streamsInfoArray.length > 0) {
                    for (var streamsInfo in streamsInfoArray) {
                      print("Stream id: ${streamsInfo['index']}");
                      print("Stream type: ${streamsInfo['type']}");
                      print("Stream codec: ${streamsInfo['codec']}");
                      print("Stream full codec: ${streamsInfo['fullCodec']}");
                      print("Stream format: ${streamsInfo['format']}");
                      print("Stream full format: ${streamsInfo['fullFormat']}");
                      print("Stream width: ${streamsInfo['width']}");
                      print("Stream height: ${streamsInfo['height']}");
                      print("Stream bitrate: ${streamsInfo['bitrate']}");
                      print("Stream sample rate: ${streamsInfo['sampleRate']}");
                      print(
                          "Stream sample format: ${streamsInfo['sampleFormat']}");
                      print(
                          "Stream channel layout: ${streamsInfo['channelLayout']}");
                      print("Stream sar: ${streamsInfo['sampleAspectRatio']}");
                      print("Stream dar: ${streamsInfo['displayAspectRatio']}");
                      print(
                          "Stream average frame rate: ${streamsInfo['averageFrameRate']}");
                      print(
                          "Stream real frame rate: ${streamsInfo['realFrameRate']}");
                      print("Stream time base: ${streamsInfo['timeBase']}");
                      print(
                          "Stream codec time base: ${streamsInfo['codecTimeBase']}");

                      final metadataMap = streamsInfo['metadata'];
                      if (metadataMap != null) {
                        print(
                            'Stream metadata encoder: ${metadataMap['encoder']}');
                        print(
                            'Stream metadata rotate: ${metadataMap['rotate']}');
                        if (null != metadataMap['rotate']) {
                          rotate = metadataMap['rotate'];
                        }
                        print(
                            'Stream metadata creation time: ${metadataMap['creation_time']}');
                        print(
                            'Stream metadata handler name: ${metadataMap['handler_name']}');
                      }

                      final sideDataMap = streamsInfo['sidedata'];
                      if (sideDataMap != null) {
                        print(
                            'Stream side data displaymatrix: ${sideDataMap['displaymatrix']}');
                      }
                    }
                  }
                }
                return Text("rotate ${rotate ?? ""}");
              },
            ),
            Text("${info ?? ""}"),
          ],
        ),
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
