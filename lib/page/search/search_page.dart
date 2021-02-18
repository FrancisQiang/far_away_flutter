import 'package:far_away_flutter/page/search/search_item.dart';
import 'package:far_away_flutter/page/search/search_item_wrap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SizedBox(),
        leadingWidth: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.search,
                  size: 22,
                  color: Color(0xFF999999),
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: '请输入关键字',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xFF999999),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    color: Color(0xFF333333),
                    height: 1.3,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (text) {},
                  onSubmitted: (text) {},
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(28)),
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '取消',
                  style: TextStyle(fontSize: ScreenUtil().setSp(28), letterSpacing: 1),
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15), vertical: ScreenUtil().setHeight(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  '热门搜索',
                  style: TextStyle(fontSize: ScreenUtil().setSp(27), fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
              ),
              SearchItemWrap(
                remove: (index) {},
                children: [
                  SearchItem(
                    backgroundColor: Colors.black12,
                    child: Text('测试', style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5
                    ),
                    ),
                    removeItem: Icon(Icons.cancel, size: 15, color: Colors.grey,)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),),
                      removeItem: Icon(Icons.cancel, size: 15, color: Colors.grey,)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克测试测试', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克测试测试', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),)
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  '历史搜索',
                  style: TextStyle(fontSize: ScreenUtil().setSp(27), fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
              ),
              SearchItemWrap(
                remove: (index) {},
                children: [
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('测试', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),
                      ),
                      removeItem: Icon(Icons.cancel, size: 15, color: Colors.grey,)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),),
                      removeItem: Icon(Icons.cancel, size: 15, color: Colors.grey,)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克测试测试', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),)
                  ),
                  SearchItem(
                      backgroundColor: Colors.black12,
                      child: Text('CoCo杜克测试测试', style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5
                      ),)
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
