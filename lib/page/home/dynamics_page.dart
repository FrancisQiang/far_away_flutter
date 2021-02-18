import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/page/photo/video_preview.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dynamic_empty_widget.dart';

class DynamicsPage extends StatefulWidget {
  @override
  _DynamicsPageState createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  int timestamp;

  @override
  bool get wantKeepAlive => true;

  List<DynamicDetailBean> dynamicList = [];

  int currentPage = 1;

  _loadDynamicData(String jwt) async {
    Response<dynamic> data;
    ResponseBean response;
    PageBean pageBean;
    try {
      data = await ApiMethodUtil.getDynamicList(
          timestamp: timestamp, currentPage: currentPage, token: jwt);
      response = ResponseBean.fromJson(data.data);
      pageBean = PageBean.fromJson(response.data);
    } catch (ex) {
      print('error');
      return;
    }
    if (pageBean.list.isEmpty) {
      Fluttertoast.showToast(
          msg: "没有数据啦",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: ScreenUtil().setSp(25));
      return;
    }
    currentPage++;
    setState(() {
      for (int i = 0; i < pageBean.list.length; i++) {
        DynamicDetailBean bean = DynamicDetailBean.fromJson(pageBean.list[i]);
        dynamicList.add(bean);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return EasyRefresh(
          header: EasyRefreshWidget.refreshHeader,
          footer: EasyRefreshWidget.refreshFooter,
          firstRefresh: true,
          firstRefreshWidget: InitRefreshWidget(
            color: Theme.of(context).primaryColor,
          ),
          emptyWidget: dynamicList.length == 0
              ? DynamicEmptyWidget(
                  width: ScreenUtil().setWidth(380),
                  height: ScreenUtil().setHeight(300),
                )
              : null,
          onRefresh: () async {
            dynamicList = [];
            currentPage = 1;
            timestamp = DateTime.now().millisecondsSinceEpoch;
            await _loadDynamicData(globalInfoProvider.jwt);
          },
          onLoad: () async {
            await _loadDynamicData(globalInfoProvider.jwt);
          },
          child: Column(
              children: List.generate(dynamicList.length, (index) {
            return GestureDetector(
                onTap: () => NavigatorUtil.toDynamicDetailPage(context,
                    param: DynamicDetailParam(
                        avatarHeroTag: 'dynamic_${dynamicList[index].id}',
                        dynamicDetailBean: dynamicList[index])),
                child: DynamicPreviewCard(
                    dynamicDetailBean: dynamicList[index]));
          })));
    });
  }
}

class DynamicPreviewCard extends StatelessWidget {
  final DynamicDetailBean dynamicDetailBean;

  DynamicPreviewCard({@required this.dynamicDetailBean});

  Widget _buildMediaWrap() {
    return dynamicDetailBean.type == 1 ||
        dynamicDetailBean.mediaList.isEmpty ||
        dynamicDetailBean.mediaList == null
        ? SizedBox()
        : MediaPreview(
            dynamicDetailBean: dynamicDetailBean,
          );
  }

  Widget _buildLink() {
    return dynamicDetailBean.type == 0
        ? SizedBox()
        : GestureDetector(
            onTap: () {
              launch(dynamicDetailBean.link);
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(150),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100]),
                child: Row(
                  children: [
                    Container(
                      child: StringUtil.isEmpty(dynamicDetailBean.linkImage)
                          ? SvgPicture.asset(
                              'assets/svg/www.svg',
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setWidth(100),
                            )
                          : CachedNetworkImage(
                              imageUrl: dynamicDetailBean.linkImage,
                              width: ScreenUtil().setWidth(120),
                              height: ScreenUtil().setWidth(120),
                            ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(420),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                      child: Text(
                        StringUtil.isEmpty(dynamicDetailBean.linkTitle)
                            ? dynamicDetailBean.link
                            : dynamicDetailBean.linkTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleTheme.h4,
                      ),
                    ),
                  ],
                )),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                // 头像
                Container(
                    width: ScreenUtil().setWidth(90),
                    child: Hero(
                      tag: "dynamic_${dynamicDetailBean.id}",
                      child: ClipOval(
                          child: CachedNetworkImage(
                              imageUrl: dynamicDetailBean.userAvatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ImageHolder(
                                    size: ScreenUtil().setSp(40),
                                  ),
                              errorWidget: (context, url, error) =>
                                  ImageErrorWidget(
                                    size: ScreenUtil().setSp(40),
                                  ))),
                    )),
                // 用户名和用户签名
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Row(
                        children: [
                          Container(
                            child: Text(
                              dynamicDetailBean.username,
                              style: TextStyleTheme.h3,
                            ),
                          ),
                        ],
                      )),
                      Container(
                        child: Text(dynamicDetailBean.signature,
                            style: TextStyleTheme.subH5),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // 动态内容
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20),
            ),
            child: Text(dynamicDetailBean.content,
                overflow: TextOverflow.ellipsis, style: TextStyleTheme.body),
          ),
          // 媒体资源
          _buildMediaWrap(),
          _buildLink(),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TimeLocationBar(
                  time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(dynamicDetailBean.publishTime)),
                  location: dynamicDetailBean.location,
                  width: ScreenUtil().setWidth(440),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: LikeButton(
                          size: ScreenUtil().setSp(40),
                          onTap: (bool isLiked) async {
                            await ApiMethodUtil.dynamicThumbChange(
                                token: ProviderUtil.globalInfoProvider.jwt,
                                thumb: !isLiked,
                                dynamicId: dynamicDetailBean.id);
                            if (!isLiked) {
                              dynamicDetailBean.thumbCount++;
                              dynamicDetailBean.thumbed = true;
                            } else {
                              dynamicDetailBean.thumbCount--;
                              dynamicDetailBean.thumbed = false;
                            }
                            return !isLiked;
                          },
                          isLiked: dynamicDetailBean.thumbed,
                          circleColor: CircleColor(
                              start: Colors.orangeAccent, end: Colors.orange),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Colors.orangeAccent,
                            dotSecondaryColor: Colors.orange,
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.redAccent : Colors.black,
                              size: ScreenUtil().setSp(42),
                            );
                          },
                          likeCount: dynamicDetailBean.thumbCount,
                          likeCountPadding: EdgeInsets.only(
                            left: 5
                          ),
                          likeCountAnimationType: dynamicDetailBean.thumbCount < 1000
                              ? LikeCountAnimationType.part
                              : LikeCountAnimationType.none,
                          countBuilder: (int count, bool isLiked, String text) {
                            Color color = isLiked ? Colors.redAccent : Colors.black;
                            Widget result;
                            if (count == 0) {
                              result = SizedBox();
                            } else
                              result = Text(
                                count >= 1000
                                    ? CalculateUtil.simplifyCount(count)
                                    : text,
                                style: TextStyle(color: color),
                              );
                            return result;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigatorUtil.toDynamicDetailPage(context,
                              param: DynamicDetailParam(
                                  scrollToComment: true,
                                  dynamicDetailBean: dynamicDetailBean)
                          );
                        },
                        child: Container(
                            child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                'assets/svg/comment.svg',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ),
                            ),
                            dynamicDetailBean.commentsCount != null &&
                                dynamicDetailBean.commentsCount > 0
                                ? Positioned(
                                    right: -ScreenUtil().setWidth(
                                        CalculateUtil.simplifyCount(
                                            dynamicDetailBean
                                                        .commentsCount)
                                                .length *
                                            8),
                                    top: -ScreenUtil().setHeight(5),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(6)),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(
                                        CalculateUtil.simplifyCount(
                                            dynamicDetailBean.commentsCount),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        )),
                      ),
                      Container(
                          child: SvgPicture.asset(
                        'assets/svg/share.svg',
                        width: ScreenUtil().setWidth(40),
                        height: ScreenUtil().setWidth(40),
                      ))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MediaPreview extends StatelessWidget {
  final DynamicDetailBean dynamicDetailBean;

  MediaPreview({@required this.dynamicDetailBean});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(15),
        ),
        width: ScreenUtil().setWidth(750),
        child: Wrap(
            alignment: WrapAlignment.start,
            spacing: ScreenUtil().setWidth(8),
            runSpacing: ScreenUtil().setHeight(10),
            children:
                List.generate(dynamicDetailBean.mediaList.length, (mediaIndex) {
              double sideLength = ScreenUtil().setWidth(
                  CalculateUtil.calculateWrapElementWidth(
                      dynamicDetailBean.mediaList.length));
              return Container(
                  width: sideLength,
                  height: sideLength,
                  child: GestureDetector(
                    onTap: () {
                      NavigatorUtil.toMediaViewPage(context,
                          param: MediaViewPageParam(
                              mediaList: dynamicDetailBean.mediaList,
                              currentIndex: mediaIndex,
                              businessId: dynamicDetailBean.id,
                              businessType: 1));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: dynamicDetailBean.mediaList[mediaIndex].type == 1
                            ? Hero(
                                tag: '1:${dynamicDetailBean.id}:tag:$mediaIndex',
                                child: CachedNetworkImage(
                                  imageUrl:
                                  dynamicDetailBean.mediaList[mediaIndex].url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    width: sideLength,
                                    height: sideLength,
                                    child: SpinKitPumpingHeart(
                                      color: Theme.of(context).primaryColor,
                                      size: ScreenUtil().setSp(40),
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            : VideoPreview(
                                url: dynamicDetailBean.mediaList[mediaIndex].url,
                                placeHolder: Container(
                                  alignment: Alignment.center,
                                  width: sideLength,
                                  height: sideLength,
                                  child: SpinKitPumpingHeart(
                                    color: Theme.of(context).primaryColor,
                                    size: ScreenUtil().setSp(40),
                                    duration: Duration(milliseconds: 2000),
                                  ),
                                ),
                              )),
                  ));
            })));
  }
}
