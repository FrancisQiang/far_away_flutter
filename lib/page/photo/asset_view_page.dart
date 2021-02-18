// import 'package:better_player/better_player.dart';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetViewPage extends StatefulWidget {
  final List<AssetEntity> assetList;

  final int currentIndex;

  AssetViewPage({@required this.assetList, this.currentIndex = 0});

  @override
  _AssetViewPageState createState() => _AssetViewPageState();
}

class _AssetViewPageState extends State<AssetViewPage> {
  int _currentIndex;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        elevation: 0.0,
        leading: SizedBox(),
      ),
      body: PageView(
        controller: _pageController,
        children: List.generate(widget.assetList.length, (index) {
          if (widget.assetList[index].type == AssetType.video) {
            return FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AssetVideoPlayer(file: snapshot.data);
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                  ));
                }
              },
              future: widget.assetList[index].file,
            );
          } else {
            return PhotoView(
              imageProvider: AssetEntityImageProvider(
                widget.assetList[index],
                isOriginal: false,
                thumbSize: [200, 200],
              ),
            );
          }
        }),
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}

class NetworkVideoPlayer extends StatefulWidget {
  final String url;

  NetworkVideoPlayer(this.url);

  @override
  _NetworkVideoPlayerState createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  VideoPlayerController _videoController;
  ChewieController _chewieController;

  initializePlayer() async {
    _videoController = VideoPlayerController.network(widget.url);
    await _videoController.initialize();
    _chewieController = ChewieController(
      aspectRatio: 1,
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        handleColor: Colors.orangeAccent,
        backgroundColor: Colors.black12,
        bufferedColor: Colors.grey,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("test11");
      },
      child: _videoController.value.initialized
          ? Chewie(controller: _chewieController)
          : Container(
              child: SpinKitPouringHourglass(
                color: Theme.of(context).primaryColor,
                duration: Duration(seconds: 1),
              )
            ),
    );
  }
}

class AssetVideoPlayer extends StatefulWidget {
  final File file;

  AssetVideoPlayer({@required this.file});

  @override
  _AssetVideoPlayerState createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<AssetVideoPlayer> {
  VideoPlayerController _videoController;
  ChewieController _chewieController;

  initializePlayer() async {
    _videoController = VideoPlayerController.file(widget.file);
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        handleColor: Colors.orangeAccent,
        backgroundColor: Colors.black12,
        bufferedColor: Colors.grey,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("test11");
      },
      child: _videoController.value.initialized
          ? Chewie(controller: _chewieController)
          : Container(),
    );
  }
}
