import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_assets.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/widgets/common.dart';
import 'package:wordfinderx/src/widgets/filtered_input_field/filtered_input_field.dart';
import 'package:wordfinderx/src/widgets/filtered_input_field/filtered_input_field_mixin.dart';

import 'custom_keyboard/custom_keyboard_actions_item_config.dart';

/// This class implements main search field (letters input field,
/// clear button, submit button).

class SearchField extends StatelessWidget with FilteredInputFieldMixin {
  final CustomKeyboardActionsItemConfig _lettersActionsItemConfig;

  final ApplicationTheme _theme;

  /// Constructor.
  SearchField({
    Key? key,
    required lettersActionsItemConfig,
    ApplicationTheme? theme,
  })  : _lettersActionsItemConfig = lettersActionsItemConfig,
        _theme = theme ?? ApplicationTheme.dark,
        super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          border: _theme.isLight
              ? Border.all(color: AppColors.inputFieldBorderColor)
              : null,
        ),
        child: Row(
          children: [
            _buildSearchButton(context),
            Expanded(child: _buildField(context)),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  /// Build letters input field.
  Widget _buildField(BuildContext context) {
    return FilteredInputField<InputBloc, InputEvent, InputState>(
      actionsItemConfig: _lettersActionsItemConfig,
      unFocusSequenceGetter: (InputState s) => s.unFocusSequence,
      initialStringGetter: (InputState s) => s.letters,
      cleanSequenceGetter: (InputState s) => s.cleanSequence,
      changeEventGetter: (String v) => LettersChanged(v),
      submitEventGetter: () => context.getInputSubmitEvent(),
      textAlign: TextAlign.center,
      textStyle: AppStyles.searchText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        border: InputBorder.none,
        filled: false,
        hintText: LocaleKeys.enterLetters.tr(),
        hintStyle: AppStyles.searchHint,
      ),
      cleanEventGetter: () => LettersClearRequested(),
      cleanIconPadding: EdgeInsets.only(left: 12.0),
      processKeyboardEventDelegate: _processKeyboardEventDelegate,
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return BlocBuilder<InputBloc, InputState>(
      buildWhen: (InputState previous, InputState current) =>
          previous.isSearchAllowed != current.isSearchAllowed,
      builder: (BuildContext ctx, InputState state) {
        return GestureDetector(
          onTap: state.isSearchAllowed ? () => context.submitSearch() : null,
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: state.isSearchAllowed ? AppColors.primaryColor : null,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: Image.asset(
                AppAssets.searchIcon,
                width: 20.0,
                height: 20.0,
                fit: BoxFit.contain,
                color: state.isSearchAllowed ? Colors.black : null,
              ),
            ),
          ),
        );
      },
    );
  }

  TextValue _processKeyboardEventDelegate(
      TextValue value, CustomKeyboardEvent event) {
    if (event.eventType == CustomKeyboardEventType.symbol &&
        (value.text.length >= 15 ||
            (event.payload == '?' && getQuestionMarkCount(value.text) >= 2))) {
      return value;
    }

    return processKeyboardEvent(value, event);
  }
}
