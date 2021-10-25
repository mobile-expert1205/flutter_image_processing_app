import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';

import '../common.dart';
import '../custom_radio.dart';

class DictionarySelectorList extends StatelessWidget {
  final VoidCallback? onTap;

  const DictionarySelectorList({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: _selectorBuildWhen,
      builder: _buildSelectorList,
    );
  }

  Widget _buildSelectorList(
    BuildContext context,
    SearchState state,
  ) {
    final List<Widget> list = SearchDictionary.values
        .map<Widget>(
          (SearchDictionary dictionary) => MaterialButton(
            onPressed: () => _setDictionary(context, dictionary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomRadio<SearchDictionary>(
                  value: dictionary,
                  groupValue: state.searchDictionary,
                  onChanged: (_) => _setDictionary(context, dictionary),
                  activeColor: AppColors.backgroundColor,
                  outerColor: Colors.black,
                ),
                Text(
                  getDictionaryName(dictionary),
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

  void _setDictionary(
    BuildContext context,
    SearchDictionary selectedDictionary,
  ) {
    BlocProvider.of<SearchBloc>(context)
        .add(SearchDictionarySet(selectedDictionary));
    if (onTap != null) onTap!();
  }

  bool _selectorBuildWhen(SearchState previous, SearchState current) {
    return previous.searchDictionary != current.searchDictionary;
  }
}
