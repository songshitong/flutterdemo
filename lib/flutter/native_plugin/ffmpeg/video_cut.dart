import 'package:aliyun_video_player/aliyun_video_player.dart';
import 'package:aliyun_video_player/player_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwadarpro/common/ffmpeg/ffmpeg_manager.dart';
import 'package:gwadarpro/common/ffmpeg/ffmpeg_media_info.dart';
import 'package:gwadarpro/common/functions.dart';
import 'package:gwadarpro/util/log_util.dart';
import 'package:gwadarpro/widget/image_builder.dart';
import 'package:gwadarpro/widget/toast_helper.dart';
import 'package:quiver/strings.dart';

///视频裁剪
///15秒展示10帧，每1.5秒展示一帧
class VideoCutPage extends StatefulWidget {
  String path;

  VideoCutPage(this.path);

  static Future jump2This(BuildContext context, String url) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//      "http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4";
//          "/storage/emulated/0/DCIM/ScreenRecorder/Screenrecorder-2020-02-13-16-40-50-86.mp4";
      return VideoCutPage(url);
    }));
  }

  @override
  _VideoCutPageState createState() => _VideoCutPageState();
}

class _VideoCutPageState extends State<VideoCutPage> {
  static final tag = "_VideoCutPageState ====";
  FFmpegMediaInfo fFmpegMediaInfo;
  List<String> frames = [];
  AliyunVideoPlayer _player;

  ///多少秒一帧
  static const frameTime = 1.5;

  ///要裁剪的帧数 视频长度10*1.5=15秒
  static const cutNumber = 10;

  double slideWidth = ws(23);
  final frameHeight = hs(138);
  final frameWidth = ws(70);
  double frameInitOffset = ws(187);
  double framesListOffset;
  double slideLeftOffset;
  double slideRightOffset;
  double slideRightInitOffset;
  ScrollController framesScrollController;
  int videoPosition = 0;
  String outputPath = "";

  ///额外点击区域
  final double slideClickArea = ws(10);
  @override
  void initState() {
    super.initState();
    framesScrollController =
        ScrollController(initialScrollOffset: frameInitOffset);
    framesListOffset = frameInitOffset;
    slideLeftOffset = frameInitOffset;

    ///两个滑块的间距是10帧图片
    slideRightInitOffset =
        frameInitOffset + frameWidth * cutNumber - slideWidth;
    slideRightOffset = slideRightInitOffset;
    getMediaInfo();
  }

  @override
  void dispose() {
    _player.release();
    framesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: buildColumn(context));
  }

  Column buildColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: ws(138), top: hs(150)),
          width: ws(800),
          height: hs(1425),
          child: AliPlayerView(
            onCreated: (aliPlayer) {
              _player = aliPlayer;
              initPlayerListener();
            },
          ),
        ),
        Visibility(
          visible: frames.length == 0,
          child: Center(
            child: CupertinoTheme(
                data: CupertinoTheme.of(context).copyWith(
                    primaryColor: Colors.white, brightness: Brightness.dark),
                child: CupertinoActivityIndicator(
                  radius: frameWidth,
                )),
          ),
        ),
        Visibility(
          visible: frames.length > 0,
          child: Container(
            margin: EdgeInsets.only(top: hs(30)),
            height: frameHeight,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: framesListOffset,
                  width: frameWidth * frames.length,
                  height: frameHeight,
                  child: GestureDetector(
                    onHorizontalDragStart: (_) {
                      pausePlayer();
                    },
                    onHorizontalDragEnd: (_) {
                      seekPlayer((computeStartPosition() * 1000).toInt());
                    },
                    onHorizontalDragCancel: () {
                      seekPlayer((computeStartPosition() * 1000).toInt());
                    },
                    onHorizontalDragUpdate: (dragUpdate) {
                      final offsetX = dragUpdate.delta.dx;
                      var tempFramesListOffset = framesListOffset;
                      framesListOffset += offsetX;
                      //右滑不超过初始位置
                      if (framesListOffset > frameInitOffset) {
                        framesListOffset = tempFramesListOffset;
                      } else if ((frameInitOffset - framesListOffset) >
                          frameWidth * (frames.length - cutNumber)) {
                        //左滑距离不超过 fameWidth*(总帧数-10)
                        framesListOffset = tempFramesListOffset;
                      }

                      setState(() {});
                    },
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: framesScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: frames.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ImageBuilder.buildImage(frames[index],
                              isFilePath: true,
                              width: frameWidth,
                              height: frameHeight);
                        }),
                  ),
                ),
                //左侧透明层
                Container(
                  decoration:
                  BoxDecoration(color: Colors.black.withOpacity(0.6)),
                  width: slideLeftOffset,
                ),
                //右侧透明层
                Container(
                  margin: EdgeInsets.only(left: slideRightOffset + slideWidth),
                  width: MediaQuery.of(context).size.width -
                      (slideRightOffset + slideWidth),
                  decoration:
                  BoxDecoration(color: Colors.black.withOpacity(0.6)),
                ),
                //左滑块
                Positioned(
                  left: slideLeftOffset - slideClickArea,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (_) {
                      pausePlayer();
                    },
                    onHorizontalDragEnd: (_) {
                      seekPlayer((computeStartPosition() * 1000).toInt());
                    },
                    onHorizontalDragCancel: () {
                      seekPlayer((computeStartPosition() * 1000).toInt());
                    },
                    onHorizontalDragUpdate: (dragUpdateDetail) {
                      final offsetX = dragUpdateDetail.delta.dx;
                      var tempSlideLeftOffset = slideLeftOffset;
                      slideLeftOffset += offsetX;
                      //左滑块只能在原位置的右侧
                      if (slideLeftOffset < frameInitOffset) {
                        slideLeftOffset = tempSlideLeftOffset;
                      } else if ((slideRightOffset - slideLeftOffset) +
                          slideWidth <
                          frameWidth) {
                        ///左右滑块最小间距是一帧
                        slideLeftOffset = tempSlideLeftOffset;
                      }
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: slideClickArea),
                      width: slideWidth,
                      height: frameHeight,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                ),
                //右滑块
                Positioned(
                  left: slideRightOffset,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (_) {
                      pausePlayer();
                    },
                    onHorizontalDragEnd: (_) {
                      startPlayer();
                    },
                    onHorizontalDragCancel: () {
                      startPlayer();
                    },
                    onHorizontalDragUpdate: (dragUpdateDetail) {
                      final offsetX = dragUpdateDetail.delta.dx;
                      var tempSlideRightOffset = slideRightOffset;
                      slideRightOffset += offsetX;

                      ///左右滑块最小间距是一帧
                      if ((slideRightOffset - slideLeftOffset) + slideWidth <
                          frameWidth) {
                        slideRightOffset = tempSlideRightOffset;
                      } else if (slideRightOffset > slideRightInitOffset) {
                        //只能在原位置左侧
                        slideRightOffset = tempSlideRightOffset;
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: slideWidth,
                      height: frameHeight,
                      margin: EdgeInsets.symmetric(horizontal: slideClickArea),
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: hs(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  popPage();
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white, fontSize: ss(48)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  double duration = computeDuration();
                  double startPosition = computeStartPosition();
                  cutVideo(startPosition, duration, widget.path);
                },
                child: Text(
                  "DONE",
                  style: TextStyle(color: Colors.white, fontSize: ss(48)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //计算切割长度  秒 todo 计算优化，输入没有变化使用缓存
  double computeDuration() {
    double durationFraction =
        (slideRightOffset + slideWidth - slideLeftOffset) /
            (slideRightInitOffset + slideWidth - frameInitOffset);
    double duration = frameTime * cutNumber * durationFraction;
    return duration;
  }

  //计算起始位置 秒  todo 计算优化，输入没有变化使用缓存
  double computeStartPosition() {
    ///frame list的移动距离+左滑块移动的距离
    double slideOffset = (frameInitOffset - framesListOffset) +
        (slideLeftOffset - frameInitOffset);
    double slideOffsetFraction = slideOffset / (frames.length * frameWidth);
    double startPosition =
        (fFmpegMediaInfo.duration / 1000) * slideOffsetFraction;
    return startPosition;
  }

  void getMediaInfo() {
    var ffmpegManager = FFmpegManager.getInstance();
    ffmpegManager.getMediaInfo(widget.path).then((result) async {
      fFmpegMediaInfo = result;
      var frameNumber = fFmpegMediaInfo.duration ~/ (frameTime * 1000);
      LogUtil.debug("getMediaInfo frameNumber $frameNumber");
      ffmpegManager.getFrameTimes(widget.path, frameTime).listen((fileEntity) {
        frames.add(fileEntity.path);
      }, onDone: () {
        LogUtil.debug("$tag getMediaInfo onDone");
        setState(() {});
        prepareAndStartPlayer();
      });
    });
  }

  //截取视频
  void cutVideo(double start, double duration, String input) {
    LogUtil.debug("$tag cutVideo start $start duration $duration input $input");
    var ffmpegManager = FFmpegManager.getInstance();
    ffmpegManager.cutVideo(start, duration, input).then((result) {
      if (isNotEmpty(result)) {
        outputPath = result;
        popPage();
      } else {
        ToastHelper.showLong("error");
      }
    });
  }

  void prepareAndStartPlayer() {
    if (null == _player) {
      LogUtil.error("_VideoCutPageState startPlayer _player is null ");
      return;
    }
    _player.loadUrl(widget.path, isLoop: false);
    _player.prepareAndStart();
  }

  void pausePlayer() {
    if (null == _player) {
      LogUtil.error("_VideoCutPageState startPlayer _player is null ");
      return;
    }
    _player.pause();
  }

  void startPlayer() {
    if (null == _player) {
      LogUtil.error("_VideoCutPageState startPlayer _player is null ");
      return;
    }
    _player.start();
  }

  void seekPlayer(int position) {
    if (null == _player) {
      LogUtil.error("_VideoCutPageState seekPlayer _player is null ");
      return;
    }
    LogUtil.debug("_VideoCutPageState seekPlayer position $position");
    _player.seekToAndPlay(position);
  }

  void initPlayerListener() {
    if (null == _player) {
      LogUtil.error("_VideoCutPageState initPlayerListener _player is null ");
      return;
    }
    _player.onPositionChanged = (position) {
      ///播放位置大于框住的位置，停止播放
      var start = computeStartPosition();
      var duration = computeDuration();
      if (position >= (start + duration) * 1000) {
        seekPlayer((start * 1000).toInt());
      }
      videoPosition = position;
    };
    _player.onCompletion = () {
      //播放完成从开始位置播放
      var start = computeStartPosition();
      seekPlayer((start * 1000).toInt());
    };
  }

  void popPage() {
    Navigator.of(context).pop(outputPath);
  }
}
