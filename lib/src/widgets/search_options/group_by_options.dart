import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/widgets/ink_well_stack.dart';
import 'package:wordfinderx/src/widgets/search_options/search_options_wrapper.dart';

import '../custom_radio.dart';

class GroupByOptions extends StatelessWidget {
  final SearchBloc _searchBloc;
  final bool? _collapsable;
  final bool _withWrapper;

  const GroupByOptions({
    Key? key,
    required SearchBloc searchBloc,
    bool? collapsable,
    bool? withWrapper,
  })  : _searchBloc = searchBloc,
        _collapsable = collapsable,
        _withWrapper = withWrapper ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_withWrapper) return _buildForm();

    return SearchOptionsWrapper(
      collapsable: _collapsable,
      title: LocaleKeys.sortResultsBy.tr(),
      titleTextStyle: AppStyles.sortFormTitle,
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      buildWhen: (SearchState previous, SearchState current) =>
          previous.groupByOption != current.groupByOption,
      builder: (BuildContext context, SearchState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Divider(color: AppColors.dividerColor, height: 4.0),
              _buildWordLengthItem(state),
              const Divider(color: AppColors.dividerColor, height: 4.0),
              _buildPointsItem(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWordLengthItem(SearchState state) {
    return InkWellStack(
      onTap: () => _onTap(GroupByOption.wordLength),
      child: Row(
        children: [
          _buildRadio(state, GroupByOption.wordLength),
          _buildText(LocaleKeys.wordLowLength.tr()),
        ],
      ),
    );
  }

  Widget _buildPointsItem(SearchState state) {
    return InkWellStack(
      onTap: () => _onTap(GroupByOption.points),
      child: Row(
        children: [
          _buildRadio(state, GroupByOption.points),
          _buildText(LocaleKeys.byPoints.tr()),
        ],
      ),
    );
  }

  Widget _buildRadio(
    SearchState state,
    GroupByOption value,
  ) {
    return CustomRadio<GroupByOption>(
      value: value,
      groupValue: state.groupByOption,
      onChanged: (_) => _onTap(value),
      activeColor: Colors.green,
      outerColor: Colors.black,
    );
  }

  void _onTap(GroupByOption value) =>
      _searchBloc.add(GroupByOptionChanged(value));

  Text _buildText(String text) {
    return Text(text, style: AppStyles.sortOptionsItem);
  }
}
