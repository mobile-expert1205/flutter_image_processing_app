import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This class implements sliver item that has size to fill all available
/// space in screen.
class SliverToBoxAdapterFilled extends SingleChildRenderObjectWidget {
  final double? additionalExtent;

  /// Constructor.
  const SliverToBoxAdapterFilled({
    Key? key,
    required Widget child,
    this.additionalExtent,
  }) : super(key: key, child: child);

  /// Creates an instance of the [RenderObject] class that this
  /// [RenderObjectWidget] represents, using the configuration described by this
  /// [RenderObjectWidget].
  @override
  RenderSliverToBoxAdapterFilled createRenderObject(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return RenderSliverToBoxAdapterFilled(
      maxSize: height,
      additionalExtent: additionalExtent,
    );
  }
}

/// Render object for SliverToBoxAdapterFilled.
class RenderSliverToBoxAdapterFilled extends RenderSliverSingleBoxAdapter {
  /// The remaining value to fill all available space.
  double? _remainingPaintExtent;

  /// the maximum screen size.
  final double _maxSize;

  final double _additionalExtent;

  /// Constructor.
  RenderSliverToBoxAdapterFilled({
    RenderBox? child,
    required double maxSize,
    double? additionalExtent,
  })  : _maxSize = maxSize,
        _additionalExtent = additionalExtent ?? 0,
        super(child: child);

  /// Performs layout.
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    if (_remainingPaintExtent == null) {
      _remainingPaintExtent =
          _maxSize + _additionalExtent - this.constraints.precedingScrollExtent;
      _remainingPaintExtent =
          _remainingPaintExtent! < 0 ? 0 : _remainingPaintExtent;
    }

    final SliverConstraints constraints = this.constraints;
    switch (constraints.axis) {
      case Axis.horizontal:
        child!.layout(
          constraints
              .asBoxConstraints()
              .copyWith(maxWidth: _remainingPaintExtent),
          parentUsesSize: true,
        );
        break;
      case Axis.vertical:
        child!.layout(
          constraints
              .asBoxConstraints()
              .copyWith(maxHeight: _remainingPaintExtent),
          parentUsesSize: true,
        );
        break;
    }

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}
