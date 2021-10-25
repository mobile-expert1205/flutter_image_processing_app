import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

class CustomKeyboardDecoration {
  final double _horizontalKeyPaddingRelative;
  final double _verticalKeyPaddingRelative;
  final double _keyHeightRelative;
  final int _maxKeyHorizontally;
  final int _maxKeyVertically;
  final double _bottomPadding;
  final double _searchKeyWidthRelative;
  final double _wildcardKeyWidthRelative;
  final double _width;
  final double _footerFontSize;

  late double _height;
  late double _heightWithFooter;
  late double _letterKeyWidth;
  late double _letterKeyHeight;
  late double _letterKeyFontSize;
  late double _letterKeyHorizontalPadding;
  late double _letterKeyVerticalPadding;
  late double _footerHeight;
  late double _searchKeyWidth;
  late double _backspaceKeyWidth;
  late double _wildcardKeyWidth;
  late double _searchButtonHorizontalPadding;
  late double _searchFontSize;
  late BoxDecoration _keyBoxDecoration;

  double get horizontalKeyPaddingRelative => _horizontalKeyPaddingRelative;

  double get verticalKeyPaddingRelative => _verticalKeyPaddingRelative;

  double get keyHeightRelative => _keyHeightRelative;

  int get maxKeyHorizontally => _maxKeyHorizontally;

  int get maxKeyVertically => _maxKeyVertically;

  double get bottomPadding => _bottomPadding;

  double get width => _width;

  double get height => _height;

  double get heightWithFooter => _heightWithFooter;

  double get letterKeyWidth => _letterKeyWidth;

  double get letterKeyHeight => _letterKeyHeight;

  double get letterKeyFontSize => _letterKeyFontSize;

  double get letterKeyHorizontalPadding => _letterKeyHorizontalPadding;

  double get letterKeyVerticalPadding => _letterKeyVerticalPadding;

  double get footerHeight => _footerHeight;

  double get searchKeyWidth => _searchKeyWidth;

  double get backspaceKeyWidth => _backspaceKeyWidth;

  double get specSymbolKeyWidth => _wildcardKeyWidth;

  double get searchButtonHorizontalPadding => _searchButtonHorizontalPadding;

  double get searchFontSize => _searchFontSize;

  double get footerFontSize => _footerFontSize;

  BoxDecoration get keyBoxDecoration => _keyBoxDecoration;

  CustomKeyboardDecoration({
    required double width,
    double? horizontalKeyPaddingRelative,
    double? verticalKeyPaddingRelative,
    double? keyHeightRelative,
    int? maxKeyHorizontally,
    int? maxKeyVertically,
    double? footerFontSize,
    double? bottomPadding,
    double? searchKeyWidthRelative,
    double? wildcardKeyWidthRelative,
  })  : assert(width > 0),
        _width = width,
        _horizontalKeyPaddingRelative = horizontalKeyPaddingRelative ?? 0.15,
        _verticalKeyPaddingRelative = verticalKeyPaddingRelative ?? 0.15,
        _maxKeyHorizontally = maxKeyHorizontally ?? 10,
        _maxKeyVertically = maxKeyVertically ?? 4,
        _keyHeightRelative = keyHeightRelative ?? 1.3,
        _footerFontSize = footerFontSize ?? 18.0,
        _bottomPadding = bottomPadding ?? 0,
        _searchKeyWidthRelative = searchKeyWidthRelative ?? 5.0,
        _wildcardKeyWidthRelative = wildcardKeyWidthRelative ?? 2.5 {
    _letterKeyWidth = _width /
        (_maxKeyHorizontally +
            (_maxKeyHorizontally + 1) * _horizontalKeyPaddingRelative);
    _letterKeyHeight = _letterKeyWidth * _keyHeightRelative;

    _letterKeyHorizontalPadding =
        _letterKeyWidth * _horizontalKeyPaddingRelative;
    _letterKeyVerticalPadding = _letterKeyHeight * _verticalKeyPaddingRelative;

    _footerHeight = _footerFontSize + 16.0;

    _height = _maxKeyVertically * _letterKeyHeight +
        (_maxKeyVertically + 1) * _letterKeyVerticalPadding +
        _bottomPadding;

    _heightWithFooter = _height + _footerHeight;

    _letterKeyFontSize = _letterKeyHeight * 0.55;

    _searchFontSize = _letterKeyFontSize * 0.9;

    _searchKeyWidth = _letterKeyWidth * _searchKeyWidthRelative;

    _backspaceKeyWidth = _letterKeyWidth * 1.7;

    _wildcardKeyWidth = _letterKeyWidth * _wildcardKeyWidthRelative;

    _searchButtonHorizontalPadding = _letterKeyHorizontalPadding * 2.0;

    _keyBoxDecoration = BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(_letterKeyWidth * 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ]);
  }
}
