import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

import '../ink_well_stack.dart';

class SearchTooltip extends StatefulWidget {
  final Widget? child;

  const SearchTooltip({Key? key, this.child}) : super(key: key);

  @override
  _SearchTooltipState createState() => _SearchTooltipState();
}

class _SearchTooltipState extends State<SearchTooltip> {
  late SuperTooltip _toolTip;

  @override
  void initState() {
    super.initState();

    _toolTip = SuperTooltip(
      content: Material(
        color: Colors.transparent,
        child: widget.child,
      ),
      backgroundColor: AppColors.toolTipBackground,
      borderWidth: 0,
      arrowBaseWidth: 10.0,
      arrowLength: 8.0,
      arrowTipDistance: 10.0,
      hasShadow: false,
      borderRadius: 0,
      popupDirection: TooltipDirection.up,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWellStack(
      onTap: () {
        _toolTip.show(context);
      },
      child: Icon(
        Icons.help_outline,
        color: AppColors.greyColor,
      ),
    );
  }
}
