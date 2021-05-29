import 'package:far_away_flutter/bean/address_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LocationChoosePage extends StatefulWidget {
  final String type;

  final String longitude;

  final String latitude;

  LocationChoosePage(
      {@required this.longitude, @required this.latitude, @required this.type});

  @override
  _LocationChoosePageState createState() => _LocationChoosePageState();
}

class _LocationChoosePageState extends State<LocationChoosePage> {
  TextEditingController _searchController = TextEditingController();

  List<AddressBeanWrapper> _addressList = [];

  _getAround() async {
    ResponseBean responseBean = await ApiMethodUtil.getAround(
        location: "${widget.longitude},${widget.latitude}");
    List<dynamic> dataList = responseBean.data;
    for (int i = 0; i < dataList.length; i++) {
      AddressBean addressBean = AddressBean.fromJson(dataList[i]);
      AddressBeanWrapper wrapper = AddressBeanWrapper();
      wrapper.longitude = addressBean.longitude;
      wrapper.latitude = addressBean.latitude;
      wrapper.addressDetail = addressBean.addressDetail;
      wrapper.name = addressBean.name;
      wrapper.type = 0;
      wrapper.choose = false;
      _addressList.add(wrapper);
    }
    setState(() {});
  }

  @override
  void initState() {
    Map<String, AddressBeanWrapper> mapping =
        ProviderUtil.postProvider.addressMapping;
    AddressBeanWrapper wrapper = mapping[widget.type];
    // 添加 不显示当前位置 选项
    // 1 初次进入 wrapper 为 null 此时 choose = true
    // 2 根据 wrapper 的 type 是否为2
    AddressBeanWrapper hide = AddressBeanWrapper();
    hide.type = AddressBeanWrapper.hideType;
    hide.name = '不显示当前位置';
    hide.choose = (wrapper == null || wrapper.type == AddressBeanWrapper.hideType) ;
    _addressList.add(hide);

    if (wrapper != null && wrapper.type != AddressBeanWrapper.hideType) {
      AddressBeanWrapper chooseWrapper = wrapper;
      _addressList.add(chooseWrapper);
    }
    _getAround();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            size: ScreenUtil().setSp(35),
            color: Colors.black54,
          ),
        ),
        title: Container(
          child: Row(
            children: [
              Container(
                child: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(35),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(400),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '搜索附近位置',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              )
            ],
          ),
        ),
        actions: [],
      ),
      body: ListView.separated(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(25),
            top: 10,
            bottom: 20,
          ),
          itemBuilder: (context, index) {
            AddressBeanWrapper wrapper = _addressList[index];
            return Consumer<PostProvider>(
                builder: (context, postProvider, child) {
              return GestureDetector(
                onTap: () {
                  print(widget.type);
                  AddressBeanWrapper change = AddressBeanWrapper();
                  change.longitude = wrapper.longitude;
                  change.latitude = wrapper.latitude;
                  change.name = wrapper.name;
                  change.addressDetail = wrapper.addressDetail;
                  change.choose = true;
                  change.type = wrapper.type;
                  postProvider.addressMapping[widget.type] = change;
                  postProvider.refresh();
                  Navigator.pop(context);
                },
                child: Container(
                  height: ScreenUtil().setHeight(70),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: wrapper.choose
                            ? ScreenUtil().setWidth(650)
                            : ScreenUtil().setWidth(720),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                wrapper.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(32),
                                    letterSpacing: 0.5,
                                    color: wrapper.choose
                                        ? Colors.lightBlueAccent
                                        : Colors.black87),
                              ),
                            ),
                            wrapper.addressDetail == null
                                ? Container()
                                : Container(
                                    child: Text(
                                      wrapper.addressDetail,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(25),
                                          color: Colors.black26),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      wrapper.choose
                          ? Container(
                              child: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.lightBlueAccent,
                                size: ScreenUtil().setSp(35),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            });
          },
          separatorBuilder: (context, index) {
            return Divider(height: 10, color: Colors.grey);
          },
          itemCount: _addressList.length),
    );
  }
}

class AddressBeanWrapper {
  static var defaultType = 0;
  static var cityType = 1;
  static var hideType = 2;

  double longitude;
  double latitude;
  String addressDetail;
  String name;

  /// 0为默认 1为市级位置 2不显示位置
  int type;
  bool choose;

  AddressBeanWrapper(
      {this.longitude,
      this.latitude,
      this.addressDetail,
      this.name,
      this.type,
      this.choose});
}
