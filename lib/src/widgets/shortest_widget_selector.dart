import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShortestWidgetRenderObject extends RenderProxyBox
    with
        ContainerRenderObjectMixin<RenderBox, ShortestWidgetParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ShortestWidgetParentData> {
  RenderBox? _childToPaint;
  final bool centered;
  final double widthToSubtract;

  ShortestWidgetRenderObject({
    List<RenderBox>? children,
    bool? centered,
    double? widthToSubtract,
  })  : centered = centered ?? false,
        widthToSubtract = widthToSubtract ?? 0 {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = ShortestWidgetParentData();
    }
  }

  @override
  void performLayout() {
    super.performLayout();
    firstChild!.layout(
      constraints.copyWith(minWidth: 0),
      parentUsesSize: true,
    );
    if (firstChild!.size.width < constraints.maxWidth - widthToSubtract) {
      _childToPaint = firstChild;
    } else {
      final RenderBox secondChild = childAfter(firstChild!)!;
      secondChild.layout(
        constraints,
        parentUsesSize: true,
      );
      _childToPaint = secondChild;
    }
    late double width;
    late double height;
    if (_childToPaint!.size.width >= constraints.minWidth &&
        _childToPaint!.size.width <= constraints.maxWidth) {
      width = _childToPaint!.size.width;
    } else {
      if (_childToPaint!.size.width < constraints.minWidth) {
        width = constraints.minWidth;
      }
      if (_childToPaint!.size.width > constraints.maxWidth) {
        width = constraints.maxWidth;
      }
    }

    if (_childToPaint!.size.height >= constraints.minHeight &&
        _childToPaint!.size.height <= constraints.maxHeight) {
      height = _childToPaint!.size.height;
    } else {
      if (_childToPaint!.size.height < constraints.minHeight) {
        height = constraints.minHeight;
      }
      if (_childToPaint!.size.height > constraints.maxHeight) {
        height = constraints.maxHeight;
      }
    }
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final Offset childOffset = centered
        ? offset.translate(
            (constraints.maxWidth - _childToPaint!.size.width) / 2,
            0,
          )
        : offset;
    context.paintChild(_childToPaint!, childOffset);
  }
}

class ShortestWidgetSelector extends MultiChildRenderObjectWidget {
  final bool? centered;
  final double? widthToSubtract;

  ShortestWidgetSelector({
    Key? key,
    required Widget wideChild,
    required Widget shortChild,
    this.centered,
    this.widthToSubtract,
  }) : super(
          key: key,
          children: <Widget>[wideChild, shortChild],
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ShortestWidgetRenderObject(
      centered: centered,
      widthToSubtract: widthToSubtract,
    );
  }
}

class ShortestWidgetParentData extends ContainerBoxParentData<RenderBox> {}
