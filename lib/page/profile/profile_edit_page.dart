import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/upload_response_bean.dart';
import 'package:far_away_flutter/bean/upload_token_bean.dart';
import 'package:far_away_flutter/constant/profile.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  double coverHeight = ScreenUtil().setHeight(250);

  String parseBirthday(int birthday) {
    return "${DateUtil.getFormatDate(birthday)} ${DateUtil.getConstellation(birthday)}";
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Color.fromRGBO(240, 243, 245, 1);
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '编辑个人信息',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(30)),
        ),
      ),
      body: Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: coverHeight,
                    child: CachedNetworkImage(
                      imageUrl: globalInfoProvider.userInfoBean.cover,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final PickedFile file = await _picker.getImage(
                                source: ImageSource.gallery);
                            if (file == null) return null;
                            NavigatorUtil.toImageCropPage(context,
                                url: file.path,
                                confirmCallback: (File cropImage) async {
                                  ResponseBean responseBean =
                                  await ApiMethodUtil.getUploadToken();
                              UploadTokenBean uploadTokenBean =
                                  UploadTokenBean.fromJson(responseBean.data);
                              UploadResponseBean uploadResponseBean =
                                  await ApiMethodUtil.uploadPicture(
                                      token: uploadTokenBean.token,
                                      file: cropImage,
                                      filename: '${Uuid().v4()}');
                              responseBean = await ApiMethodUtil.editUserInfo(
                                  avatar: ApiProperties.ASSET_PREFIX_URL +
                                      uploadResponseBean.key);
                              if (responseBean.isSuccess()) {
                                ToastUtil.showSuccessToast("修改成功");
                                globalInfoProvider.userInfoBean.avatar =
                                    ApiProperties.ASSET_PREFIX_URL +
                                        uploadResponseBean.key;
                                globalInfoProvider.refresh();
                              } else {
                                ToastUtil.showErrorToast("修改失败");
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 10)
                              ],
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.5,
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(120),
                                imageUrl:
                                    globalInfoProvider.userInfoBean.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final PickedFile file = await _picker.getImage(
                              source: ImageSource.gallery);
                          if (file == null) return null;
                          NavigatorUtil.toImageCropPage(context,
                              url: file.path, aspectRatio: 16.0 / 9.0,
                              confirmCallback: (File cropImage) async {
                                ResponseBean responseBean =
                                await ApiMethodUtil.getUploadToken();
                            UploadTokenBean uploadTokenBean =
                                UploadTokenBean.fromJson(responseBean.data);
                            UploadResponseBean uploadResponseBean =
                                await ApiMethodUtil.uploadPicture(
                                    token: uploadTokenBean.token,
                                    file: cropImage,
                                    filename: '${Uuid().v4()}');
                                responseBean = await ApiMethodUtil.editUserInfo(
                                cover: ApiProperties.ASSET_PREFIX_URL +
                                    uploadResponseBean.key);
                            if (responseBean.isSuccess()) {
                              ToastUtil.showSuccessToast("修改成功");
                              globalInfoProvider.userInfoBean.cover =
                                  ApiProperties.ASSET_PREFIX_URL +
                                      uploadResponseBean.key;
                              globalInfoProvider.refresh();
                            } else {
                              ToastUtil.showErrorToast("修改失败");
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(22),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '更换封面',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(22)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              Divider(
                height: 5,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '昵称',
                info: globalInfoProvider.userInfoBean.userName,
                extraInfo: '2-15个字符，30天内限修改一次',
                onPressed: () {
                  NavigatorUtil.toUsernameEditPage(context,
                      username: globalInfoProvider.userInfoBean.userName);
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '签名',
                info: globalInfoProvider.userInfoBean.signature,
                hintInfo: '介绍一下你自己',
                onPressed: () {
                  NavigatorUtil.toSignatureEditPage(
                    context,
                    signature: globalInfoProvider.userInfoBean.signature,
                  );
                },
              ),
              Divider(
                height: 5,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '性别',
                info: GenderConst
                    .descriptionMap[globalInfoProvider.userInfoBean.gender],
                onPressed: () {
                  NavigatorUtil.toGenderEditPage(
                    context,
                    gender: globalInfoProvider.userInfoBean.gender,
                  );
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '情感',
                info: EmotionStatusConst.descriptionMap[
                    globalInfoProvider.userInfoBean.emotionState],
                hintInfo: "你的情感状态",
                onPressed: () {
                  NavigatorUtil.toEmotionEditPage(
                    context,
                    emotionStatus: globalInfoProvider.userInfoBean.emotionState,
                  );
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '生日',
                info: parseBirthday(globalInfoProvider.userInfoBean.birthday),
                extraInfo: "为你保密，只展示星座",
                onPressed: () {
                  NavigatorUtil.toBirthdayEditPage(
                    context,
                    birthday: globalInfoProvider.userInfoBean.birthday,
                  );
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '所在地',
                info: globalInfoProvider.userInfoBean.location,
                hintInfo: "你在哪儿",
                onPressed: () async {
                  String originLocation =
                      globalInfoProvider.userInfoBean.location;
                  Result result = await CityPickers.showCityPicker(
                    context: context,
                    height: ScreenUtil().setHeight(400),
                    locationCode: "321171",
                  );
                  if (result == null) {
                    return;
                  }
                  String location =
                      "${result.provinceName}·${result.cityName}·${result.areaName}";
                  globalInfoProvider.userInfoBean.location = location;
                  globalInfoProvider.refresh();
                  ResponseBean responseBean = await ApiMethodUtil.editUserInfo(
                    location: location,
                  );
                  if (responseBean.isSuccess()) {
                    ToastUtil.showSuccessToast("修改成功");
                  } else {
                    ToastUtil.showErrorToast("修改失败");
                    globalInfoProvider.userInfoBean.location = originLocation;
                    globalInfoProvider.refresh();
                  }
                },
              ),
              Divider(
                height: 5,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '学校',
                info: globalInfoProvider.userInfoBean.school,
                onPressed: () {
                  NavigatorUtil.toSchoolSearchPage(
                    context,
                  );
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '专业',
                info: globalInfoProvider.userInfoBean.major,
                onPressed: () {
                  NavigatorUtil.toMajorEditPage(context,
                      major: globalInfoProvider.userInfoBean.major);
                },
              ),
              Divider(
                height: 1.2,
                color: Colors.transparent,
              ),
              ProfileEditItem(
                title: '行业',
                info: globalInfoProvider.userInfoBean.industry,
                onPressed: () {
                  NavigatorUtil.toIndustryEditPage(context,
                      industry: globalInfoProvider.userInfoBean.industry);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileEditItem extends StatelessWidget {
  final String title;

  final String info;

  final String hintInfo;

  final String extraInfo;

  final Function onPressed;

  ProfileEditItem(
      {this.title, this.info, this.hintInfo, this.extraInfo, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        hoverColor: Color.fromRGBO(240, 243, 245, 1),
        splashColor: Color.fromRGBO(240, 243, 245, 1),
        highlightColor: Color.fromRGBO(240, 243, 245, 1),
        padding: EdgeInsets.zero,
        color: Colors.white,
        onPressed: () {
          onPressed();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          height: extraInfo != null ? 55 : 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setWidth(150),
                child: Text(
                  title,
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        StringUtil.isEmpty(info) ? hintInfo : info,
                        style: TextStyle(
                          color: StringUtil.isEmpty(info)
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                    extraInfo == null
                        ? SizedBox()
                        : Container(
                            child: Text(
                              extraInfo,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(22),
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
