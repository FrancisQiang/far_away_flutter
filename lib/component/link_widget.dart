import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  final String linkURL;

  final String linkImg;

  final String linkTitle;

  final double imgSideLength;

  LinkWidget(
      {@required this.linkURL,
      @required this.linkImg,
      @required this.linkTitle,
      this.imgSideLength = 200});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch(linkURL);
      },
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            children: [
              Container(
                child: StringUtil.isEmpty(linkImg)
                    ? Image.asset(
                        'assets/png/network.png',
                        width: imgSideLength,
                        height: imgSideLength,
                      )
                    : CachedNetworkImage(
                        imageUrl: linkImg,
                        width: imgSideLength,
                        height: imgSideLength,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: imgSideLength * 0.4),
                child: Text(
                  StringUtil.isEmpty(linkTitle) ? linkURL : linkTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleTheme.h4,
                ),
              ),
            ],
          )),
    );
  }
}
