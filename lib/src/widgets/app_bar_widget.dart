import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_assets.dart';
import 'package:wordfinderx/src/widgets/ink_well_stack.dart';

class LogoAppBarWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const LogoAppBarWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellStack(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Center(child: Image.asset(AppAssets.logoAppBar, height: 28.0)),
      ),
    );
  }
}
