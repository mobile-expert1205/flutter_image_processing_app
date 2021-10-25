import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';

/// This function returns word width that it occupies on the screen.
/// It uses given [wordStyle], [pointStyle] and [paddingValue] to render in
/// memory text and calculate its width.
double calculateWordWidth({
  required WordModel wordModel,
  required TextStyle wordStyle,
  required TextStyle pointStyle,
  double paddingValue = 0,
}) {
  final constraints = BoxConstraints(
    maxWidth: double.infinity,
    minHeight: 0.0,
    minWidth: 0.0,
  );

  final RenderParagraph wordRender = RenderParagraph(
    TextSpan(text: wordModel.word, style: wordStyle),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  final RenderParagraph endPointRender = RenderParagraph(
    TextSpan(text: '${wordModel.points}', style: pointStyle),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  final RenderWrap wrapRender = RenderWrap(
    children: [wordRender, endPointRender],
    textDirection: TextDirection.ltr,
  );

  wrapRender.layout(constraints);

  return wrapRender.paintBounds.width + paddingValue;
}

DeviceTypeAndOrientationKnownState _getDeviceTypeAndOrientationState(
    BuildContext context) {
  return BlocProvider.of<DeviceTypeAndOrientationBloc>(context).state
      as DeviceTypeAndOrientationKnownState;
}

// SearchSubmitted getSearchSubmitEvent(BuildContext context) {
//   try {
//     final DeviceTypeAndOrientationKnownState deviceTypeAndOrientationState =
//         _getDeviceTypeAndOrientationState(context);
//     return SearchSubmitted(
//       maxWidth: deviceTypeAndOrientationState.portraitWidth,
//       maxWidthLandscape: deviceTypeAndOrientationState.landscapeWidth,
//     );
//   } catch (e) {
//     FirebaseCrashlytics.instance.recordError(e, null);
//   }
//   return SearchSubmitted(maxWidth: 0);
// }

ShowMoreRequested getShowMoreRequestedEvent(BuildContext context) {
  try {
    final DeviceTypeAndOrientationKnownState deviceTypeAndOrientationState =
        _getDeviceTypeAndOrientationState(context);
    return ShowMoreRequested(
      maxWidth: deviceTypeAndOrientationState.portraitWidth,
      maxWidthLandscape: deviceTypeAndOrientationState.landscapeWidth,
    );
  } catch (e) {
    FirebaseCrashlytics.instance.recordError(e, null);
  }
  return ShowMoreRequested(maxWidth: 0);
}

WordPageSortTypeChanged getWordPageSortTypeChangedEvent(
  BuildContext context,
  WordPageSortType wordPageSortType,
) {
  try {
    final DeviceTypeAndOrientationKnownState deviceTypeAndOrientationState =
        _getDeviceTypeAndOrientationState(context);
    return WordPageSortTypeChanged(
      maxWidth: deviceTypeAndOrientationState.portraitWidth,
      maxWidthLandscape: deviceTypeAndOrientationState.landscapeWidth,
      wordPageSortType: wordPageSortType,
    );
  } catch (e) {
    FirebaseCrashlytics.instance.recordError(e, null);
  }
  return WordPageSortTypeChanged(
    maxWidth: 0,
    wordPageSortType: wordPageSortType,
  );
}

/// Returns human readable name of the game.
String getDictionaryName(
  SearchDictionary searchDictionary, {
  bool? shortForm,
}) {
  shortForm ??= false;
  switch (searchDictionary) {
    case SearchDictionary.otcwl:
      return shortForm
          ? LocaleKeys.scrabbleUSShort.tr()
          : LocaleKeys.scrabbleUS.tr();
    case SearchDictionary.sowpods:
      return shortForm
          ? LocaleKeys.scrabbleUKShort.tr()
          : LocaleKeys.scrabbleUK.tr();
    case SearchDictionary.wwf:
      return shortForm
          ? LocaleKeys.wordWithFriendsShort.tr()
          : LocaleKeys.wordWithFriends.tr();
    case SearchDictionary.all_en:
      return LocaleKeys.all.tr();
  }
}

/// Displays a text on the Snack Bar at the bottom of the screen.
void showTextOnSnackBar({
  String? text,
  required BuildContext context,
}) {
  if (text != null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: AppStyles.errorMessage,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}

bool isPhone(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide < 600.0;
}

extension FirstCapital on String {
  String get firstCapital =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();
}

enum ApplicationTheme { dark, light }

extension TestTheme on ApplicationTheme {
  bool get isDark => this == ApplicationTheme.dark;

  bool get isLight => this == ApplicationTheme.light;
}

extension SearchSubmit on BuildContext {
  void submitSearch() {
    BlocProvider.of<InputBloc>(this).add(getInputSubmitEvent());
  }

  InputSubmitted getInputSubmitEvent() {
    try {
      final DeviceTypeAndOrientationKnownState deviceTypeAndOrientationState =
          _getDeviceTypeAndOrientationState(this);
      return InputSubmitted(
        maxWidth: deviceTypeAndOrientationState.portraitWidth,
        maxWidthLandscape: deviceTypeAndOrientationState.landscapeWidth,
      );
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
    }
    return InputSubmitted(maxWidth: 0);
  }
}
