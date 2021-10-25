import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/widgets/search_options/options_panel.dart';
import 'package:wordfinderx/src/widgets/search_options/search_options_wrapper.dart';

import '../common.dart';
import 'filter_count_notification.dart';
import 'search_filter_options.dart';
import 'search_options_button.dart';
import '../custom_keyboard/custom_keyboard_actions_item_config.dart';

/// This implements advanced search widget to show input fields:
/// starts with, ends with, contains, pattern and buttons.
class SearchOptions extends StatefulWidget {
  final CustomKeyboardActionsItemConfig _startsWithActionsItemConfig;
  final CustomKeyboardActionsItemConfig _endsWithActionsItemConfig;
  final CustomKeyboardActionsItemConfig _containsActionsItemConfig;
  final CustomKeyboardActionsItemConfig _lengthActionsItemConfig;

  final bool _collapsable;

  final double _collapsedHeight;

  final bool _showOptionsPanel;

  final double? _actionButtonWidth;

  final ApplicationTheme _theme;

  /// Constructor.
  const SearchOptions({
    required SearchBloc searchBloc,
    required CustomKeyboardActionsItemConfig startsWithActionsItemConfig,
    required CustomKeyboardActionsItemConfig endsWithActionsItemConfig,
    required CustomKeyboardActionsItemConfig containsActionsItemConfig,
    required CustomKeyboardActionsItemConfig lengthActionsItemConfig,
    Key? key,
    bool? collapsable,
    double? collapsedHeight,
    bool? showOptionsPanel,
    double? actionButtonWidth,
    ApplicationTheme? theme,
  })  : _startsWithActionsItemConfig = startsWithActionsItemConfig,
        _endsWithActionsItemConfig = endsWithActionsItemConfig,
        _containsActionsItemConfig = containsActionsItemConfig,
        _lengthActionsItemConfig = lengthActionsItemConfig,
        _collapsable = collapsable ?? false,
        _showOptionsPanel = showOptionsPanel ?? false,
        _theme = theme ?? ApplicationTheme.dark,
        _collapsedHeight = collapsedHeight ?? 90.0,
        _actionButtonWidth = actionButtonWidth,
        super(key: key);

  @override
  _SearchOptionsState createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  static const EdgeInsets _buttonPadding =
      EdgeInsets.only(top: 16.0, bottom: 16.0);

  SearchOptionsVisibility _lastSearchOptionsVisibility =
      SearchOptionsVisibility.none;

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    if (!widget._collapsable) {
      if (widget._showOptionsPanel) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAdvancedSearchForm(context),
            OptionsPanel(),
            const SizedBox(height: 8.0),
          ],
        ));
      } else {
        return Center(child: _buildAdvancedSearchForm(context));
      }
    }

    return Column(
      children: [
        BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (SearchState previous, SearchState current) =>
              previous.searchOptionsVisibility !=
              current.searchOptionsVisibility,
          builder: (BuildContext ctx, SearchState state) {
            return AnimatedCrossFade(
              alignment: Alignment.topCenter,
              crossFadeState:
                  state.searchOptionsVisibility == SearchOptionsVisibility.none
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              firstChild: _buildAdvancedSearchButton(context, state),
              secondChild: Center(child: _buildForm(state)),
              duration: Duration(milliseconds: 200),
            );
          },
        ),
        if (widget._showOptionsPanel) const SizedBox(height: 4.0),
        if (widget._showOptionsPanel) OptionsPanel(),
        if (widget._showOptionsPanel) const SizedBox(height: 8.0),
      ],
    );
  }

  /// Returns a from depends on selected type.
  Widget _buildForm(SearchState state) {
    final SearchOptionsVisibility searchOptionsVisibility =
        state.searchOptionsVisibility != SearchOptionsVisibility.none
            ? state.searchOptionsVisibility
            : _lastSearchOptionsVisibility;

    switch (searchOptionsVisibility) {
      case SearchOptionsVisibility.none:
        return Container();
      case SearchOptionsVisibility.advancedSearch:
        return _buildAdvancedSearchForm(context);
    }
  }

  /// Returns filter form.
  Widget _buildAdvancedSearchForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: SearchOptionsWrapper(
        theme: widget._theme,
        actionButtonWidth: widget._actionButtonWidth,
        collapsable: widget._collapsable,
        title: widget._collapsable ? null : LocaleKeys.advancedSearch.tr(),
        titleTextStyle: AppStyles.advancedSearchFormTitle,
        child: _buildAdvancedSearchFormContent(),
      ),
    );
  }

  Widget _buildAdvancedSearchFormContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchFilterOptions(
            startsWithActionsItemConfig: widget._startsWithActionsItemConfig,
            endsWithActionsItemConfig: widget._endsWithActionsItemConfig,
            containsActionsItemConfig: widget._containsActionsItemConfig,
            lengthActionsItemConfig: widget._lengthActionsItemConfig,
          ),
        ],
      ),
    );
  }

  /// Returns button that toggles to show filter form.
  Widget _buildAdvancedSearchButton(BuildContext context, SearchState state) {
    return SizedBox(
      height: widget._collapsedHeight,
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: _buttonPadding,
              child: SearchOptionsButton(
                text: LocaleKeys.advancedSearch.tr(),
                isCollapsed: true,
                onTap: (_) => _showAdvancedSearchForm(context, state),
              ),
            ),
            Positioned(top: 0, right: 0, child: FilterCountNotification()),
          ],
        ),
      ),
    );
  }

  void _showAdvancedSearchForm(BuildContext context, SearchState state) {
    if (state.searchOptionsVisibility == SearchOptionsVisibility.none) {
      _lastSearchOptionsVisibility = SearchOptionsVisibility.advancedSearch;
      BlocProvider.of<SearchBloc>(context)
          .add(SearchOptionsVisibilityChanged.advancedSearch());
      BlocProvider.of<InputBloc>(context).add(UnFocusRequested());
    }
  }
}
