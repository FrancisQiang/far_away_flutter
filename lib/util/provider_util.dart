import 'dart:io';

import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/page/bs/my_thumbs.dart';
import 'package:far_away_flutter/page/chat/private_chat_page.dart';
import 'package:far_away_flutter/page/home/comment_draw_widget.dart';
import 'package:far_away_flutter/page/home/dynamic_detail_page.dart';
import 'package:far_away_flutter/page/home/dynamics_page.dart';
import 'package:far_away_flutter/page/home/recruit_detail_page.dart';
import 'package:far_away_flutter/page/home/together_detail_page.dart';
import 'package:far_away_flutter/page/home/together_info_page.dart';
import 'package:far_away_flutter/page/main/main_page.dart';
import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:far_away_flutter/page/post/post_dynamic_page.dart';
import 'package:far_away_flutter/page/post/post_recruit_page.dart';
import 'package:far_away_flutter/page/post/post_together_page.dart';
import 'package:far_away_flutter/page/profile/birthday_edit_page.dart';
import 'package:far_away_flutter/page/profile/emotion_edit_page.dart';
import 'package:far_away_flutter/page/profile/gender_edit_page.dart';
import 'package:far_away_flutter/page/profile/image_crop_page.dart';
import 'package:far_away_flutter/page/profile/profile_edit_page.dart';
import 'package:far_away_flutter/page/profile/signature_edit_page.dart';
import 'package:far_away_flutter/page/profile/username_edit_page.dart';
import 'package:far_away_flutter/page/recurit/recruit_comment_draw_widget.dart';
import 'package:far_away_flutter/page/user/user_info_page.dart';
import 'package:far_away_flutter/provider/comment_chosen_provider.dart';
import 'package:far_away_flutter/provider/dynamics_provider.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/provider/post_recruit_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderUtil {
  static GlobalInfoProvider globalInfoProvider = GlobalInfoProvider();

  static DynamicsProvider dynamicsProvider = DynamicsProvider();

  static PostProvider postProvider = PostProvider();

  static PostRecruitProvider postRecruitProvider = PostRecruitProvider();

  static CommentChosenProvider dynamicCommentChosenProvider =
      CommentChosenProvider();

  static CommentChosenProvider togetherCommentChosenProvider =
      CommentChosenProvider();

  static CommentChosenProvider recruitCommentChosenProvider =
      CommentChosenProvider();

  static ImProvider imProvider = ImProvider();

  static MultiProvider getMainPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider),
      ],
      child: MainPage(),
    );
  }

  static MultiProvider getPostDynamicPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: PostDynamicPage(),
    );
  }

  static MultiProvider getPostTogetherPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: PostTogetherPage(),
    );
  }

  static MultiProvider getPostRecruitPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostRecruitProvider>.value(
            value: postRecruitProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: PostRecruitPage(),
    );
  }

  static MultiProvider getDynamicDetailPage(
      {bool scrollToComment,
      String avatarHeroTag,
      DynamicDetailBean dynamicDetailBean}) {
    dynamicCommentChosenProvider.targetBizId = dynamicDetailBean.id;
    dynamicCommentChosenProvider.targetUserId = dynamicDetailBean.userId;
    dynamicCommentChosenProvider.targetUsername = dynamicDetailBean.username;
    dynamicCommentChosenProvider.pid = null;
    dynamicCommentChosenProvider.refresh();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentChosenProvider>.value(
            value: dynamicCommentChosenProvider),
        ChangeNotifierProvider<DynamicsProvider>.value(
          value: dynamicsProvider,
        ),
        ChangeNotifierProvider<GlobalInfoProvider>.value(
          value: globalInfoProvider,
        ),
      ],
      child: DynamicDetailPage(
        scrollToComment: scrollToComment,
        avatarHeroTag: avatarHeroTag,
        dynamicDetailBean: dynamicDetailBean,
      ),
    );
  }

  static MultiProvider getTogetherDetailPage(
      {bool scrollToComment,
      String avatarHeroTag,
      TogetherInfoBean togetherInfoBean}) {
    togetherCommentChosenProvider.targetBizId = togetherInfoBean.id;
    togetherCommentChosenProvider.targetUserId = togetherInfoBean.userId;
    togetherCommentChosenProvider.targetUsername = togetherInfoBean.username;
    togetherCommentChosenProvider.pid = null;
    togetherCommentChosenProvider.refresh();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentChosenProvider>.value(
            value: togetherCommentChosenProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider),
      ],
      child: TogetherDetailPage(
        scrollToComment: scrollToComment,
        avatarHeroTag: avatarHeroTag,
        togetherInfoBean: togetherInfoBean,
      ),
    );
  }

  static MultiProvider getRecruitDetailPage(
      {RecruitDetailInfoBean recruitDetailInfoBean}) {
    recruitCommentChosenProvider.targetBizId = recruitDetailInfoBean.id;
    recruitCommentChosenProvider.targetUserId = recruitDetailInfoBean.userId;
    recruitCommentChosenProvider.targetUsername =
        recruitDetailInfoBean.username;
    recruitCommentChosenProvider.pid = null;
    recruitCommentChosenProvider.refresh();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentChosenProvider>.value(
            value: recruitCommentChosenProvider),
      ],
      child: RecruitDetailPage(
        recruitDetailInfoBean: recruitDetailInfoBean,
      ),
    );
  }

  static MultiProvider getLocationChoosePage(
      {@required String longitude,
      @required String latitude,
      @required String type}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
      ],
      child: LocationChoosePage(
        longitude: longitude,
        latitude: latitude,
        type: type,
      ),
    );
  }

  static MultiProvider getCommentDrawWidget(CommentListBean commentListBean) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CommentChosenProvider>.value(
              value: dynamicCommentChosenProvider),
        ],
        child: CommentDrawWidget(
          comment: commentListBean,
        ));
  }

  static MultiProvider getRecruitCommentDrawWidget(
      CommentListBean commentListBean,
      String bizId,
      TextEditingController controller) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CommentChosenProvider>.value(
              value: dynamicCommentChosenProvider),
        ],
        child: RecruitCommentDrawWidget(
          comment: commentListBean,
          bizId: bizId,
          commentEditController: controller,
        ));
  }

  static Widget getPrivateChatPage({
    String username,
    String userId,
    String avatar,
    String togetherId,
    String recruitId,
    String recruitTitle,
    String recruitCover,
  }) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<ImProvider>.value(value: imProvider)],
      child: PrivateChatPage(
        username: username,
        userId: userId,
        avatar: avatar,
        togetherId: togetherId,
        recruitId: recruitId,
        recruitTitle: recruitTitle,
        recruitCover: recruitCover,
      ),
    );
  }

  static MultiProvider getDynamicsPage() {
    return MultiProvider(providers: [
      ChangeNotifierProvider<GlobalInfoProvider>.value(
          value: globalInfoProvider),
      ChangeNotifierProvider<DynamicsProvider>.value(value: dynamicsProvider),
    ], child: DynamicsPage());
  }

  static MultiProvider getTogetherPage() {
    return MultiProvider(providers: [
      ChangeNotifierProvider<GlobalInfoProvider>.value(
          value: globalInfoProvider),
    ], child: TogetherInfoPage());
  }

  static Widget getUserInfoPage({
    @required String userId,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: UserInfoPage(
        userId: userId,
      ),
    );
  }

  static Widget getMyThumbsPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: MyThumbsPage(),
    );
  }

  static Widget getProfileEditPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: ProfileEditPage(),
    );
  }

  static Widget getUsernameEditPage({@required String username}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: UsernameEditPage(
        username: username,
      ),
    );
  }

  static Widget getSignatureEditPage({@required String signature}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: SignatureEditPage(
        signature: signature,
      ),
    );
  }

  static Widget getGenderEditPage({@required int gender}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: GenderEditPage(
        gender: gender,
      ),
    );
  }

  static Widget getEmotionEditPage({@required int emotionStatus}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: EmotionEditPage(
        emotionStatus: emotionStatus,
      ),
    );
  }

  static Widget getBirthdayEditPage({@required int birthday}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: BirthdayEditPage(
        birthday: birthday,
      ),
    );
  }

  static Widget getImageCropPage(
      {@required String url,
      @required Function(File file) confirmCallback,
      double aspectRatio}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(
            value: globalInfoProvider)
      ],
      child: ImageCropPage(
          url: url, confirmCallback: confirmCallback, aspectRatio: aspectRatio),
    );
  }
}
