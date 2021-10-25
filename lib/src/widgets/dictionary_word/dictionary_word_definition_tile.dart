import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/dictionary_definition_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';

class DictionaryWordDefinitionTile extends StatelessWidget {
  static const double _verticalSpace = 10.0;

  final DictionaryDefinitionModel definition;

  const DictionaryWordDefinitionTile({
    Key? key,
    required this.definition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryColor,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPartOfSpeech(),
          ..._buildDefinition(),
          if (definition.synonyms.isNotEmpty) ..._buildSynonyms(),
          if (definition.examples.isNotEmpty) ..._buildExamples(),
        ],
      ),
    );
  }

  Widget _buildPartOfSpeech() {
    if (definition.partOfSpeech.isNotEmpty) {
      return Text(
        '(${definition.partOfSpeech})',
        textAlign: TextAlign.start,
        style: AppStyles.wordDefinitionPartOfSpeech,
      );
    }
    return Container();
  }

  List<Widget> _buildDefinition() {
    return <Widget>[
      const SizedBox(height: _verticalSpace),
      Container(
        padding: const EdgeInsets.all(4.0),
        color: AppColors.backgroundColor,
        child: Text(
          LocaleKeys.definitions.tr(),
          style: AppStyles.wordDefinitionDefinitionsTitle,
        ),
      ),
      const SizedBox(height: _verticalSpace),
      Text(
        '${definition.text}',
        textAlign: TextAlign.start,
        style: AppStyles.wordDefinitionDefinitionsText,
      ),
    ];
  }

  List<Widget> _buildSynonyms() {
    List<Widget> items =
        definition.synonyms.map<Widget>(_buildSynonymItem).toList();

    return <Widget>[
      const SizedBox(height: _verticalSpace),
      Divider(color: AppColors.greyColor, height: 1.0),
      const SizedBox(height: _verticalSpace),
      Container(
        padding: const EdgeInsets.all(4.0),
        color: AppColors.primaryColor,
        child: Text(
          LocaleKeys.synonyms.tr(),
          style: AppStyles.wordDefinitionSynonymsTitle,
        ),
      ),
      const SizedBox(height: _verticalSpace),
      Wrap(children: items),
    ];
  }

  Widget _buildSynonymItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Text(text, style: AppStyles.wordDefinitionSynonymsText),
      ),
    );
  }

  List<Widget> _buildExamples() {
    List<Widget> items =
        definition.examples.map<Widget>(_buildExampleItem).toList();

    return <Widget>[
      const SizedBox(height: _verticalSpace),
      Divider(color: AppColors.greyColor, height: 1.0),
      const SizedBox(height: _verticalSpace),
      Container(
        padding: const EdgeInsets.all(4.0),
        color: AppColors.exampleTitleBgColor,
        child: Text(
          LocaleKeys.examples.tr(),
          style: AppStyles.wordDefinitionExamplesTitle,
        ),
      ),
      const SizedBox(height: _verticalSpace),
      ...items,
    ];
  }

  Widget _buildExampleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text, style: AppStyles.wordDefinitionExamplesText),
    );
  }
}
