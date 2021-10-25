import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/widgets/target_width_widget.dart';

import '../dictionary_drop_down_selector.dart';
import 'group_by_check_box.dart';

class OptionsPanel extends StatelessWidget {
  static const double _gapWidth = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(fit: FlexFit.loose, child: _buildGameSelector()),
          const SizedBox(width: _gapWidth),
          _buildGroupByCheckBox((constraints.maxWidth - _gapWidth) / 2),
        ],
      );
    });
  }

  Widget _buildGameSelector() {
    return DictionaryDropDownSelector(
      containerPadding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6.0,
      ),
      containerDecoration: BoxDecoration(
        border: Border.all(color: AppColors.optionsButtonBg, width: 1.0),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _buildGroupByCheckBox(double targetWidth) {
    return TargetWidthWidget(
      targetWidth: targetWidth,
      child: GroupByCheckBox(
        centered: true,
        boxFromRight: true,
        containerPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        containerDecoration: BoxDecoration(
          border: Border.all(color: AppColors.optionsButtonBg, width: 1.0),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
