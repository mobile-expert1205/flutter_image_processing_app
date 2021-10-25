import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

import '../arrow_path.dart';

class DictionarySelectorPainter extends CustomPainter {
  final Offset menuButtonOffset;
  final Size menuButtonSize;
  final Offset _menuCircleCenter;
  final double _menuCircleRadius;
  final Offset arrowLineStartPoint;

  DictionarySelectorPainter({
    required this.menuButtonOffset,
    required this.menuButtonSize,
    required this.arrowLineStartPoint,
    double? menuCircleRadialPadding,
  })  : _menuCircleRadius = sqrt(pow(menuButtonSize.width / 2, 2) +
                pow(menuButtonSize.height / 2, 2)) +
            (menuCircleRadialPadding ?? 0),
        _menuCircleCenter = menuButtonOffset.translate(
            menuButtonSize.width / 2, menuButtonSize.height / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final Path bgPath = Path()
      ..addRect(
        Rect.fromLTRB(0, 0, size.width, size.height),
      );

    final Path circlePath = Path()
      ..addOval(
        Rect.fromCircle(center: _menuCircleCenter, radius: _menuCircleRadius),
      );

    final Path pathToDraw =
        Path.combine(PathOperation.difference, bgPath, circlePath);

    final Paint paint = Paint()..color = AppColors.selectDictionaryOverlayBg;

    canvas.drawPath(pathToDraw, paint);

    final Path arrowPath = Path();

    final double lineEndX = _menuCircleCenter.dx - _menuCircleRadius - 5;
    final double lineEndY = _menuCircleCenter.dy;
    final double lineInterX = arrowLineStartPoint.dx;
    final double lineInterY =
        (arrowLineStartPoint.dy - _menuCircleCenter.dy) / 2;

    arrowPath.moveTo(arrowLineStartPoint.dx, arrowLineStartPoint.dy);
    arrowPath.quadraticBezierTo(
      lineInterX,
      lineInterY,
      lineEndX,
      lineEndY,
    );

    final Paint arrowPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;

    canvas.drawPath(ArrowPath.make(path: arrowPath), arrowPaint);
    canvas.drawPath(circlePath, arrowPaint);
  }

  @override
  bool shouldRepaint(DictionarySelectorPainter oldDelegate) {
    return oldDelegate.menuButtonOffset != menuButtonOffset ||
        oldDelegate.menuButtonSize != menuButtonSize;
  }
}
