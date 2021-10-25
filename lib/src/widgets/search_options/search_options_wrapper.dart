import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/widgets/arrow_widget.dart';
import 'package:wordfinderx/src/widgets/cutstom_text_button.dart';
import 'package:wordfinderx/src/widgets/ink_well_stack.dart';

import '../common.dart';

/// This implements advanced search widget to show input fields:
/// starts with, ends with, contains, pattern and buttons.
class SearchOptionsWrapper extends StatelessWidget {
  final Widget child;

  final String title;

  final TextStyle? _titleTextStyle;

  final bool _collapsable;

  final double? _actionButtonWidth;

  final bool showActionButton;

  final ApplicationTheme theme;

  /// Constructor.
  SearchOptionsWrapper({
    Key? key,
    required this.child,
    String? title,
    TextStyle? titleTextStyle,
    bool? collapsable,
    double? actionButtonWidth,
    bool? showActionButton,
    ApplicationTheme? theme,
  })  : title = title ?? '',
        _titleTextStyle = titleTextStyle,
        _collapsable = collapsable ?? true,
        _actionButtonWidth = actionButtonWidth,
        showActionButton = showActionButton ?? true,
        theme = theme ?? ApplicationTheme.dark,
        super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: theme.isLight ? Border.all(color: AppColors.greyColor) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14.0),
          _buildTitle(context),
          const SizedBox(height: 10.0),
          child,
          if (showActionButton) const SizedBox(height: 20.0),
          if (showActionButton) _buildSearchButton(),
          SizedBox(height: showActionButton ? 22.0 : 10.0),
        ],
      ),
    );
  }

  /// Returns search button.
  Widget _buildSearchButton() {
    return BlocBuilder<InputBloc, InputState>(
      buildWhen: (InputState previous, InputState current) =>
          previous.isSearchAllowed != current.isSearchAllowed,
      builder: (BuildContext ctx, InputState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomTextButton(
            buttonWidth: _actionButtonWidth,
            text: LocaleKeys.search.tr(),
            onTap: state.isSearchAllowed ? () => _search(ctx) : null,
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return InkWellStack(
      onTap: _collapsable ? () => _onTap(context) : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_collapsable) const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                title,
                style: _titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            if (_collapsable) ArrowWidget(isCollapsed: false),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    BlocProvider.of<SearchBloc>(context)
        .add(SearchOptionsVisibilityChanged.none());
    BlocProvider.of<InputBloc>(context).add(UnFocusRequested());
  }

  /// Does search.
  void _search(BuildContext context) {
    context.submitSearch();
  }
}
