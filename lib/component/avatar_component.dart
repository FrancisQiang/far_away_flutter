import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_error_widget.dart';
import 'image_holder.dart';

class AvatarComponent extends StatelessWidget {
  
  final String url;

  final double sideLength;

  final double holderSize;

  final double errorWidgetSize;

  AvatarComponent(this.url,
      {@required this.sideLength,
      @required this.holderSize,
      @required this.errorWidgetSize});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
          width: sideLength,
          height: sideLength,
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => ImageHolder(size: holderSize),
          errorWidget: (context, url, error) => ImageErrorWidget(
                size: errorWidgetSize,
              )),
    );
  }
}
