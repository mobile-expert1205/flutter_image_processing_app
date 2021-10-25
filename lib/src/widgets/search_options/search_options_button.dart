import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/widgets/arrow_widget.dart';

typedef OnAdvancedButtonTap = void Function(bool);

class SearchOptionsButton extends StatefulWidget {
  final String text;
  final bool? isCollapsed;
  final bool toggleable;
  final OnAdvancedButtonTap? onTap;

  const SearchOptionsButton({
    Key? key,
    required this.text,
    this.isCollapsed,
    this.onTap,
    this.toggleable = false,
  }) : super(key: key);

  @override
  _SearchOptionsButtonState createState() => _SearchOptionsButtonState();
}

class _SearchOptionsButtonState extends State<SearchOptionsButton> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.isCollapsed ?? true;
  }

  @override
  void didUpdateWidget(covariant SearchOptionsButton oldWidget) {
    if (oldWidget.isCollapsed != widget.isCollapsed &&
        widget.isCollapsed != null) {
      setState(() {
        _isCollapsed = widget.isCollapsed!;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildButton(),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onTap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.optionsButtonBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(widget.text, style: AppStyles.optionsButtonTitle),
            ),
          ),
          Positioned(
            right: 3,
            top: 4,
            bottom: 0,
            child: ArrowWidget(isCollapsed: _isCollapsed),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!(_isCollapsed);
      if (widget.toggleable) setState(() => _isCollapsed = !_isCollapsed);
    }
  }
}
