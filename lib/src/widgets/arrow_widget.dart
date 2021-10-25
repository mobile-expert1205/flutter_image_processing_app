import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_assets.dart';

class ArrowWidget extends StatelessWidget {
  final bool isCollapsed;
  final Color? color;

  const ArrowWidget({Key? key, bool? isCollapsed, this.color})
      : isCollapsed = isCollapsed ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Image.asset(
        isCollapsed ? AppAssets.arrowDown : AppAssets.arrowUp,
        width: 13.0,
        height: 10.0,
        fit: BoxFit.contain,
        color: color,
      ),
    );
  }
}
