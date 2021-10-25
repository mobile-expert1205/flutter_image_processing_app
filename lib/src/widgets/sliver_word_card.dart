import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/widgets/common.dart';
import 'package:wordfinderx/src/widgets/cutstom_text_button.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';
import 'package:wordfinderx/src/widgets/sort_selector/sort_dropdown_selector.dart';

import 'dictionary_word/dictionary_word_popup.dart';
import 'rounded_shape.dart';

/// Function to build items on the page.
typedef ItemBuilder = Widget Function({
  required int index,
  required bool isLastItem,
  required bool isFirstItem,
});

/// This class implements word page card.
class SliverWordCard extends StatelessWidget {
  /// Horizontal padding.
  final double _horizontalPadding;

  /// Title height
  final double _titleHeight;

  final bool _isRounded;

  final ApplicationTheme _theme;

  /// Constructor.
  const SliverWordCard({
    Key? key,
    double? horizontalPadding,
    double? titleHeight,
    bool? isRounded,
    ApplicationTheme? theme,
  })  : _horizontalPadding = horizontalPadding ?? 0,
        _titleHeight = titleHeight ?? 57.0,
        _isRounded = isRounded ?? false,
        _theme = theme ?? ApplicationTheme.dark,
        super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return OverlayProgressIndicator<WordPageBloc, WordPageState>(
      child: BlocBuilder<DeviceTypeAndOrientationBloc,
          DeviceTypeAndOrientationState>(
        builder: (BuildContext devCtx, DeviceTypeAndOrientationState devState) {
          if (devState is DeviceTypeAndOrientationKnownState) {
            return BlocConsumer<WordPageBloc, WordPageState>(
              listenWhen: (WordPageState p, WordPageState c) =>
                  p.errorMessage != c.errorMessage,
              listener: _errorListener,
              builder: (BuildContext ctx, WordPageState pageState) {
                return _buildCompactView(ctx, pageState, devState);
              },
            );
          }

          return SliverList(
            delegate: SliverChildListDelegate([Container()]),
          );
        },
      ),
    );
  }

  /// Listener to show errors on bottom Snack Bar.
  void _errorListener(BuildContext context, WordPageState state) {
    String? message;
    switch (state.errorMessage) {
      case WordPageErrorMessage.commonServerError:
        {
          message = LocaleKeys.serverError.tr();
          break;
        }
      case WordPageErrorMessage.none:
        {
          break;
        }
    }
    if (message != null) {
      showTextOnSnackBar(text: message, context: context);
    }
  }

  /// Builds items in compact view mode.
  Widget _buildCompactView(
    BuildContext context,
    WordPageState pageState,
    DeviceTypeAndOrientationKnownState devState,
  ) {
    final List<List<WordModel>> wordCompactList =
        devState.deviceTypeAndOrientation.deviceOrientation ==
                MyDeviceOrientation.portrait
            ? pageState.wordPageModel.wordCompactPage.wordCompactList
            : pageState.wordPageModel.wordCompactPageLandscape.wordCompactList;

    final int length = wordCompactList.length;

    final ItemBuilder itemBuilder = ({
      required int index,
      required bool isLastItem,
      required bool isFirstItem,
    }) =>
        _buildCompactItem(
          context,
          wordCompactList[index],
          isLastItem: isLastItem,
          isFirstItem: isFirstItem,
        );

    return _buildView(pageState, length, itemBuilder);
  }

  /// Builds card depend on given item builder.
  Widget _buildView(
    WordPageState state,
    int length,
    ItemBuilder itemBuilder,
  ) {
    return SliverStickyHeader(
      header: _buildTitle(state),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext ctx, int index) {
            if (index == length) {
              return _buildFooter(ctx);
            }
            return itemBuilder(
              index: index,
              isLastItem:
                  index == length - (state.wordPageModel.isMorePages ? 0 : 1),
              isFirstItem: index == 0,
            );
          },
          childCount: length + (state.wordPageModel.isMorePages ? 1 : 0),
        ),
      ),
    );
  }

  /// Builds compact item.
  Widget _buildCompactItem(
    BuildContext context,
    List<WordModel> wordCompactModel, {
    bool isLastItem = false,
    bool isFirstItem = false,
  }) {
    final List<Widget> widgets = _buildWordTilesRow(
      wordCompactModel: wordCompactModel,
      context: context,
      isFirstItem: isFirstItem,
      isLastItem: isLastItem,
    );

    return _wrapToRounded(
      isFirstItem: isFirstItem,
      isLastItem: isLastItem,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: widgets),
      ),
    );
  }

  Widget _wrapToRounded({
    Widget? child,
    bool isLastItem = false,
    bool isFirstItem = false,
  }) {
    return _theme.isLight
        ? _wrapToRoundedLight(
            child: child,
            isLastItem: isLastItem,
            isFirstItem: isFirstItem,
          )
        : _wrapToRoundedDark(
            child: child,
            isLastItem: isLastItem,
            isFirstItem: isFirstItem,
          );
  }

  Widget _wrapToRoundedDark({
    Widget? child,
    bool isLastItem = false,
    bool isFirstItem = false,
  }) {
    if (!_isRounded || (!isFirstItem && !isLastItem)) {
      return Container(
        color: AppColors.secondaryColor,
        child: child,
      );
    }

    final BorderRadius borderRadius = isFirstItem && isLastItem
        ? BorderRadius.all(Radius.circular(10.0))
        : isFirstItem
            ? BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              );

    return Container(
      color: AppColors.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }

  Widget _wrapToRoundedLight({
    Widget? child,
    bool isLastItem = false,
    bool isFirstItem = false,
  }) {
    if (!_isRounded || !isLastItem) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          border: Border.symmetric(
            vertical: BorderSide(color: AppColors.greyColor),
          ),
        ),
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        shape: RoundedShape(
          drawBottom: true,
          side: BorderSide(color: AppColors.greyColor, width: 1),
          borderRadius: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(color: AppColors.secondaryColor),
          child: child,
        ),
      ),
    );
  }

  List<Widget> _buildWordTilesRow({
    required List<WordModel> wordCompactModel,
    required BuildContext context,
    bool isLastItem = false,
    bool isFirstItem = false,
  }) {
    return wordCompactModel
        .map<Widget>(
          (wordModel) => GestureDetector(
            onTap: () => DictionaryWordPopup.show(context, wordModel.word),
            child: Container(
              width: wordModel.screenWidth,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: isFirstItem ? 20.0 : 8.0,
                  bottom: isLastItem ? 20.0 : 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    color: AppColors.wordBlockBg,
                    border: Border.all(
                      color: AppColors.wordBlockBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildWordText(wordModel)),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: _buildWordPoints(wordModel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList(growable: false);
  }

  /// Builds word points value.
  Widget _buildWordPoints(
    WordModel wordModel, {
    TextStyle style = AppStyles.wordBlockPoints,
  }) {
    return Text(
      '${wordModel.points}',
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
    );
  }

  /// Build word text with highlighted wildcards.
  Widget _buildWordText(WordModel wordModel) {
    final List<String> splitList = _splitWord(wordModel);
    bool isWildcard = true;
    final List<TextSpan> items = splitList.map((String subString) {
      isWildcard = !isWildcard;
      return TextSpan(
        text: subString,
        style: isWildcard
            ? AppStyles.wordBlockWordWildCard
            : AppStyles.wordBlockWord,
      );
    }).toList();

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: items),
    );
  }

  /// Split word into list braked by wildcard values.
  List<String> _splitWord(WordModel wordModel) {
    if (wordModel.wildcards.isEmpty) return [wordModel.word];
    final List<String> splitList = [];
    int startIndex = 0;
    wordModel.wildcards.forEach((int wildcardIndex) {
      splitList.add(wordModel.word.substring(startIndex, wildcardIndex));
      splitList.add(wordModel.word.substring(wildcardIndex, wildcardIndex + 1));
      startIndex = wildcardIndex + 1;
    });
    splitList.add(
      wordModel.word.substring(startIndex, wordModel.word.length),
    );
    return splitList;
  }

  /// Builds title of the word page card.
  Widget _buildTitle(WordPageState state) {
    return Padding(
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
      ),
      child: Container(
        height: _titleHeight,
        color: AppColors.secondaryColor,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: _theme.isLight
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  )
                : null,
            border:
                _theme.isLight ? Border.all(color: AppColors.greyColor) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitleText(state.wordPageModel),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: WordPageSortDropDownSelector(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds title text widget.
  Widget _buildTitleText(WordPageModel wordPageModel) {
    final String titleText = wordPageModel.length == 0
        ? LocaleKeys.allWords.tr()
        : '${wordPageModel.length} ${LocaleKeys.letters.tr()}';
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(
        titleText,
        style: AppStyles.cardTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Builds footer with 'show more' button if there is opportunity to
  /// fetch new words for this page.
  Widget _buildFooter(BuildContext context) {
    return _wrapToRounded(
      isLastItem: true,
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.0,
          left: _horizontalPadding,
          right: _horizontalPadding,
          bottom: 20.0,
        ),
        child: Center(
          child: CustomTextButton(
            buttonWidth: 160.0,
            text: LocaleKeys.more.tr(),
            onTap: () {
              BlocProvider.of<InputBloc>(context).add(UnFocusRequested());
              BlocProvider.of<WordPageBloc>(context)
                  .add(getShowMoreRequestedEvent(context));
            },
          ),
        ),
      ),
    );
  }
}
