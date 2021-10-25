import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

class DialogCloseButton extends StatelessWidget {
  final EdgeInsets padding;

  const DialogCloseButton({Key? key, EdgeInsets? padding})
      : padding = padding ?? const EdgeInsets.all(12.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
          ),
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}
