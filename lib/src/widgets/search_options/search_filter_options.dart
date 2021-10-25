import 'package:flutter/material.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/widgets/filtered_input_field/filtered_input_field_mixin.dart';
import 'package:wordfinderx/src/widgets/input_filed_container.dart';
import 'package:wordfinderx/src/widgets/search_options/search_options_wrapper.dart';

import '../common.dart';
import '../custom_keyboard/custom_keyboard_actions_item_config.dart';
import '../filtered_input_field/filtered_input_field.dart';
import 'search_tooltip.dart';

/// This implements advanced search widget to show input fields:
/// starts with, ends with, contains, pattern and buttons.
class SearchFilterOptions extends StatelessWidget with FilteredInputFieldMixin {
  final CustomKeyboardActionsItemConfig _startsWithActionsItemConfig;
  final CustomKeyboardActionsItemConfig _endsWithActionsItemConfig;
  final CustomKeyboardActionsItemConfig _containsActionsItemConfig;
  final CustomKeyboardActionsItemConfig _lengthActionsItemConfig;

  final bool? _collapsable;
  final bool _withWrapper;

  static const InputDecoration _inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 0.0, bottom: 10.0),
    fillColor: Colors.transparent,
    hintStyle: AppStyles.filterInputHint,
  );

  /// Constructor.
  const SearchFilterOptions({
    required CustomKeyboardActionsItemConfig startsWithActionsItemConfig,
    required CustomKeyboardActionsItemConfig endsWithActionsItemConfig,
    required CustomKeyboardActionsItemConfig containsActionsItemConfig,
    required CustomKeyboardActionsItemConfig lengthActionsItemConfig,
    Key? key,
    bool? collapsable,
    bool? withWrapper,
  })  : _startsWithActionsItemConfig = startsWithActionsItemConfig,
        _endsWithActionsItemConfig = endsWithActionsItemConfig,
        _containsActionsItemConfig = containsActionsItemConfig,
        _lengthActionsItemConfig = lengthActionsItemConfig,
        _collapsable = collapsable,
        _withWrapper = withWrapper ?? false,
        super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    if (!_withWrapper) return _buildInputFieldsTable(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SearchOptionsWrapper(
        collapsable: _collapsable,
        title: LocaleKeys.filter.tr(),
        titleTextStyle: AppStyles.filterFormTitle,
        child: _buildInputFieldsTable(context),
      ),
    );
  }

  /// Returns table contains 4 input fields:
  /// (starts with, ends with, contains, pattern).
  Widget _buildInputFieldsTable(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _buildStartsField(context),
          _buildEndsField(context),
        ]),
        TableRow(children: [
          _buildContainsField(context),
          _buildLengthField(context),
        ]),
      ],
    );
  }

  /// Returns starts with input field.
  Widget _buildStartsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      child: InputFieldContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilteredInputField<InputBloc, InputEvent, InputState>(
            actionsItemConfig: _startsWithActionsItemConfig,
            unFocusSequenceGetter: (InputState s) => s.unFocusSequence,
            cleanSequenceGetter: (InputState s) => s.cleanSequence,
            cleanEventGetter: () => StartsWithClearRequested(),
            initialStringGetter: (InputState s) => s.startsWith,
            changeEventGetter: (String v) => StartWithChanged(v),
            submitEventGetter: () => context.getInputSubmitEvent(),
            decoration: _inputDecoration.copyWith(
              hintText: LocaleKeys.startsWith.tr(),
            ),
            processKeyboardEventDelegate: processKeyboardEvent,
            alternativeCleanAction:
                SearchTooltip(child: _buildStartWithTooltipContent()),
          ),
        ),
      ),
    );
  }

  /// Returns ends with input field.
  Widget _buildEndsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: InputFieldContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilteredInputField<InputBloc, InputEvent, InputState>(
            actionsItemConfig: _endsWithActionsItemConfig,
            unFocusSequenceGetter: (InputState s) => s.unFocusSequence,
            cleanSequenceGetter: (InputState s) => s.cleanSequence,
            cleanEventGetter: () => EndsWithClearRequested(),
            initialStringGetter: (InputState s) => s.endsWith,
            changeEventGetter: (String v) => EndWithChanged(v),
            submitEventGetter: () => context.getInputSubmitEvent(),
            decoration: _inputDecoration.copyWith(
              hintText: LocaleKeys.endsWith.tr(),
            ),
            processKeyboardEventDelegate: processKeyboardEvent,
            alternativeCleanAction:
                SearchTooltip(child: _buildEndWithTooltipContent()),
          ),
        ),
      ),
    );
  }

  /// Returns contains input field.
  Widget _buildContainsField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      child: InputFieldContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilteredInputField<InputBloc, InputEvent, InputState>(
            unFocusSequenceGetter: (InputState s) => s.unFocusSequence,
            cleanSequenceGetter: (InputState s) => s.cleanSequence,
            cleanEventGetter: () => ContainsClearRequested(),
            initialStringGetter: (InputState s) => s.contains,
            actionsItemConfig: _containsActionsItemConfig,
            changeEventGetter: (String v) => ContainsChanged(v),
            submitEventGetter: () => context.getInputSubmitEvent(),
            decoration: _inputDecoration.copyWith(
              hintText: LocaleKeys.contains.tr(),
            ),
            processKeyboardEventDelegate: processKeyboardEvent,
            alternativeCleanAction:
                SearchTooltip(child: _buildContainsTooltipContent()),
          ),
        ),
      ),
    );
  }

  /// Returns pattern input field.
  Widget _buildLengthField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: InputFieldContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilteredInputField<InputBloc, InputEvent, InputState>(
            actionsItemConfig: _lengthActionsItemConfig,
            unFocusSequenceGetter: (InputState s) => s.unFocusSequence,
            cleanSequenceGetter: (InputState s) => s.cleanSequence,
            cleanEventGetter: () => LengthClearRequested(),
            initialStringGetter: (InputState s) => s.length,
            changeEventGetter: (String v) => LengthChanged(v),
            submitEventGetter: () => context.getInputSubmitEvent(),
            decoration: _inputDecoration.copyWith(
              hintText: LocaleKeys.lengthFirstCapital.tr(),
            ),
            processKeyboardEventDelegate: _processLengthKeyboardEvent,
            alternativeCleanAction:
                SearchTooltip(child: _buildLengthTooltipContent()),
          ),
        ),
      ),
    );
  }

  TextValue _processLengthKeyboardEvent(
      TextValue value, CustomKeyboardEvent event) {
    if (event.eventType == CustomKeyboardEventType.backspace) {
      if (value.cursorPosition > 0 && value.text.isNotEmpty) {
        return TextValue(text: '', cursorPosition: 0);
      }
    } else if (event.eventType == CustomKeyboardEventType.symbol) {
      return TextValue(
          text: event.payload, cursorPosition: event.payload.length);
    }
    return TextValue();
  }

  Widget _buildStartWithTooltipContent() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: LocaleKeys.findWordsThat.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.start.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.withTheseLetters.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.aBHighlighted.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
            text: LocaleKeys.toolTipArrow.tr(),
            style: AppStyles.toolTipNormalText,
          ),
          TextSpan(
              text: LocaleKeys.aB.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.lE.tr(), style: AppStyles.toolTipNormalText),
        ],
      ),
    );
  }

  Widget _buildEndWithTooltipContent() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: LocaleKeys.findWordsThat.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.end.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.inTheseLetters.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.aBHighlighted.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
            text: LocaleKeys.toolTipArrow.tr(),
            style: AppStyles.toolTipNormalText,
          ),
          TextSpan(
              text: LocaleKeys.cCapital.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.ab.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.closedBracket.tr(),
              style: AppStyles.toolTipNormalText),
        ],
      ),
    );
  }

  Widget _buildContainsTooltipContent() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: LocaleKeys.wordsThatContainLetters.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.aBHighlighted.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.toolTipArrow.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.cCapital.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.ab.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.lE.tr(), style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.orInCertain.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.xS.tr(),
              style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.toolTipArrow.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.eCapital.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.x.tr(), style: AppStyles.toolTipHighlightedText),
          TextSpan(text: LocaleKeys.e.tr(), style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.s.tr(), style: AppStyles.toolTipHighlightedText),
          TextSpan(
              text: LocaleKeys.closedBracket.tr(),
              style: AppStyles.toolTipNormalText),
        ],
      ),
    );
  }

  Widget _buildLengthTooltipContent() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: LocaleKeys.onlyShowWordsWithASpecific.tr(),
              style: AppStyles.toolTipNormalText),
          TextSpan(
              text: LocaleKeys.length.tr(),
              style: AppStyles.toolTipHighlightedText),
        ],
      ),
    );
  }
}
