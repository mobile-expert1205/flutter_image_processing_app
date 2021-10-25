import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

class InputFieldContainer extends StatelessWidget {
  final Widget? child;

  const InputFieldContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: AppColors.inputFieldBorderColor,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
