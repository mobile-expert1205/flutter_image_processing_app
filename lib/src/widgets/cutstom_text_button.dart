import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';

import 'ink_well_stack.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? buttonWidth;

  const CustomTextButton({
    Key? key,
    required this.text,
    this.onTap,
    this.buttonWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellStack(
      onTap: onTap,
      child: Container(
        height: 40,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppStyles.gradientButtonText,
          ),
        ),
      ),
    );
  }
}
