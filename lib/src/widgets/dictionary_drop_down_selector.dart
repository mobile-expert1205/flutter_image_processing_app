import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/widgets/arrow_widget.dart';
import 'package:wordfinderx/src/widgets/dictionary_first_start_selector/dictionary_selector_list.dart';
import 'package:wordfinderx/src/widgets/shortest_widget_selector.dart';

import 'common.dart';

typedef TitleBuilder = Widget Function(BuildContext, SearchState);

class DictionaryDropDownSelector extends StatefulWidget {
  final Decoration? containerDecoration;
  final EdgeInsets? containerPadding;

  const DictionaryDropDownSelector({
    Key? key,
    this.containerDecoration,
    this.containerPadding,
  }) : super(key: key);

  @override
  _DictionaryDropDownSelectorState createState() =>
      _DictionaryDropDownSelectorState();
}

class _DictionaryDropDownSelectorState
    extends State<DictionaryDropDownSelector> {
  static const double _selectorTitleTopPadding = 10.0;
  static const double _selectorLeftPadding = 8.0;
  OverlayEntry? _menuEntry;
  OverlayEntry? _gestureEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: _buildTitleWhen,
      builder: _titleBuilder,
    );
  }

  bool _buildTitleWhen(SearchState previous, SearchState current) =>
      previous.searchDictionary != current.searchDictionary;

  Widget _titleBuilder(BuildContext context, SearchState state) {
    final Widget selector = _DictionarySelectorTitle(
      searchDictionary: state.searchDictionary,
      dictionarySelectorArrow: _DictionarySelectorArrow.down,
    );

    return GestureDetector(
      onTap: () => _onTap(context, state),
      child:
          widget.containerDecoration != null || widget.containerPadding != null
              ? Container(
                  width: double.infinity,
                  decoration: widget.containerDecoration,
                  padding: widget.containerPadding ?? EdgeInsets.zero,
                  child: selector,
                )
              : selector,
    );
  }

  void _onTap(BuildContext context, SearchState state) {
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
        left: position.dx - _selectorLeftPadding,
        top: position.dy - _selectorTitleTopPadding,
        //width: 100,
        //height: 200,
        child: _DictionaryDropDownMenu(
          state: state,
          topPadding: _selectorTitleTopPadding,
          leftPadding: _selectorLeftPadding,
          onClose: _removeOverlay,
          onSelect: _onSelect,
        ),
      );
    });

    Overlay.of(context)?.insert(_gestureEntry!);
    Overlay.of(context)?.insert(_menuEntry!);
  }

  void _onSelect() {
    _removeOverlay();
    context.submitSearch();
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

class _DictionaryDropDownMenu extends StatelessWidget {
  final SearchState state;
  static const double _selectorWidth = 280.0;
  final double topPadding;
  final double leftPadding;
  final VoidCallback? onClose;
  final VoidCallback? onSelect;

  const _DictionaryDropDownMenu({
    Key? key,
    required this.state,
    this.topPadding = 0,
    this.leftPadding = 0,
    this.onClose,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          bottom: 12.0,
          top: topPadding,
          left: leftPadding,
        ),
        width: _selectorWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.selectGame.tr(),
                style: AppStyles.dictionarySelectorTitle,
              ),
              ArrowWidget(
                color: AppColors.secondaryColor,
                isCollapsed: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorBody() {
    return Container(
      width: _selectorWidth,
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
        child: DictionarySelectorList(onTap: onSelect),
      ),
    );
  }
}

enum _DictionarySelectorArrow { up, down }

class _DictionarySelectorTitle extends StatelessWidget {
  const _DictionarySelectorTitle({
    Key? key,
    required this.searchDictionary,
    required this.dictionarySelectorArrow,
  }) : super(key: key);

  final SearchDictionary searchDictionary;
  final _DictionarySelectorArrow dictionarySelectorArrow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: ArrowWidget(
            color: Colors.white,
            isCollapsed:
                dictionarySelectorArrow == _DictionarySelectorArrow.down,
          ),
        ),
        ShortestWidgetSelector(
          centered: true,
          widthToSubtract: 20,
          wideChild: _buildTitle(),
          shortChild: _buildTitle(shortForm: true),
        ),
      ],
    );
  }

  Widget _buildTitle({bool? shortForm}) {
    return Container(
      child: Text(
        getDictionaryName(searchDictionary, shortForm: shortForm),
        style: AppStyles.dictionarySelectorTitle,
      ),
    );
  }
}
