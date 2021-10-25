import 'package:flutter/material.dart';

/// This class used to create rounded shape for Material widget.
class RoundedShape extends ShapeBorder {
  /// Constructor.
  RoundedShape({
    this.side = BorderSide.none,
    this.borderRadius = 0,
    this.drawTop = false,
    this.drawBottom = false,
  });

  /// Radius size.
  final double borderRadius;

  /// Side of the border.
  final BorderSide side;

  /// Indicates to draw a top border or not.
  final bool drawTop;

  /// Indicates to draw a bottom border or not.
  final bool drawBottom;

  /// The widths of the sides of this border represented as an [EdgeInsets].
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  /// Creates a copy of this border, scaled by the factor `t`.
  @override
  ShapeBorder scale(double t) {
    return RoundedShape(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  /// Creates a path to draw.
  Path _getPath(Rect rect) {
    final double width = side.width / 2;
    final double left = rect.left + width;
    final double right = rect.right - width;
    final double top = rect.top + width;
    final double bottom = rect.bottom - width;
    final Radius radius = Radius.circular(borderRadius);

    if (drawTop && drawBottom) {
      return Path()
        ..moveTo(left, bottom - borderRadius)
        ..lineTo(left, top + borderRadius)
        ..arcToPoint(Offset(left + borderRadius, top), radius: radius)
        ..lineTo(right - borderRadius, top)
        ..arcToPoint(Offset(right, top + borderRadius), radius: radius)
        ..lineTo(right, bottom - borderRadius)
        ..arcToPoint(Offset(right - borderRadius, bottom), radius: radius)
        ..lineTo(left + borderRadius, bottom)
        ..arcToPoint(Offset(left, bottom - borderRadius), radius: radius);
    } else if (drawTop) {
      return Path()
        ..moveTo(left, bottom + width)
        ..lineTo(left, top + borderRadius)
        ..arcToPoint(Offset(left + borderRadius, top), radius: radius)
        ..lineTo(right - borderRadius, top)
        ..arcToPoint(Offset(right, top + borderRadius), radius: radius)
        ..lineTo(right, bottom + width);
      //..close();
    } else if (drawBottom) {
      return Path()
        ..moveTo(left, top - width)
        ..lineTo(left, bottom - borderRadius)
        ..arcToPoint(Offset(left + borderRadius, bottom),
            radius: radius, clockwise: false)
        ..lineTo(right - borderRadius, bottom)
        ..arcToPoint(Offset(right, bottom - borderRadius),
            radius: radius, clockwise: false)
        ..lineTo(right, top - width);
      //..close();
    }

    return Path();
  }

  /// Create a [Path] that describes the inner edge of the border.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect.deflate(side.width));
  }

  /// Create a [Path] that describes the outer edge of the border.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  /// Paints the border within the given [Rect] on the given [Canvas].
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        Path path = getOuterPath(rect, textDirection: textDirection);
        var paint = side.toPaint();
        canvas.drawPath(path, paint);
        break;
    }
  }
}
