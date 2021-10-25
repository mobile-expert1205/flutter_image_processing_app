import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/blocs/error_catcher_mixin.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/resources/resources.dart';
import 'package:pedantic/pedantic.dart';

part 'input_event.dart';

part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> with ErrorCatcherMixin {
  final Repository _repository;
  final SearchBloc _searchBloc;

  InputBloc(Repository repository, SearchBloc searchBloc)
      : _repository = repository,
        _searchBloc = searchBloc,
        super(InputState());

  @override
  Stream<InputState> mapEventToState(
    InputEvent event,
  ) async* {
    if (event is LettersClearRequested) {
      yield* _mapLettersClearRequested(event);
    } else if (event is UnFocusRequested) {
      yield* _mapUnFocusRequested(event);
    } else if (event is LettersChanged) {
      yield* _mapLettersChanged(event);
    } else if (event is StartWithChanged) {
      yield* _mapStartWithChanged(event);
    } else if (event is EndWithChanged) {
      yield* _mapEndWithChanged(event);
    } else if (event is ContainsChanged) {
      yield* _mapContainsChanged(event);
    } else if (event is LengthChanged) {
      yield* _mapLengthChanged(event);
    } else if (event is InputSubmitted) {
      yield* _mapInputSearchSubmitted(event);
    } else if (event is StartsWithClearRequested) {
      yield* _mapStartsWithClearRequested(event);
    } else if (event is EndsWithClearRequested) {
      yield* _mapEndsWithClearRequested(event);
    } else if (event is ContainsClearRequested) {
      yield* _mapContainsClearRequested(event);
    } else if (event is LengthClearRequested) {
      yield* _mapLengthClearRequested(event);
    }
  }

  Stream<InputState> _mapLettersClearRequested(
      LettersClearRequested event) async* {
    yield state.copyWith(
      letters: '',
      startsWith: '',
      endsWith: '',
      contains: '',
      length: '',
      cleanSequence: state.cleanSequence + 1,
    );
    unawaited(_repository.sendClearSearchEvent().catchError(errorCatcher));
  }

  Stream<InputState> _mapUnFocusRequested(UnFocusRequested event) async* {
    yield state.copyWith(unFocusSequence: state.unFocusSequence + 1);
  }

  Stream<InputState> _mapLettersChanged(LettersChanged event) async* {
    yield state.copyWith(letters: event.value);
  }

  Stream<InputState> _mapStartWithChanged(StartWithChanged event) async* {
    yield state.copyWith(startsWith: event.value);
  }

  Stream<InputState> _mapEndWithChanged(EndWithChanged event) async* {
    yield state.copyWith(endsWith: event.value);
  }

  Stream<InputState> _mapContainsChanged(ContainsChanged event) async* {
    yield state.copyWith(contains: event.value);
  }

  Stream<InputState> _mapLengthChanged(LengthChanged event) async* {
    yield state.copyWith(length: event.value);
  }

  Stream<InputState> _mapInputSearchSubmitted(InputSubmitted event) async* {
    if (state.isSearchAllowed) {
      add(UnFocusRequested());
      final SearchSubmitted searchSubmitted = SearchSubmitted(
        letters: state.letters,
        startsWith: state.startsWith,
        endsWith: state.endsWith,
        contains: state.contains,
        length: _getLengthValue(state.length),
        filledFilterCount: state.filledFilterCount,
        maxWidth: event.maxWidth,
        maxWidthLandscape: event.maxWidthLandscape,
      );
      _searchBloc.add(searchSubmitted);
    }
  }

  int _getLengthValue(String length) {
    int value = 0;
    if (length.isNotEmpty) {
      try {
        value = int.parse(length);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }
    return value;
  }

  Stream<InputState> _mapStartsWithClearRequested(
      StartsWithClearRequested event) async* {
    yield state.copyWith(startsWith: '');
  }

  Stream<InputState> _mapEndsWithClearRequested(
      EndsWithClearRequested event) async* {
    yield state.copyWith(endsWith: '');
  }

  Stream<InputState> _mapContainsClearRequested(
      ContainsClearRequested event) async* {
    yield state.copyWith(contains: '');
  }

  Stream<InputState> _mapLengthClearRequested(
      LengthClearRequested event) async* {
    yield state.copyWith(length: '');
  }
}
