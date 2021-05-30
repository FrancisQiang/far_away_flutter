import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class RecruitMessageCard extends StatelessWidget {

  final String cover;

  final String title;

  final String id;

  final String content;

  RecruitMessageCard({this.cover, this.title, this.id, this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                height: ScreenUtil().setHeight(300),
                width: ScreenUtil().setWidth(550),
                imageUrl: cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(10)),
            child: Text(
              '[义工招聘] $title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(12),
                right: ScreenUtil().setWidth(12),
                bottom: ScreenUtil().setHeight(10)),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          )
        ],
      ),
    );
  }
}
