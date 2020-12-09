import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:video_player/video_player.dart';

class MovieAudioReplace extends StatefulWidget {
  @override
  _MovieAudioReplaceState createState() => _MovieAudioReplaceState();
}

class _MovieAudioReplaceState extends State<MovieAudioReplace> {
  VideoPlayerController? _controller;
  FlutterSound? flutterSound = new FlutterSound();
  String audioPath = "/storage/emulated/0/default.m4a";
  String outPath = "/storage/emulated/0/outputplay.mp4";
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;

  FlutterFFmpeg? _flutterFFmpeg = new FlutterFFmpeg();
  bool showProgressBar = false;

  String url1 =
      "http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4";
  late String playUrl;
  @override
  void initState() {
    super.initState();
    playUrl = url1;
    initVideoController("network");
  }

  void initVideoController(String from) {
    if (from == "network") {
      _controller = VideoPlayerController.network(playUrl);
    } else if (from == "file") {
      _controller = VideoPlayerController.file(File(playUrl));
    }
    _controller!.initialize().then((_) {
      setState(() {});
    });
    _controller!.addListener(() {
      print(
          "listener total ${_controller!.value.duration} current ${_controller!.value.position} ${_controller!.value.isPlaying}");
      if (_controller!.value.duration == _controller!.value.position) {
        setState(() {
          _controller!.pause();
        });
      }
    });
  }

  @override
  void dispose() {
    if (null != _controller) {
      _controller!.dispose();
      _controller = null;
    }
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
    if (null != _flutterFFmpeg) {
      _flutterFFmpeg!.cancel();
      _flutterFFmpeg = null;
    }
    if (flutterSound != null) {
      flutterSound = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("替换电影音频"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _controller!.value.initialized
                ? AspectRatio(
                    //宽高比
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Container(),
            VideoProgressIndicator(_controller!, allowScrubbing: true),
            RaisedButton(
              onPressed: () async {
                _controller!.play();
                audioPath = await flutterSound!.startRecorder("");
                print('startRecorder: $audioPath');

                _recorderSubscription =
                    flutterSound!.onRecorderStateChanged.listen((e) {
                  print("date ${e.currentPosition}");
                });
              },
              child: Text("播放并录制音频"),
            ),
            RaisedButton(
              onPressed: () async {
                playUrl = url1;
                initVideoController("network");
                await _controller!.play();
              },
              child: Text("播放电影"),
            ),
            RaisedButton(
              onPressed: () async {
                _controller!.pause();
              },
              child: Text("停止播放电影"),
            ),
            RaisedButton(
              onPressed: () async {
                if (_recorderSubscription != null) {
                  _recorderSubscription!.cancel();
                  _recorderSubscription = null;
                }
              },
              child: Text("停止录制音频"),
            ),
            RaisedButton(
              onPressed: () async {
                _controller!.pause();
                String result = await flutterSound!.stopRecorder();
                print('stopRecorder: $result');
                if (_recorderSubscription != null) {
                  _recorderSubscription!.cancel();
                  _recorderSubscription = null;
                }
              },
              child: Text("停止播放和录制音频"),
            ),
            RaisedButton(
              onPressed: () {
                //替换前把之前的输出删除

                File _file = new File(outPath);
                if (_file.existsSync()) {
                  _file.deleteSync();
                }
                String replaceCmd =
                    "-i $url1 -i $audioPath -c copy -map 0:v:0 -map 1:a:0 $outPath";
                setState(() {
                  showProgressBar = true;
                });
                String cmd =
                    "-i $url1 -i $audioPath -filter_complex [0:a]aformat=sample_fmts=fltp:channel_layouts=stereo,volume=0.1[a0];[1:a]aformat=sample_fmts=fltp:channel_layouts=stereo,volume=1,adelay='0000|0000|0000'[a1];[a0][a1]amix=inputs=2:duration=first[aout] -map [aout] -ac 2 -c:v copy -map 0:v:0 $outPath";
                _flutterFFmpeg
                  ?..execute(cmd).then((rc) {
                    print("FFmpeg process exited with rc $rc");
                    setState(() {
                      showProgressBar = false;
                    });
                  });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("替换电影音频"),
                  Visibility(
                    visible: showProgressBar,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: () async {
                await flutterSound!.startPlayer(audioPath);
                _playerSubscription =
                    flutterSound!.onPlayerStateChanged.listen((e) {
                  if (null != e) {
                    print("play audio ${e.currentPosition}");
                  }
                });
              },
              child: Text("播放录音"),
            ),
            RaisedButton(
              onPressed: () async {
                await flutterSound!.stopPlayer();
              },
              child: Text("停止播放录音"),
            ),
            RaisedButton(
              onPressed: () {
                setState(() async {
                  playUrl = "$outPath";
                  initVideoController("file");
                  await _controller!.play();
                });
              },
              child: Text("播放替换后的电影"),
            ),
          ],
        ),
      ),
    );
  }
}
