
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/page/home/comment_draw_widget.dart';
import 'package:far_away_flutter/page/home/dynamic_detail_page.dart';
import 'package:far_away_flutter/page/main/main_page.dart';
import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:far_away_flutter/page/post/post_dynamic_page.dart';
import 'package:far_away_flutter/page/post/post_together_page.dart';
import 'package:far_away_flutter/provider/dynamic_comment_chosen_provider.dart';
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderUtil {

  static GlobalInfoProvider globalInfoProvider = GlobalInfoProvider();

  static PostProvider postProvider = PostProvider();

  static DynamicCommentChosenProvider dynamicCommentChosenProvider = DynamicCommentChosenProvider();

  static MultiProvider getMainPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalInfoProvider>.value(value: globalInfoProvider),
      ],
      child: MainPage(),
    );
  }

  static MultiProvider getPostDynamicPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(value: globalInfoProvider)
      ],
      child: PostDynamicPage(),
    );
  }

  static MultiProvider getPostTogetherPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
        ChangeNotifierProvider<GlobalInfoProvider>.value(value: globalInfoProvider)
      ],
      child: PostTogetherPage(),
    );
  }

  static MultiProvider getDynamicDetailPage({bool scrollToComment, String avatarHeroTag, DynamicDetailBean dynamicDetailBean}) {
    dynamicCommentChosenProvider.targetBizId = dynamicDetailBean.id;
    dynamicCommentChosenProvider.targetUserId = dynamicDetailBean.userId;
    dynamicCommentChosenProvider.targetUsername = dynamicDetailBean.username;
    dynamicCommentChosenProvider.pid = null;
    dynamicCommentChosenProvider.refresh();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DynamicCommentChosenProvider>.value(value: dynamicCommentChosenProvider),
      ],
      child: DynamicDetailPage(
        scrollToComment: scrollToComment,
        avatarHeroTag: avatarHeroTag,
        dynamicDetailBean: dynamicDetailBean,
      ),
    );
  }

  static MultiProvider getLocationChoosePage({@required String longitude, @required String latitude}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>.value(value: postProvider),
      ],
      child: LocationChoosePage(
        longitude: longitude,
        latitude: latitude,
      ),
    );
  }


  static MultiProvider getCommentDrawWidget(CommentListBean commentListBean) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DynamicCommentChosenProvider>.value(value: dynamicCommentChosenProvider),
      ],
      child: CommentDrawWidget(
        comment: commentListBean,
      )
    );
  }


}