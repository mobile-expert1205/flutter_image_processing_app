import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';

import '../custom_radio.dart';

typedef SetSortOptionCallback = Function(WordPageSortType sortType);

class SortOptionsSelectorList extends StatelessWidget {
  final SetSortOptionCallback? onTap;
  final WordPageState? state;

  const SortOptionsSelectorList({
    Key? key,
    this.onTap,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == null) {
      return BlocBuilder<WordPageBloc, WordPageState>(
        buildWhen: _selectorBuildWhen,
        builder: _buildSelectorList,
      );
    }
    return _buildSelectorList(context, state!);
  }

  Widget _buildSelectorList(
    BuildContext context,
    WordPageState state,
  ) {
    final List<Widget> list = WordPageSortType.values
        .map<Widget>(
          (WordPageSortType option) => MaterialButton(
            onPressed: () => _setSortOption(context, option),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomRadio<WordPageSortType>(
                  value: option,
                  groupValue: state.wordPageSortType,
                  onChanged: (_) => _setSortOption(context, option),
                  activeColor: Colors.green,
                  outerColor: Colors.black,
                ),
                Text(
                  option.name,
                  style: AppStyles.dictionarySelectorItem,
                ),
              ],
            ),
          ),
        )
        .toList();
    int len = list.length;
    for (int index = len - 1; index > 0; index--) {
      list.insert(index, Divider(color: AppColors.dividerColor));
    }
    return Column(children: list);
  }

  void _setSortOption(
    BuildContext context,
    WordPageSortType wordPageSortType,
  ) {
    if (onTap != null) onTap!(wordPageSortType);
  }

  bool _selectorBuildWhen(WordPageState previous, WordPageState current) {
    return previous.wordPageSortType != current.wordPageSortType;
  }
}

extension SortOptionName on WordPageSortType {
  String get name {
    switch (this) {
      case WordPageSortType.points:
        return LocaleKeys.sortOptionPoints.tr();
      case WordPageSortType.az:
        return LocaleKeys.sortOptionAZ.tr();
      case WordPageSortType.za:
        return LocaleKeys.sortOptionZA.tr();
    }
  }
}
