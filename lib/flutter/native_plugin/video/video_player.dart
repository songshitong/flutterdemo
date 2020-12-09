import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  //获取时光网地址 http:/api.m.mtime.cn/PageSubArea/TrailerList.api
  String url1 = "http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4";
  String url3 = "http://vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4";
  String url2 = "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4";
  //阿里云
  String url4 =
      "https://out-20170629113118784-ottgas6dn7.oss-cn-shanghai.aliyuncs.com/sv/1b43e744-16aba3e7fd3/1b43e744-16aba3e7fd3.mp4";
  String url5 = "http://49.4.5.50:25367/api/common/storage/news/fc7ed02293f8994f96242de1b2aae21e.mp4";
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(url5)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      print(
          "listener total ${_controller.value.duration} current ${_controller.value.position} ${_controller.value.isPlaying}");
      if (_controller.value.duration == _controller.value.position) {
        setState(() {
          _controller.pause();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VideoPlayer Page"),
      ),
      body: Column(
        children: <Widget>[
          _controller.value.initialized
              ? AspectRatio(
                  //宽高比
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          VideoProgressIndicator(_controller, allowScrubbing: true)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
