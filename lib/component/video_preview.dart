import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {

  final String url;

  final Widget placeHolder;

  final double aspectRatio;

  VideoPreview({@required this.url, this.placeHolder = const SizedBox(), this.aspectRatio = 16 / 9});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController _videoController;
  ChewieController _chewieController;

  initializePlayer() async {
    _videoController = VideoPlayerController.network(widget.url);
    await _videoController.initialize();
    _chewieController = ChewieController(
      aspectRatio: widget.aspectRatio,
      videoPlayerController: _videoController,
      autoPlay: false,
      fullScreenByDefault: true,
      showControls: false,
      showControlsOnInitialize: false,
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
    return Stack(
      children: [
        _videoController.value.initialized
            ? Chewie(controller: _chewieController)
            : widget.placeHolder,
        _videoController.value.initialized ? Positioned.fill(
          child: Icon(FontAwesomeIcons.play, color: Colors.white),
        ) : SizedBox()
      ],
    );
  }
}
