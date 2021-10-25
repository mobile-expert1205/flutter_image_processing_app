import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';
import 'package:wordfinderx/src/widgets/search_options/search_options.dart';
import 'package:wordfinderx/src/widgets/search_field.dart';

import '../common.dart';
import 'custom_keyboard.dart';
import 'custom_keyboard_builder.dart';
import 'custom_keyboard_decoration.dart';
import 'custom_length_keyboard_builder.dart';
import 'custom_letter_keyboard_builder.dart';
import 'custom_keyboard_actions_item_config.dart';

mixin CustomKeyboardActionsConfigMixin<T extends StatefulWidget> on State<T> {
  final CustomKeyboardActionsItemConfig lettersActionsItemConfig =
      CustomKeyboardActionsItemConfig();
  final CustomKeyboardActionsItemConfig startsWithActionsItemConfig =
      CustomKeyboardActionsItemConfig();
  final CustomKeyboardActionsItemConfig endsWithActionsItemConfig =
      CustomKeyboardActionsItemConfig();
  final CustomKeyboardActionsItemConfig containsActionsItemConfig =
      CustomKeyboardActionsItemConfig();
  final CustomKeyboardActionsItemConfig lengthActionsItemConfig =
      CustomKeyboardActionsItemConfig();

  KeyboardActionsConfig? keyboardActionsConfig;

  CustomKeyboardDecoration? _letterKeyboardDecoration;
  CustomKeyboardDecoration? _lengthKeyboardDecoration;

  @override
  void initState() {
    super.initState();
    keyboardActionsConfig ??= _buildConfig();
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: lettersActionsItemConfig.focusNode,
          footerBuilder: (BuildContext ctx) => _buildLetterKeyboard(
            context: ctx,
            key: ValueKey(1),
            valueNotifier: lettersActionsItemConfig.valueNotifier,
            footerText: LocaleKeys.lettersDescription.tr(),
            customKeyboardBuilder: CustomLetterKeyboardBuilder(),
            wildcard: '?',
          ),
        ),
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: startsWithActionsItemConfig.focusNode,
          footerBuilder: (BuildContext ctx) => _buildLetterKeyboard(
            context: ctx,
            key: ValueKey(2),
            valueNotifier: startsWithActionsItemConfig.valueNotifier,
            customKeyboardBuilder: CustomLetterKeyboardBuilder(),
          ),
        ),
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: endsWithActionsItemConfig.focusNode,
          footerBuilder: (BuildContext ctx) => _buildLetterKeyboard(
            context: ctx,
            key: ValueKey(3),
            valueNotifier: endsWithActionsItemConfig.valueNotifier,
            customKeyboardBuilder: CustomLetterKeyboardBuilder(),
          ),
        ),
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: containsActionsItemConfig.focusNode,
          footerBuilder: (BuildContext ctx) => _buildLetterKeyboard(
            key: ValueKey(4),
            context: ctx,
            valueNotifier: containsActionsItemConfig.valueNotifier,
            wildcard: '_',
            customKeyboardBuilder: CustomLetterKeyboardBuilder(),
          ),
        ),
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: lengthActionsItemConfig.focusNode,
          footerBuilder: (BuildContext ctx) => _buildLengthKeyboard(
            context: ctx,
            key: ValueKey(5),
            valueNotifier: lengthActionsItemConfig.valueNotifier,
            customKeyboardBuilder: CustomLengthKeyboardBuilder(),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildLetterKeyboard({
    required Key key,
    required BuildContext context,
    required ValueNotifier<CustomKeyboardEvent> valueNotifier,
    required CustomKeyboardBuilder customKeyboardBuilder,
    String footerText = '',
    String wildcard = '',
  }) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    if (_letterKeyboardDecoration == null ||
        width != _letterKeyboardDecoration!.width) {
      final double bottomPadding = mediaQueryData.viewPadding.bottom;
      final DeviceTypeAndOrientationModel deviceTypeAndOrientation =
          _getDeviceTypeAndOrientation(mediaQueryData.size, bottomPadding);
      _letterKeyboardDecoration =
          _getCustomKeyboardDecoration(deviceTypeAndOrientation);
    }

    return CustomKeyboard(
      key: key,
      valueNotifier: valueNotifier,
      footerText: footerText,
      decoration: _letterKeyboardDecoration!,
      customKeyboardBuilder: customKeyboardBuilder,
      wildcard: wildcard,
    );
  }

  PreferredSizeWidget _buildLengthKeyboard({
    required Key key,
    required BuildContext context,
    required ValueNotifier<CustomKeyboardEvent> valueNotifier,
    required CustomKeyboardBuilder customKeyboardBuilder,
    String footerText = '',
    String wildcard = '',
  }) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    if (_lengthKeyboardDecoration == null ||
        width != _lengthKeyboardDecoration!.width) {
      final double bottomPadding = mediaQueryData.viewPadding.bottom;

      final DeviceTypeAndOrientationModel deviceTypeAndOrientation =
          _getDeviceTypeAndOrientation(mediaQueryData.size, bottomPadding);
      _lengthKeyboardDecoration = _getCustomKeyboardDecoration(
        deviceTypeAndOrientation,
        maxKeyVertically: 3,
      );
    }

    return CustomKeyboard(
      key: key,
      valueNotifier: valueNotifier,
      footerText: footerText,
      decoration: _lengthKeyboardDecoration!,
      customKeyboardBuilder: customKeyboardBuilder,
      wildcard: wildcard,
    );
  }

  CustomKeyboardDecoration _getCustomKeyboardDecoration(
    DeviceTypeAndOrientationModel deviceTypeAndOrientation, {
    int? maxKeyVertically,
  }) {
    return CustomKeyboardDecoration(
      width: deviceTypeAndOrientation.width,
      bottomPadding: deviceTypeAndOrientation.bottomPadding,
      keyHeightRelative: _getKeyHeightRelative(deviceTypeAndOrientation),
      searchKeyWidthRelative:
          _getSearchKeyWidthRelative(deviceTypeAndOrientation),
      wildcardKeyWidthRelative:
          _getWildcardKeyWidthRelative(deviceTypeAndOrientation),
      maxKeyVertically: maxKeyVertically,
    );
  }

  double _getKeyHeightRelative(
      DeviceTypeAndOrientationModel deviceTypeAndOrientation) {
    if (deviceTypeAndOrientation.deviceType == MyDeviceType.phone) return 1.3;
    if (deviceTypeAndOrientation.deviceOrientation ==
        MyDeviceOrientation.portrait) return 0.9;
    return 0.6;
  }

  double _getSearchKeyWidthRelative(
      DeviceTypeAndOrientationModel deviceTypeAndOrientation) {
    if (deviceTypeAndOrientation.deviceType == MyDeviceType.phone) return 5.0;
    if (deviceTypeAndOrientation.deviceOrientation ==
        MyDeviceOrientation.portrait) return 4.0;
    return 3.0;
  }

  double _getWildcardKeyWidthRelative(
      DeviceTypeAndOrientationModel deviceTypeAndOrientation) {
    if (deviceTypeAndOrientation.deviceType == MyDeviceType.phone) return 2.5;
    if (deviceTypeAndOrientation.deviceOrientation ==
        MyDeviceOrientation.portrait) return 2.5;
    return 2.0;
  }

  DeviceTypeAndOrientationModel _getDeviceTypeAndOrientation(
    Size screenSize,
    double bottomPadding,
  ) {
    return DeviceTypeAndOrientationModel.fromSize(
      bottomPadding: bottomPadding,
      width: screenSize.width,
      height: screenSize.height,
    );
  }

  Widget buildSearchField(
    SearchBloc searchBloc, {
    ApplicationTheme? theme,
  }) {
    return SearchField(
      lettersActionsItemConfig: lettersActionsItemConfig,
      theme: theme,
    );
  }

  Widget buildSearchOptions(
    SearchBloc searchBloc, {
    bool? collapsable,
    bool? showOptionsPanel,
    double? collapsedHeight,
  }) {
    return SearchOptions(
      collapsable: collapsable,
      searchBloc: searchBloc,
      startsWithActionsItemConfig: startsWithActionsItemConfig,
      endsWithActionsItemConfig: endsWithActionsItemConfig,
      containsActionsItemConfig: containsActionsItemConfig,
      lengthActionsItemConfig: lengthActionsItemConfig,
      showOptionsPanel: showOptionsPanel,
      collapsedHeight: collapsedHeight,
    );
  }

  void _disposeKeyboardConfig() {
    lettersActionsItemConfig.dispose();
    startsWithActionsItemConfig.dispose();
    endsWithActionsItemConfig.dispose();
    containsActionsItemConfig.dispose();
    lengthActionsItemConfig.dispose();
  }

  @override
  void dispose() {
    _disposeKeyboardConfig();
    super.dispose();
  }
}
