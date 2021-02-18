import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostAssetItem extends StatefulWidget {

  final AssetEntity assetEntity;

  final double sideLength;

  final Function remove;

  PostAssetItem({@required this.assetEntity, @required this.sideLength, this.remove});

  @override
  _PostAssetItemState createState() => _PostAssetItemState();
}

class _PostAssetItemState extends State<PostAssetItem>
    with TickerProviderStateMixin {

  Animation<double> _sideLengthAnimation;

  Animation<double> _opacityLengthAnimation;

  AnimationController _animationController;

  double _horizontalMargin = 1;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _opacityLengthAnimation =
        Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _sideLengthAnimation =
        Tween(begin: widget.sideLength, end: 0.0).animate(_animationController)..addListener(() {
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: _horizontalMargin
      ),
      child: Opacity(
        opacity: _opacityLengthAnimation.value,
        child: Stack(
          children: [
            Container(
              height: widget.sideLength,
              width: _sideLengthAnimation.value,
              child: ExtendedImage(
                image: AssetEntityImageProvider(
                  widget.assetEntity,
                  isOriginal: false,
                  thumbSize: [200, 200],
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: widget.assetEntity.type != AssetType.video ? SizedBox() : Icon(FontAwesomeIcons.play, color: Colors.white,),
              ),
            ),
            Positioned(
              right: 2,
              top: 2,
              child: GestureDetector(
                onTap: () {
                  _animationController.forward()
                    ..whenComplete(() {
                      widget.remove();
                      setState(() {
                        _horizontalMargin = 0;
                      });
                    });
                },
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
