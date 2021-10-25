import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Helper class to uniform access to styles constants.
abstract class AppStyles {
  static const TextStyle optionsItem = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 16.0,
  );

  static const TextStyle errorMessage = TextStyle(
    fontFamily: 'lato',
    color: AppColors.darkGreyColor,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  static const TextStyle logoLine1 = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle logoLine1SearchPage = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle noWordsFound = TextStyle(
    fontFamily: 'lato',
    color: AppColors.secondaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
  );

  static const TextStyle noWordsFoundLightTheme = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
  );

  static const TextStyle searchHint = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchHintColor,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle searchText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle dictionarySelectorItem = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle optionsButtonTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle inputField = TextStyle(
    fontFamily: 'lato',
    color: AppColors.filterInput,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle gradientButtonText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle wordBlockWord = TextStyle(
    fontFamily: 'lato',
    color: AppColors.wordBlockWord,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static TextStyle wordBlockWordWildCard =
      wordBlockWord.copyWith(color: AppColors.wildcardColor);

  static const TextStyle wordBlockPoints = TextStyle(
    fontFamily: 'lato',
    color: AppColors.wordBlockPoints,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle shortCutTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle shortCutButtonText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle playableCardText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle keyboardSymbols = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
  );

  static const TextStyle drawerOptionsTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sortOptionsItem = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle filterFormTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sortFormTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle dictionarySelectorDialogueTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle groupByLengthTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle usedFilterCount = TextStyle(
    fontFamily: 'lato',
    color: AppColors.usedFilterCountText,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle filterInputHint = TextStyle(
    fontFamily: 'lato',
    color: AppColors.filterInputHint,
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle dictionarySelectorTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle advancedSearchFormTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.searchOptions,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sortOptionDropDownTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.secondaryColor,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sortOptionDropDownItem = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle wordDefinitionTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.secondaryColor,
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle wordDefinitionPartOfSpeech = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle wordDefinitionDefinitionsTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.secondaryColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle wordDefinitionDefinitionsText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle wordDefinitionSynonymsTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle wordDefinitionSynonymsText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle wordDefinitionExamplesTitle = TextStyle(
    fontFamily: 'lato',
    color: AppColors.secondaryColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle wordDefinitionExamplesText = TextStyle(
    fontFamily: 'lato',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle toolTipNormalText = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle toolTipHighlightedText = TextStyle(
    fontFamily: 'lato',
    color: AppColors.primaryColor,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle drawerAppVersion = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle purchasePriceText = TextStyle(
    fontFamily: 'roboto',
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle purchasePricePerMonthText = TextStyle(
    fontFamily: 'roboto',
    color: AppColors.darkGreyColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle purchasePeriod = TextStyle(
    fontFamily: 'lato',
    color: AppColors.darkGreyColor,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle purchaseScreenTitle = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle purchaseDiscount = TextStyle(
    fontFamily: 'lato',
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );
}
