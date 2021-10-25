import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/blocs/error_catcher_mixin.dart';
import 'package:wordfinderx/src/models/dictionary_not_found_model.dart';
import 'package:wordfinderx/src/models/dictionary_word_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';
import 'package:pedantic/pedantic.dart';

part 'dictionary_event.dart';

part 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState>
    with ErrorCatcherMixin {
  /// Instance of repository that provides global business logic of application.
  final Repository _repository;

  DictionaryBloc({
    required String word,
    required Repository repository,
  })   : _repository = repository,
        super(DictionaryState.init(word));

  @override
  Stream<DictionaryState> mapEventToState(DictionaryEvent event) async* {
    if (event is DictionaryFetchDefinitionEvent) {
      yield* _mapDictionaryFetchDefinitionEvent(event);
    }
  }

  Stream<DictionaryState> _mapDictionaryFetchDefinitionEvent(
      DictionaryFetchDefinitionEvent event) async* {
    try {
      final DictionaryWordModel wordModel =
          await _repository.getWordDefinition(state.word);
      if (wordModel.definitions.isNotEmpty) {
        yield state.copyWith(
          stage: DictionaryStage.success,
          dictionaryWordModel: wordModel,
        );
        unawaited(_repository
            .sendViewDictionaryEvent(word: state.word, isPresent: true)
            .catchError(errorCatcher));
      } else {
        yield state.copyWith(stage: DictionaryStage.notFound);
        unawaited(_repository
            .sendViewDictionaryEvent(word: state.word, isPresent: false)
            .catchError(errorCatcher));
      }
    } catch (error) {
      if (error is DictionaryNotFoundModel) {
        yield state.copyWith(stage: DictionaryStage.notFound);
        unawaited(_repository
            .sendViewDictionaryEvent(word: state.word, isPresent: false)
            .catchError(errorCatcher));
      } else {
        yield state.copyWith(stage: DictionaryStage.fail);
        unawaited(_repository
            .sendViewDictionaryEvent(word: state.word, isPresent: false)
            .catchError(errorCatcher));
      }
    }
  }
}
