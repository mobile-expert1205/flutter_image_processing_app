import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/common/app_styles.dart';

/// Implements main logo of application.
class Logo extends StatelessWidget {
  final TextStyle? style;

  const Logo({Key? key, this.style}) : super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.wordFinder.tr(),
      style: style ?? AppStyles.logoLine1,
    );
  }
}
