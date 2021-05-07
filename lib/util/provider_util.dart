import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/page/chat/private_chat_page.dart';
import 'package:far_away_flutter/page/home/comment_draw_widget.dart';
import 'package:far_away_flutter/page/home/dynamic_detail_page.dart';
import 'package:far_away_flutter/page/home/together_detail_page.dart';
import 'package:far_away_flutter/page/main/main_page.dart';
import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:far_away_flutter/page/post/post_dynamic_page.dart';
import 'package:far_away_flutter/page/post/post_together_page.dart';
import 'package:far_away_flutter/provider/comment_chosen_provider.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderUtil {
  static GlobalInfoProvider globalInfoProvider = GlobalInfoProvider();

  static PostProvider postProvider = PostProvider();

  static CommentChosenProvider dynamicCommentChosenProvider =
      CommentChosenProvider();

  static CommentChosenProvider togetherCommentChosenProvider =
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
      ],
      child: TogetherDetailPage(
        scrollToComment: scrollToComment,
        avatarHeroTag: avatarHeroTag,
        togetherInfoBean: togetherInfoBean,
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

  static Widget getPrivateChatPage({String username, String userId, String avatar}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImProvider>.value(value: imProvider)
      ],
      child: PrivateChatPage(
        username: username,
        userId: userId,
        avatar: avatar,
      ),
    );
  }


}
