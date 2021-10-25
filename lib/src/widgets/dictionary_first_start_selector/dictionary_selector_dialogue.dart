import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cutstom_text_button.dart';
import 'dictionary_selector_list.dart';

typedef OnHeightCallback = void Function(Offset);

class DictionarySelectorDialogue extends StatelessWidget {
  final double _dialogueOwnMargin = 16.0;
  final VoidCallback? onSubmit;
  final OnHeightCallback? onHeightCallback;

  const DictionarySelectorDialogue({
    Key? key,
    this.onSubmit,
    this.onHeightCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    final double bottomPadding = mediaQueryData.padding.bottom;

    _addOnPositionCallback(context, bottomPadding);

    return Container(
      width: width,
      margin: EdgeInsets.only(
        bottom: bottomPadding + _dialogueOwnMargin,
        left: _dialogueOwnMargin,
        right: _dialogueOwnMargin,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          top: 0.0,
        ),
        child: Material(
          color: Colors.transparent,
          child: _buildSelector(),
        ),
      ),
    );
  }

  void _addOnPositionCallback(BuildContext context, double bottomPadding) {
    if (onHeightCallback != null) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox;
        if (renderBox != null) {
          final Offset position = renderBox.localToGlobal(Offset.zero);
          onHeightCallback!(position);
        }
      });
    }
  }

  Widget _buildSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              LocaleKeys.plsSelectDictionary.tr(),
              style: AppStyles.dictionarySelectorDialogueTitle,
            ),
          ),
        ),
        Divider(color: AppColors.dividerColor),
        DictionarySelectorList(),
        const SizedBox(height: 16.0),
        CustomTextButton(
          onTap: onSubmit,
          text: LocaleKeys.ok.tr(),
        ),
      ],
    );
  }
}
