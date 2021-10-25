import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/common/app_assets.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/widgets/arrow_widget.dart';

import 'sort_options_selector_list.dart';

typedef TitleBuilder = Widget Function(BuildContext, WordPageState);

class WordPageSortDropDownSelector extends StatefulWidget {
  @override
  _WordPageSortDropDownSelectorState createState() =>
      _WordPageSortDropDownSelectorState();
}

class _WordPageSortDropDownSelectorState
    extends State<WordPageSortDropDownSelector> {
  static const double _selectorTitleTopPadding = 4.0;
  static const double _selectorTitleBottomPadding = 4.0;
  static const double _selectorRightPadding = 8.0;
  static const double _selectorWidth = 180.0;
  OverlayEntry? _menuEntry;
  OverlayEntry? _gestureEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordPageBloc, WordPageState>(
      buildWhen: _buildTitleWhen,
      builder: _titleBuilder,
    );
  }

  bool _buildTitleWhen(WordPageState previous, WordPageState current) =>
      previous.wordPageSortType != current.wordPageSortType;

  Widget _titleBuilder(BuildContext context, WordPageState state) {
    return GestureDetector(
      onTap: () => _onTap(context, state),
      child: _SortSelectorTitle(
        dictionarySelectorArrow: _DictionarySelectorArrow.down,
        wordPageSortType: state.wordPageSortType,
      ),
    );
  }

  void _onTap(BuildContext context, WordPageState state) {
    _gestureEntry = OverlayEntry(builder: (ctx) {
      return Positioned.fill(
        child: GestureDetector(
          onTapDown: (_) => _removeOverlay(),
          child: Container(
            color: AppColors.selectDictionaryOverlayBg,
          ),
        ),
      );
    });

    _menuEntry = OverlayEntry(builder: (ctx) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset position = renderBox.localToGlobal(Offset.zero);

      return Positioned(
        left: position.dx -
            _selectorWidth +
            renderBox.size.width +
            _selectorRightPadding,
        top: position.dy - _selectorTitleTopPadding,
        //width: 100,
        //height: 200,
        child: _SortOptionsDropDownMenu(
          state: state,
          topPadding: _selectorTitleTopPadding,
          bottomPadding: _selectorTitleBottomPadding,
          rightPadding: _selectorRightPadding,
          selectorWidth: _selectorWidth,
          onClose: _removeOverlay,
          onSelect: _onSelect,
        ),
      );
    });

    Overlay.of(context)?.insert(_gestureEntry!);
    Overlay.of(context)?.insert(_menuEntry!);
  }

  void _onSelect(WordPageSortType sortType) {
    BlocProvider.of<InputBloc>(context).add(UnFocusRequested());
    BlocProvider.of<SearchBloc>(context).add(
      SearchWordPageSortTypeChanged(wordPageSortType: sortType),
    );
    _removeOverlay();
  }

  void _removeOverlay() {
    _menuEntry?.remove();
    _menuEntry = null;
    _gestureEntry?.remove();
    _gestureEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}

class _SortOptionsDropDownMenu extends StatelessWidget {
  static const double _selectorTitleHeight = 40.0;
  final WordPageState state;
  final double selectorWidth;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final VoidCallback? onClose;
  final SetSortOptionCallback? onSelect;

  const _SortOptionsDropDownMenu({
    Key? key,
    required this.state,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.selectorWidth = 280.0,
    this.onClose,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTitle(context),
          _buildSelectorBody(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        padding: EdgeInsets.only(
          bottom: bottomPadding,
          top: topPadding,
          right: rightPadding,
        ),
        width: selectorWidth,
        height: _selectorTitleHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: AppColors.backgroundColor,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: _SortSelectorTitle(
            dictionarySelectorArrow: _DictionarySelectorArrow.up,
            wordPageSortType: state.wordPageSortType,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorBody() {
    return Container(
      width: selectorWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 4.0,
          top: 4.0,
        ),
        child: SortOptionsSelectorList(onTap: onSelect, state: state),
      ),
    );
  }
}

enum _DictionarySelectorArrow { up, down }

class _SortSelectorTitle extends StatelessWidget {
  const _SortSelectorTitle({
    Key? key,
    _DictionarySelectorArrow? dictionarySelectorArrow,
    WordPageSortType? wordPageSortType,
  })  : dictionarySelectorArrow =
            dictionarySelectorArrow ?? _DictionarySelectorArrow.up,
        _wordPageSortType = wordPageSortType ?? WordPageSortType.points,
        super(key: key);

  final _DictionarySelectorArrow dictionarySelectorArrow;
  final WordPageSortType _wordPageSortType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Image.asset(
              AppAssets.sortByDesc,
              color: AppColors.secondaryColor,
              width: 12.0,
              height: 12.0,
            ),
          ),
          const SizedBox(width: 6.0),
          Text(
            _wordPageSortType.localized,
            style: AppStyles.sortOptionDropDownTitle,
          ),
          const SizedBox(width: 6.0),
          ArrowWidget(
            isCollapsed:
                dictionarySelectorArrow == _DictionarySelectorArrow.down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

extension Localized on WordPageSortType {
  String get localized {
    switch (this) {
      case WordPageSortType.points:
        return '${LocaleKeys.sort.tr()}: ${LocaleKeys.sortOptionPoints.tr()}';
      case WordPageSortType.az:
        return '${LocaleKeys.sort.tr()}: ${LocaleKeys.sortOptionAZ.tr()}';
      case WordPageSortType.za:
        return '${LocaleKeys.sort.tr()}: ${LocaleKeys.sortOptionZA.tr()}';
    }
  }
}
