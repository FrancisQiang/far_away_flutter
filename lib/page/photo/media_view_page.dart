import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'asset_view_page.dart';

class MediaViewPage extends StatefulWidget {

  final List<MediaList> mediaList;

  final int currentIndex;

  MediaViewPage({@required this.mediaList, this.currentIndex = 0});

  @override
  _MediaViewPageState createState() => _MediaViewPageState();
}

class _MediaViewPageState extends State<MediaViewPage> {

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
        children: List.generate(widget.mediaList.length, (index) {
          if(widget.mediaList[index].type == 1) {
            return PhotoView(
              imageProvider: CachedNetworkImageProvider(
                widget.mediaList[index].url,
              ),
            );
          } else {
            return NetworkVideoPlayer(widget.mediaList[index].url);
          }
        }),
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
      )
    );
  }
}

