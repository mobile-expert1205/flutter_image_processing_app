import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/dictionary/dictionary_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/dictionary_definition_model.dart';
import 'package:wordfinderx/src/widgets/common.dart';
import 'package:wordfinderx/src/widgets/dictionary_word/dictionary_word_definition_tile.dart';

import '../dialog_close_button.dart';

class DictionaryWordPopup extends StatelessWidget {
  static void show(
    BuildContext context,
    String word,
  ) {
    if (word.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context)
          .add(WordDefinitionVisibilitySet(true));
      showDialog(
        context: context,
        useSafeArea: true,
        builder: (ctx) => _buildDialogue(ctx, word),
        barrierDismissible: true,
        barrierColor: AppColors.selectDictionaryOverlayBg,
      ).then((value) => BlocProvider.of<SearchBloc>(context)
          .add(WordDefinitionVisibilitySet(false)));
    }
  }

  static Widget _buildDialogue(BuildContext context, String word) {
    return BlocProvider<DictionaryBloc>(
      create: (_) => DictionaryBloc(
        word: word,
        repository: RepositoryProvider.of(context),
      )..add(DictionaryFetchDefinitionEvent()),
      lazy: false,
      child: DictionaryWordPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      child: BlocBuilder<DictionaryBloc, DictionaryState>(
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, DictionaryState state) {
    Widget body;

    switch (state.stage) {
      case DictionaryStage.inProgress:
        {
          body = _buildProgress();
          break;
        }

      case DictionaryStage.notFound:
        {
          body = _buildNotFound(context, state.word);
          break;
        }

      case DictionaryStage.fail:
        {
          body = _buildFail(context);
          break;
        }

      case DictionaryStage.success:
        {
          body = _buildSuccess(context, state);
          break;
        }
    }
    if (state.stage == DictionaryStage.inProgress) return body;

    return Stack(
      children: [
        body,
        Positioned(
          top: 0,
          right: 0,
          child: DialogCloseButton(),
        )
      ],
    );
  }

  Widget _buildProgress() {
    return SizedBox(
      width: 50.0,
      height: 100.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context, String word) {
    return _wrapInfoMessage(
      Text(
        LocaleKeys.noDefinitionFound.tr() + ' $word',
        textAlign: TextAlign.center,
        style: AppStyles.noWordsFound,
      ),
    );
  }

  Widget _buildFail(BuildContext context) {
    return _wrapInfoMessage(
      Text(
        LocaleKeys.serverError.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.noWordsFound,
      ),
    );
  }

  Widget _wrapInfoMessage(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60.0,
        left: 12.0,
        right: 12.0,
        bottom: 20.0,
      ),
      child: child,
    );
  }

  Widget _buildSuccess(BuildContext context, DictionaryState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWordTitle(context, state.word),
            ..._buildDefinitionList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildWordTitle(BuildContext context, String word) {
    final String title = word.firstCapital + ' ' + LocaleKeys.definition.tr();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 40.0, bottom: 12.0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: AppStyles.wordDefinitionTitle,
      ),
    );
  }

  List<Widget> _buildDefinitionList(DictionaryState state) {
    return state.dictionaryWordModel?.definitions
            .map<Widget>((d) => _buildDefinitionItem(d))
            .toList() ??
        [];
  }

  Widget _buildDefinitionItem(DictionaryDefinitionModel definition) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DictionaryWordDefinitionTile(definition: definition),
    );
  }
}
