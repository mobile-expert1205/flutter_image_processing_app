import 'package:flutter/material.dart';
import 'package:wordfinderx/src/widgets/scroll_up_button/scroll_up_button.dart';

class ScrollUpButtonOverlay extends StatefulWidget {
  final ScrollController scrollController;
  final double? bottom;
  final double? right;
  final Widget child;

  const ScrollUpButtonOverlay({
    Key? key,
    required this.scrollController,
    required this.child,
    this.bottom,
    this.right,
  }) : super(key: key);

  @override
  _ScrollUpButtonOverlayState createState() => _ScrollUpButtonOverlayState(
        scrollController: scrollController,
        child: child,
        bottom: bottom,
        right: right,
      );
}

class _ScrollUpButtonOverlayState extends State<ScrollUpButtonOverlay> {
  final double? _bottom;
  final double? _right;
  final ScrollController _scrollController;
  final Widget _child;
  late OverlayEntry _scrollUpButtonOverlayEntry;

  _ScrollUpButtonOverlayState({
    required Widget child,
    required ScrollController scrollController,
    double? bottom,
    double? right,
  })  : _scrollController = scrollController,
        _bottom = bottom ?? 0,
        _right = right ?? 0,
        _child = child;

  @override
  void initState() {
    super.initState();
    _initScrollUpButtonOverlayEntry();
  }

  void _initScrollUpButtonOverlayEntry() {
    _scrollUpButtonOverlayEntry = OverlayEntry(builder: (BuildContext ctx) {
      return Positioned(
          bottom: _bottom,
          right: _right,
          child: ScrollUpButton(scrollController: _scrollController));
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Overlay.of(context)?.insert(_scrollUpButtonOverlayEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }

  @override
  void dispose() {
    _scrollUpButtonOverlayEntry.remove();
    super.dispose();
  }
}
