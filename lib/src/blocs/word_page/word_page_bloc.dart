import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements business logic for each word page.
class WordPageBloc extends Bloc<WordPageEvent, WordPageState> {
  /// Instance of repository that provides global business logic of application.
  final Repository _repository;
  final SearchBloc? _searchBloc;
  final PurchaseBloc _purchaseBloc;

  /// Constructor.
  WordPageBloc({
    required SearchRequestModel request,
    required WordPageModel wordPageModel,
    required Repository repository,
    required PurchaseBloc purchaseBloc,
    SearchBloc? searchBloc,
  })  : _repository = repository,
        _searchBloc = searchBloc,
        _purchaseBloc = purchaseBloc,
        super(WordPageState(request: request, wordPageModel: wordPageModel));

  /// Maps events to states.
  @override
  Stream<WordPageState> mapEventToState(WordPageEvent event) async* {
    if (event is ShowMoreRequested) {
      yield* _mapShowMoreRequested(event);
    } else if (event is WordPageSortTypeChanged) {
      yield* _mapWordPageSortTypeChanged(event);
    }
  }

  /// Requests a new words from repository and handles possible error.
  Stream<WordPageState> _mapShowMoreRequested(ShowMoreRequested event) async* {
    if (state.wordPageModel.currentPage < state.wordPageModel.numPages) {
      _purchaseBloc.add(PurchaseGetPurchaseInfoEvent());
      yield state.copyWith(inProgress: true);
      try {
        final SearchRequestModel searchRequest = state.request.copyWith(
          pageToken: state.wordPageModel.currentPage + 1,
          length: state.wordPageModel.length,
        );
        yield* _sendRequest(
          searchRequest: searchRequest,
          maxWidth: event.maxWidth,
          maxWidthLandscape: event.maxWidthLandscape,
          currentWordList: state.wordPageModel.wordList,
        );
      } catch (e, stackTrace) {
        yield* _riseError(WordPageErrorMessage.commonServerError);
        addError(e, stackTrace);
      }
    }
  }

  Stream<WordPageState> _sendRequest({
    required SearchRequestModel searchRequest,
    required double maxWidth,
    required List<WordModel> currentWordList,
    double? maxWidthLandscape,
  }) async* {
    try {
      final SearchResultModel searchResultModel = await _repository.searchMore(
        request: searchRequest,
        maxWidth: maxWidth,
        currentWordList: currentWordList,
        maxWidthLandscape: maxWidthLandscape,
      );

      assert(searchResultModel.wordPages.length == 1);

      yield state.copyWith(
        wordPageModel: searchResultModel.wordPages[0],
        request: searchResultModel.request,
        inProgress: false,
      );
    } catch (e, stackTrace) {
      yield* _riseError(WordPageErrorMessage.commonServerError);
      addError(e, stackTrace);
    }
  }

  /// Creates state with given error message.
  Stream<WordPageState> _riseError(WordPageErrorMessage errorMessage) async* {
    yield state.copyWith(errorMessage: errorMessage, inProgress: false);
    yield state.copyWith(errorMessage: null, inProgress: false);
  }

  Stream<WordPageState> _mapWordPageSortTypeChanged(
      WordPageSortTypeChanged event) async* {
    if (event.wordPageSortType != state.wordPageSortType) {
      yield state.copyWith(inProgress: true);
      try {
        final SearchRequestModel searchRequest = state.request.copyWith(
          pageToken: 0,
          length: state.wordPageModel.length,
          wordPageSortType: event.wordPageSortType,
        );
        yield* _sendRequest(
            searchRequest: searchRequest,
            maxWidth: event.maxWidth,
            maxWidthLandscape: event.maxWidthLandscape,
            currentWordList: []);
      } catch (e, stackTrace) {
        yield* _riseError(WordPageErrorMessage.commonServerError);
        addError(e, stackTrace);
      }
    }

    _searchBloc?.add(
      SearchWordPageSortTypeChanged(wordPageSortType: event.wordPageSortType),
    );
  }
}
