import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TargetWidthRenderObject extends RenderProxyBox {
  final double targetSize;

  TargetWidthRenderObject(this.targetSize);

  @override
  void performLayout() {
    super.performLayout();

    if (child != null && child!.size.width < targetSize) {
      child!.layout(constraints.copyWith(minWidth: targetSize),
          parentUsesSize: true);
      size = Size(child!.size.width, size.height);
    }
  }
}

class TargetWidthWidget extends SingleChildRenderObjectWidget {
  final double targetWidth;

  const TargetWidthWidget({
    Key? key,
    required Widget child,
    required this.targetWidth,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TargetWidthRenderObject(targetWidth);
  }
}
