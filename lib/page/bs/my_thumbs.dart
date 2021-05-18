import 'package:flutter/material.dart';


class MyThumbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '我的点赞'
        ),
        centerTitle: true,
      ),
      // body: ListView.separated(
      //   itemBuilder: (context, index) {
      //     return InkWell(
      //       onTap: () =>
      //           NavigatorUtil.toDynamicDetailPage(
      //             context,
      //             param: DynamicDetailParam(
      //               avatarHeroTag:
      //               'dynamic_${dynamics[index].id}',
      //               dynamicDetailBean: dynamics[index],
      //             ),
      //           ),
      //       child: DynamicPreviewCard(
      //         dynamicDetailBean: dynamics[index],
      //       ),
      //     );
      //   },
      //   separatorBuilder: (context, index) {
      //     return Container(
      //       height: 5,
      //       color: Colors.blueGrey.withOpacity(0.1),
      //     );
      //   },
      //   itemCount: dynamics.length,
      // ),
    );
  }
}
