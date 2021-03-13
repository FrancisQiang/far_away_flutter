
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class PostTogetherPage extends StatefulWidget {
  @override
  _PostTogetherPageState createState() => _PostTogetherPageState();
}

class _PostTogetherPageState extends State<PostTogetherPage> {
  
  TextEditingController _dynamicContentController = TextEditingController();
  

  // /// 发布动态
  // _postDynamic(TogetherPostProvider togetherPostProvider, String jwt,
  //     String content) async {
  //   // 暂存
  //   bool showLocation = dynamicPostProvider.showLocation;
  //   String location = dynamicPostProvider.location;
  //   double longitude = dynamicPostProvider.addressBeanWrapper?.longitude;
  //   double latitude = dynamicPostProvider.addressBeanWrapper?.latitude;
  //   List<AssetFile> files =
  //   dynamicPostProvider.showLocation = false;
  //   dynamicPostProvider.addressBeanWrapper = null;
  //   dynamicPostProvider.assets.clear();
  //   if (!StringUtil.isEmpty(jwt)) {
  //     Navigator.pop(context);
  //     ToastUtil.showNoticeToast("发布中请稍后");
  //     try {
  //       Response<dynamic> response =
  //       await ApiMethodUtil.getUploadToken(userToken: jwt);
  //       ResponseBean responseBean = ResponseBean.fromJson(response.data);
  //       UploadTokenBean uploadTokenBean =
  //       UploadTokenBean.fromJson(responseBean.data);
  //       DynamicPostBean dynamicPostBean = DynamicPostBean();
  //       dynamicPostBean.content = content;
  //       if (dynamicPostProvider.linkChoose) {
  //         dynamicPostBean.link = dynamicPostProvider.link;
  //         dynamicPostBean.linkImage = dynamicPostProvider.linkData['image'];
  //         dynamicPostBean.linkTitle = dynamicPostProvider.linkData['title'];
  //         dynamicPostBean.type = 1;
  //       } else {
  //         // 上传图片
  //         dynamicPostBean.mediaList =
  //         await _uploadAssets(uploadTokenBean.token, files);
  //         dynamicPostBean.type = 0;
  //       }
  //       if (showLocation) {
  //         dynamicPostBean.location = location;
  //         dynamicPostBean.longitude = longitude;
  //         dynamicPostBean.latitude = latitude;
  //       }
  //       // 链接信息
  //       Response<dynamic> postResponse = await ApiMethodUtil.postDynamic(
  //           token: jwt, dynamicPostBean: dynamicPostBean);
  //       ResponseBean postResponseBean =
  //       ResponseBean.fromJson(postResponse.data);
  //       if (postResponseBean.isSuccess()) {
  //         ToastUtil.showSuccessToast("发布成功");
  //       } else {
  //         ToastUtil.showSuccessToast("发布失败 ${postResponseBean.message}");
  //       }
  //     } catch (ex) {
  //       print(ex);
  //       ToastUtil.showSuccessToast("网络异常 发布失败");
  //     }
  //   } else {
  //     // 处理异常
  //     print('token异常');
  //   }
  // }

  /// 获取定位
  _getLocation() async {
    // 查看权限并校验
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    Position position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    // 获取地址并跳转选择地址详情
    NavigatorUtil.toLocationChoosePage(context,
        longitude: position.longitude.toString(),
        latitude: position.latitude.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalInfoProvider, PostProvider>(
      builder: (context, globalInfoProvider, postProvider, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  child: Icon(FontAwesomeIcons.angleLeft),
                ),
              ),
              title: Text('结伴'),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    color: Colors.yellow,
                    disabledColor: Colors.black26,
                    child: Text(
                      '发布',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2
                      ),
                    ),
                    onPressed: null
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Container(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              minLines: 1,
                              maxLines: 100,
                              keyboardType: TextInputType.multiline,
                              controller: _dynamicContentController,
                              onChanged: (text) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  hintText: '发布你的结伴信息...',
                                  hintStyle: TextStyle(color: Colors.black38),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: _getLocation,
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(80)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.lightBlueAccent,
                                            size: ScreenUtil().setSp(30),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "你在哪里？",
                                            style: TextStyle(
                                                color: Colors.lightBlueAccent,
                                                fontSize:
                                                ScreenUtil().setSp(23)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
