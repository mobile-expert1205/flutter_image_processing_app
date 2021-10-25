import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/widgets/custom_checkbox.dart';

import '../common.dart';
import '../custom_checkbox.dart';

class GroupByCheckBox extends StatelessWidget {
  final SearchBloc? _searchBloc;
  final GroupByCheckBoxTheme _theme;
  final bool boxFromRight;
  final Decoration? containerDecoration;
  final EdgeInsets? containerPadding;
  final TextStyle textStyle;
  final double? boxSize;
  final double? strokeWidth;
  final bool centered;

  const GroupByCheckBox({
    Key? key,
    SearchBloc? searchBloc,
    GroupByCheckBoxTheme? theme,
    bool? boxFromRight,
    bool? centered,
    this.containerDecoration,
    this.containerPadding,
    this.textStyle = AppStyles.groupByLengthTitle,
    this.boxSize,
    this.strokeWidth,
  })  : _searchBloc = searchBloc,
        _theme = theme ?? GroupByCheckBoxTheme.light,
        boxFromRight = boxFromRight ?? false,
        centered = centered ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      buildWhen: (SearchState previous, SearchState current) =>
          previous.groupByOption != current.groupByOption,
      builder: (BuildContext context, SearchState state) {
        final List<Widget> widgets = boxFromRight
            ? [
                _buildText(context, state),
                const SizedBox(width: 12.0),
                _buildBox(state, context),
              ]
            : [
                _buildBox(state, context),
                const SizedBox(width: 12.0),
                _buildText(context, state),
              ];

        Widget row = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        );
        if (centered) row = Center(child: row);
        return GestureDetector(
          onTap: () => _setGroupByOption(
            context,
            state.groupByOption != GroupByOption.wordLength,
          ),
          child: containerDecoration != null || containerPadding != null
              ? Container(
                  decoration: containerDecoration,
                  padding: containerPadding ?? EdgeInsets.zero,
                  child: row,
                )
              : row,
        );
      },
    );
  }

  Widget _buildBox(SearchState state, BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.selected,
      };
      if (states.any(interactiveStates.contains)) {
        return _theme == GroupByCheckBoxTheme.dark
            ? AppColors.secondaryColor
            : AppColors.backgroundColor;
      }
      return _theme == GroupByCheckBoxTheme.dark
          ? AppColors.filterInput
          : AppColors.secondaryColor;
    }

    return CustomCheckbox(
      strokeWidth: strokeWidth,
      width: boxSize,
      value: state.groupByOption == GroupByOption.wordLength,
      onChanged: (bool? isChecked) => _setGroupByOption(context, isChecked),
      checkColor: _theme == GroupByCheckBoxTheme.dark
          ? AppColors.backgroundColor
          : AppColors.secondaryColor,
      activeColor: _theme == GroupByCheckBoxTheme.dark
          ? AppColors.secondaryColor
          : AppColors.backgroundColor,
      side: BorderSide(
        width: strokeWidth ?? 1,
        color: _theme == GroupByCheckBoxTheme.dark
            ? AppColors.filterInput
            : AppColors.secondaryColor,
      ),
      fillColor: MaterialStateProperty.resolveWith(getColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildText(BuildContext context, SearchState state) {
    return GestureDetector(
      onTap: () => _setGroupByOption(
        context,
        state.groupByOption != GroupByOption.wordLength,
      ),
      child: Center(
        child: Text(
          LocaleKeys.groupByLength.tr(),
          style: _theme == GroupByCheckBoxTheme.dark
              ? textStyle
              : textStyle.copyWith(color: AppColors.secondaryColor),
        ),
      ),
    );
  }

  void _setGroupByOption(BuildContext context, bool? isChecked) {
    isChecked ??= false;
    BlocProvider.of<SearchBloc>(context).add(
      isChecked
          ? GroupByOptionChanged.wordLength()
          : GroupByOptionChanged.points(),
    );
    context.submitSearch();
  }
}

enum GroupByCheckBoxTheme { dark, light }
