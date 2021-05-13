// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/common.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/rich_text.dart';
import 'package:far_away_flutter/page/post/post_recruit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:notus/notus.dart';

import 'controller.dart';
import 'editable_box.dart';
import 'editable_text.dart';
import 'image.dart';
import 'mode.dart';
import 'scaffold.dart';
import 'scope.dart';
import 'theme.dart';
import 'toolbar.dart';

/// Widget for editing Zefyr documents.
class ZefyrEditor extends StatefulWidget {
  const ZefyrEditor({
    Key key,
    @required this.controller,
    @required this.focusNode,
    this.autofocus = true,
    this.mode = ZefyrMode.edit,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.toolbarDelegate,
    this.imageDelegate,
    this.selectionControls,
    this.physics,
    this.keyboardAppearance,
    this.customAboveWidget,
    this.customBottomWidget,
    this.useEasyRefresh = false,
    this.easyRefreshController,
    this.onRefresh,
    this.onLoad,
    this.enableControlFinishRefresh = false,
    this.enableControlFinishLoad = false,
    this.taskIndependence = false,
    this.scrollController,
    this.header,
    this.footer,
    this.firstRefresh,
    this.firstRefreshWidget,
    this.headerIndex,
    this.emptyWidget,
    this.topBouncing = true,
    this.bottomBouncing = true,
  })  : assert(mode != null),
        assert(controller != null),
        assert(focusNode != null),
        super(key: key);

  /// 用户自定义组件 在editor上方
  final Widget customAboveWidget;
  final Widget customBottomWidget;
  final bool useEasyRefresh;

  final EasyRefreshController easyRefreshController;

  /// 刷新回调(null为不开启刷新)
  final OnRefreshCallback onRefresh;

  /// 加载回调(null为不开启加载)
  final OnLoadCallback onLoad;

  final bool enableControlFinishRefresh;
  final bool enableControlFinishLoad;
  final bool taskIndependence;
  final ScrollController scrollController;

  /// Header
  final Header header;

  /// Footer
  final Footer footer;

  /// 首次刷新
  final bool firstRefresh;

  /// 首次刷新组件
  /// 不设置时使用header
  final Widget firstRefreshWidget;

  final int headerIndex;

  /// 空视图
  /// 当不为null时,只会显示空视图
  /// 保留[headerIndex]以上的内容
  final Widget emptyWidget;

  final bool topBouncing;
  final bool bottomBouncing;

  /// Controls the document being edited.
  final ZefyrController controller;

  /// Controls whether this editor has keyboard focus.
  final FocusNode focusNode;

  /// Whether this editor should focus itself if nothing else is already
  /// focused.
  ///
  /// If true, the keyboard will open as soon as this text field obtains focus.
  /// Otherwise, the keyboard is only shown after the user taps the text field.
  ///
  /// Defaults to true. Cannot be null.
  final bool autofocus;

  /// Editing mode of this editor.
  final ZefyrMode mode;

  /// Optional delegate for customizing this editor's toolbar.
  final ZefyrToolbarDelegate toolbarDelegate;

  /// Delegate for resolving embedded images.
  ///
  /// This delegate is required if embedding images is allowed.
  final ZefyrImageDelegate imageDelegate;

  /// Optional delegate for building the text selection handles and toolbar.
  ///
  /// If not provided then platform-specific implementation is used by default.
  final TextSelectionControls selectionControls;

  /// Controls physics of scrollable editor.
  final ScrollPhysics physics;

  /// Padding around editable area.
  final EdgeInsets padding;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness keyboardAppearance;

  @override
  _ZefyrEditorState createState() => _ZefyrEditorState();
}

class _ZefyrEditorState extends State<ZefyrEditor> {
  ZefyrImageDelegate _imageDelegate;
  ZefyrScope _scope;
  ZefyrThemeData _themeData;
  GlobalKey<ZefyrToolbarState> _toolbarKey;
  ZefyrScaffoldState _scaffold;

  bool get hasToolbar => _toolbarKey != null;

  void showToolbar() {
    assert(_toolbarKey == null);
    _toolbarKey = GlobalKey();
    _scaffold.showToolbar(buildToolbar);
  }

  void hideToolbar() {
    if (_toolbarKey == null) return;
    _scaffold.hideToolbar(buildToolbar);
    _toolbarKey = null;
  }

  Widget buildToolbar(BuildContext context) {
    return ZefyrTheme(
      data: _themeData,
      child: ZefyrToolbar(
        key: _toolbarKey,
        editor: _scope,
        delegate: widget.toolbarDelegate,
      ),
    );
  }

  void _handleChange() {
    if (_scope.focusOwner == FocusOwner.none) {
      hideToolbar();
    } else if (!hasToolbar) {
      showToolbar();
    } else {
      // TODO: is there a nicer way to do this?
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _toolbarKey?.currentState?.markNeedsRebuild();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageDelegate = widget.imageDelegate;
  }

  @override
  void didUpdateWidget(ZefyrEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scope.mode = widget.mode;
    _scope.controller = widget.controller;
    _scope.focusNode = widget.focusNode;
    if (widget.imageDelegate != oldWidget.imageDelegate) {
      _imageDelegate = widget.imageDelegate;
      _scope.imageDelegate = _imageDelegate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final parentTheme = ZefyrTheme.of(context, nullOk: true);
    final fallbackTheme = ZefyrThemeData.fallback(context);
    _themeData = (parentTheme != null)
        ? fallbackTheme.merge(parentTheme)
        : fallbackTheme;

    if (_scope == null) {
      _scope = ZefyrScope.editable(
        mode: widget.mode,
        imageDelegate: _imageDelegate,
        controller: widget.controller,
        focusNode: widget.focusNode,
        focusScope: FocusScope.of(context),
      );
      _scope.addListener(_handleChange);
    } else {
      final focusScope = FocusScope.of(context);
      _scope.focusScope = focusScope;
    }

    final scaffold = ZefyrScaffold.of(context);
    if (_scaffold != scaffold) {
      final didHaveToolbar = hasToolbar;
      hideToolbar();
      _scaffold = scaffold;
      if (didHaveToolbar) showToolbar();
    }
  }

  @override
  void dispose() {
    hideToolbar();
    _scope.removeListener(_handleChange);
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final keyboardAppearance =
        widget.keyboardAppearance ?? themeData.primaryColorBrightness;

    if (widget.mode == ZefyrMode.view) {
      return EasyRefresh(
        scrollController: widget.scrollController,
        firstRefresh: widget.firstRefresh,
        firstRefreshWidget: widget.firstRefreshWidget,
        header: widget.header,
        footer: widget.footer,
        onRefresh: widget.onRefresh,
        onLoad: widget.onLoad,
        behavior: OverScrollBehavior(),
        child: Column(
          children: [
            widget.customAboveWidget,
            ListBody(children: _buildChildren(context)),
            widget.customBottomWidget == null
                ? Container()
                : widget.customBottomWidget,
          ],
        ),
      );
    }

    Widget editable = ZefyrEditableText(
      controller: _scope.controller,
      focusNode: _scope.focusNode,
      imageDelegate: _scope.imageDelegate,
      selectionControls: widget.selectionControls,
      autofocus: widget.autofocus,
      mode: widget.mode,
      padding: widget.padding,
      physics: widget.physics,
      keyboardAppearance: keyboardAppearance,
      customAboveWidget: widget.customAboveWidget,
      customBottomWidget: widget.customBottomWidget,
      useEasyRefresh: widget.useEasyRefresh,
      easyRefreshController: widget.easyRefreshController,
      onRefresh: widget.onRefresh,
      onLoad: widget.onLoad,
      enableControlFinishRefresh: widget.enableControlFinishRefresh,
      enableControlFinishLoad: widget.enableControlFinishLoad,
      taskIndependence: widget.taskIndependence,
      scrollController: widget.scrollController,
      header: widget.header,
      footer: widget.footer,
      firstRefresh: widget.firstRefresh,
      firstRefreshWidget: widget.firstRefreshWidget,
      headerIndex: widget.headerIndex,
      emptyWidget: widget.emptyWidget,
      topBouncing: widget.topBouncing,
      bottomBouncing: widget.bottomBouncing,
    );

    return ZefyrTheme(
      data: _themeData,
      child: ZefyrScopeAccess(
        scope: _scope,
        child: editable,
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final result = <Widget>[];
    for (var node in widget.controller.document.root.children) {
      result.add(_defaultChildBuilder(context, node));
    }
    return result;
  }

  Widget _defaultChildBuilder(BuildContext context, Node node) {
    if (node is LineNode) {
      return ZefyrParagraphCustom(
          node: node,
          lineStyle: TextStyle(),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: 6
          ),
          imageDelegate: widget.imageDelegate);
    }

    final BlockNode block = node;
    final blockStyle = block.style.get(NotusAttribute.block);

    throw UnimplementedError('Block format $blockStyle.');
  }
}

class ZefyrParagraphCustom extends StatelessWidget {
  ZefyrParagraphCustom(
      {Key key,
      @required this.node,
      this.blockStyle,
      this.lineStyle,
      this.padding,
      this.imageDelegate})
      : super(key: key);

  final LineNode node;
  final TextStyle blockStyle;
  final TextStyle lineStyle;
  final EdgeInsets padding;
  final ZefyrImageDelegate imageDelegate;

  @override
  Widget build(BuildContext context) {
    return ZefyrLineCustom(
      node: node,
      style: lineStyle,
      padding: padding,
      imageDelegate: imageDelegate,
    );
  }
}

class ZefyrLineCustom extends StatefulWidget {
  const ZefyrLineCustom(
      {Key key,
      @required this.node,
      this.style,
      this.padding,
      this.imageDelegate})
      : assert(node != null),
        super(key: key);

  /// Line in the document represented by this widget.
  final LineNode node;

  /// Style to apply to this line. Required for lines with text contents,
  /// ignored for lines containing embeds.
  final TextStyle style;

  /// Padding to add around this paragraph.
  final EdgeInsets padding;

  final ZefyrImageDelegate imageDelegate;

  @override
  _ZefyrLineCustomState createState() => _ZefyrLineCustomState();
}

class _ZefyrLineCustomState extends State<ZefyrLineCustom> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.node.hasEmbed) {
      content = buildEmbed(context);
    } else {
      content = ZefyrRichText(
        node: widget.node,
        text: buildText(context),
      );
    }

    if (widget.padding != null) {
      return Padding(padding: widget.padding, child: content);
    }
    return content;
  }

  void bringIntoView(BuildContext context) {
    final scrollable = Scrollable.of(context);
    final object = context.findRenderObject();
    assert(object.attached);
    final viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    final offset = scrollable.position.pixels;
    var target = viewport.getOffsetToReveal(object, 0.0).offset;
    if (target - offset < 0.0) {
      scrollable.position.jumpTo(target);
      return;
    }
    target = viewport.getOffsetToReveal(object, 1.0).offset;
    if (target - offset > 0.0) {
      scrollable.position.jumpTo(target);
    }
  }

  TextSpan buildText(BuildContext context) {
    final children = widget.node.children
        .map((node) => _segmentToTextSpan(node))
        .toList(growable: false);
    return TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          height: 1.3,
        ),
        children: children);
  }

  TextSpan _segmentToTextSpan(Node node) {
    final TextNode segment = node;
    final attrs = segment.style;

    return TextSpan(
      text: segment.value,
      style: _getTextStyle(attrs),
    );
  }

  TextStyle _getTextStyle(NotusStyle style) {
    var result = TextStyle();
    return result;
  }

  Widget buildEmbed(BuildContext context) {
    EmbedNode node = widget.node.children.single;
    EmbedAttribute embed = node.style.get(NotusAttribute.embed);

    if (embed.type == EmbedType.image) {
      return ZefyrImageCustom(node: node, delegate: widget.imageDelegate);
    }
    return Container();
  }
}

class ZefyrImageCustom extends StatefulWidget {
  const ZefyrImageCustom(
      {Key key, @required this.node, @required this.delegate})
      : super(key: key);

  final EmbedNode node;
  final ZefyrImageDelegate delegate;

  @override
  _ZefyrImageCustomState createState() => _ZefyrImageCustomState();
}

class _ZefyrImageCustomState extends State<ZefyrImageCustom> {
  String get imageSource {
    EmbedAttribute attribute = widget.node.style.get(NotusAttribute.embed);
    return attribute.value['source'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.delegate.buildImage(context, imageSource);
    return Padding(
      padding: EdgeInsets.zero,
      child: image,
    );
  }
}
