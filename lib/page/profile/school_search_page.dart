import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/list_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/school_search_bean.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SchoolSearchPage extends StatefulWidget {
  @override
  _SchoolSearchPageState createState() => _SchoolSearchPageState();
}

class _SchoolSearchPageState extends State<SchoolSearchPage> {
  TextEditingController _searchController;

  List<SchoolSearchBean> searchResult = [];

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(240, 243, 245, 1),
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          title: Text(
            '选择学校',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (text) async {
                  Response response = await ApiMethodUtil.searchSchool(
                      token: globalInfoProvider.jwt,
                      keyword: _searchController.text);
                  ResponseBean responseBean =
                      ResponseBean.fromJson(response.data);
                  ListBean listBean = ListBean.fromJson(responseBean.data);
                  searchResult.clear();
                  listBean.listData.forEach((element) {
                    searchResult.add(SchoolSearchBean.fromJson(element));
                  });
                  setState(() {});
                },
                onSubmitted: (text) async {
                  Response response = await ApiMethodUtil.searchSchool(
                      token: globalInfoProvider.jwt,
                      keyword: _searchController.text);
                  ResponseBean responseBean =
                      ResponseBean.fromJson(response.data);
                  ListBean listBean = ListBean.fromJson(responseBean.data);
                  searchResult.clear();
                  listBean.listData.forEach((element) {
                    searchResult.add(SchoolSearchBean.fromJson(element));
                  });
                  setState(() {});
                },
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                decoration: InputDecoration(
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        searchResult.clear();
                      });
                    },
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        color: Colors.grey[400],
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: ScreenUtil().setSp(25),
                        ),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(240, 243, 245, 1),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.0)),
                  hintText: '搜索你的学校',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(50.0),
          ),
        ),
        body: ListView.separated(
          itemCount: searchResult.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                Response res = await ApiMethodUtil.editUserInfo(
                    token: globalInfoProvider.jwt,
                    school: searchResult[index].name);
                ResponseBean responseBean = ResponseBean.fromJson(res.data);
                if (responseBean.isSuccess()) {
                  ToastUtil.showSuccessToast("修改成功");
                  globalInfoProvider.userInfoBean.school =
                      searchResult[index].name;
                  globalInfoProvider.refresh();
                } else {
                  ToastUtil.showSuccessToast("修改失败");
                }
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                height: 45,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: searchResult[index].name,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Colors.black)),
                    TextSpan(
                        text: '  ',
                        style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                    TextSpan(
                        text: searchResult[index].address,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                            color: Colors.grey)),
                    TextSpan(
                        text: '/${searchResult[index].schoolType}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                            color: Colors.grey))
                  ]),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Colors.grey,
                height: 0.02,
              ),
            );
          },
        ),
      );
    });
  }
}
