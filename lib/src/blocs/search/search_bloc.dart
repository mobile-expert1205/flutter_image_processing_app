import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/app_router_bloc.dart';
import 'package:wordfinderx/src/blocs/error_catcher_mixin.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/screens/search_screen.dart';
import 'package:pedantic/pedantic.dart';

typedef StringValueGetter = String Function(SearchState);
typedef PositionGetter = int Function(SearchState);
typedef StateGetter = SearchState Function(String, int);

/// This class implements word search business logic.
class SearchBloc extends Bloc<SearchEvent, SearchState> with ErrorCatcherMixin {
  /// Instance of AppRouterBloc that provides navigation through application.
  final AppRouterBloc _appRouterBloc;
  final PurchaseBloc _purchaseBloc;

  /// Constructor
  SearchBloc({
    required Repository repository,
    required AppRouterBloc appRouterBloc,
    required PurchaseBloc purchaseBloc,
  })  : _appRouterBloc = appRouterBloc,
        _purchaseBloc = purchaseBloc,
        super(SearchState(repository));

  /// Maps events to states.
  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchSubmitted) {
      yield* _mapSearchSubmitted(event);
    } else if (event is SearchOptionsVisibilityChanged) {
      yield* _mapSearchOptionsVisibilityChanged(event);
    } else if (event is SearchDictionarySet) {
      yield* _mapSearchDictionarySet(event);
    } else if (event is UserPreferencesFetched) {
      yield* _mapUserPreferencesFetched(event);
    } else if (event is SentFeedbackEmail) {
      yield* _mapSentFeedbackEmail(event);
    } else if (event is GroupByOptionChanged) {
      yield* _mapGroupByOptionChanged(event);
    } else if (event is DictionarySelectionDialogueShowed) {
      yield* _mapDictionarySelectionDialogueShowed(event);
    } else if (event is WordDefinitionVisibilitySet) {
      yield* _mapWordDefinitionVisibilitySet(event);
    } else if (event is BackToSearchWithoutResults) {
      yield* _mapBackToSearchWithoutResults(event);
    } else if (event is SearchWordPageSortTypeChanged) {
      yield* _mapWordPageSortTypeChanged(event);
    } else if (event is RemoteConfigFetched) {
      yield* _mapRemoteConfigFetched(event);
    }
  }

  /// Returns new state after user submit a search.
  Stream<SearchState> _mapSearchSubmitted(SearchSubmitted event) async* {
    //if (!state.isSearchAllowed) return;
    _purchaseBloc.add(PurchaseGetPurchaseInfoEvent());
    yield state.copyWith(
      inProgress: true,
      increaseSubmitCount: true,
    );
    final SearchRequestModel searchRequest = SearchRequestModel(
      letters: event.letters,
      startsWith: event.startsWith,
      endsWith: event.endsWith,
      contains: event.contains,
      dictionary: state.searchDictionary,
      length: event.length,
      groupByLength: state.groupByOption == GroupByOption.wordLength,
      wordPageSortType: state.wordPageSortType,
    );
    try {
      final SearchResultModel searchResultModel = await state.repository.search(
        request: searchRequest,
        maxWidth: event.maxWidth,
        maxWidthLandscape: event.maxWidthLandscape,
      );

      bool isCurrentDictMatches = _testIsCurrentDictMatches(
        state.searchDictionary,
        searchResultModel,
      );

      final int pointsInCurrentDict = isCurrentDictMatches
          ? _getPointsOfCurrentLetters(event.letters, searchResultModel)
          : -1;

      yield state.copyWith(
        searchResultModel: searchResultModel,
        inProgress: false,
        resultPresentState: _testIsResultPresent(searchResultModel),
        isCurrentDictMatches:
            pointsInCurrentDict != -1 ? isCurrentDictMatches : false,
        pointsInCurrentDict: pointsInCurrentDict,
        searchOptionsVisibility: state.isAdvancedOnResultExpanded
            ? SearchOptionsVisibility.advancedSearch
            : SearchOptionsVisibility.none,
        increaseSubmitCount: true,
      );
      _sendSearchEvent(event.letters, event.filledFilterCount > 0);
    } catch (error, stackTrace) {
      yield* _riseError(SearchErrorMessage.commonServerError);
      addError(error, stackTrace);
    }
  }

  void _sendSearchEvent(String letters, bool isAdvancedSearchUsed) async {
    try {
      await state.repository.sendSearchEvent(
        letters: letters,
        isAdvancedSearchUsed: isAdvancedSearchUsed,
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  ResultPresentState _testIsResultPresent(SearchResultModel searchResultModel) {
    return searchResultModel.wordPages.isEmpty
        ? ResultPresentState.emptyResult
        : ResultPresentState.resultPresents;
  }

  bool _testIsCurrentDictMatches(
    SearchDictionary searchDictionary,
    SearchResultModel searchResultModel,
  ) =>
      searchResultModel.dictMatches[searchDictionary] ?? false;

  int _getPointsOfCurrentLetters(
    String letters,
    SearchResultModel searchResultModel,
  ) {
    try {
      final int len = letters.length;
      final WordPageModel page = searchResultModel.wordPages
          .firstWhere((WordPageModel page) => page.length == len);
      WordModel word = page.wordList.firstWhere(
          (WordModel word) => word.word.toLowerCase() == letters.toLowerCase());
      return word.points;
    } catch (error) {
      //addError(error, stackTrace);
      return -1;
    }
  }

  /// Creates state with given error message.
  Stream<SearchState> _riseError(SearchErrorMessage errorMessage) async* {
    yield state.copyWith(errorMessage: errorMessage, inProgress: false);
    yield state.copyWith(errorMessage: null, inProgress: false);
  }

  /// Returns new state after user changed visibility of advanced options.
  Stream<SearchState> _mapSearchOptionsVisibilityChanged(
      SearchOptionsVisibilityChanged event) async* {
    yield state.copyWith(
      searchOptionsVisibility: event.searchOptionsVisibility,
    );

    unawaited(state.repository
        .sendToggleAdvancedEvent(
            searchOptionsVisibility: event.searchOptionsVisibility)
        .catchError(errorCatcher));
  }

  /// Returns new state after user's preferences were fetched.
  Stream<SearchState> _mapUserPreferencesFetched(
      UserPreferencesFetched event) async* {
    UserPreferencesModel userPreferences;
    try {
      userPreferences = await state.repository.getPreferences();
    } catch (error) {
      userPreferences = UserPreferencesModel();
      //addError(error, stackTrace);
    }
    yield state.copyWith(
      userPreferencesModel: userPreferences,
      searchDictionary: userPreferences.searchDictionary,
      isAdvancedOnResultExpanded: userPreferences.isAdvancedOnResultExpanded,
      searchOptionsVisibility: userPreferences.isAdvancedOnResultExpanded
          ? SearchOptionsVisibility.advancedSearch
          : SearchOptionsVisibility.none,
      groupByOption: userPreferences.groupByOption,
      showDictionarySelectionDialogue:
          !userPreferences.isDictionarySelectionDialogueShown,
      wordPageSortType: userPreferences.wordPageSortType,
    );

    _appRouterBloc.pushReplacement(SearchScreen.pageName);

    unawaited(_fetchRemoteConfig());
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      final RemoteConfigModel remoteConfigModel =
          await state.repository.remoteConfig.first;
      add(RemoteConfigFetched(remoteConfigModel));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Stream<SearchState> _mapRemoteConfigFetched(
      RemoteConfigFetched event) async* {
    if (state.submitCount == 0) {
      yield state.copyWith(
        userPreferencesModel: state.userPreferencesModel.copyWith(
          isAdvancedOnResultExpanded:
              event.remoteConfig.isAdvancedOnResultExpanded,
        ),
        isAdvancedOnResultExpanded:
            event.remoteConfig.isAdvancedOnResultExpanded,
      );
    } else {
      addError('Remote config was fetched too late');
    }
  }

  /// Saves user's preferences locally.
  Stream<SearchState> _saveUserPreferences({
    SearchDictionary? searchDictionary,
    bool? isDictionarySelectionDialogueShown,
    GroupByOption? groupByOption,
    WordPageSortType? wordPageSortType,
  }) async* {
    final UserPreferencesModel userPreferences =
        state.userPreferencesModel.copyWith(
      searchDictionary: searchDictionary,
      isDictionarySelectionDialogueShown: isDictionarySelectionDialogueShown,
      groupByOption: groupByOption,
      wordPageSortType: wordPageSortType,
    );

    unawaited(state.repository
        .setPreferences(userPreferences)
        .catchError(errorCatcher));

    yield state.copyWith(userPreferencesModel: userPreferences);
  }

  /// Returns new state after user's changed a dictionary to search into.
  Stream<SearchState> _mapSearchDictionarySet(
      SearchDictionarySet event) async* {
    yield state.copyWith(searchDictionary: event.searchDictionary);
    yield* _saveUserPreferences(searchDictionary: event.searchDictionary);
    unawaited(state.repository
        .sendChangeDictionaryEvent(dictionary: event.searchDictionary)
        .catchError(errorCatcher));
  }

  Stream<SearchState> _mapSentFeedbackEmail(SentFeedbackEmail event) async* {
    state.repository
        .sendFeedbackEmail(searchDictionary: state.searchDictionary);
  }

  Stream<SearchState> _mapGroupByOptionChanged(
      GroupByOptionChanged event) async* {
    yield state.copyWith(groupByOption: event.groupByOption);
    yield* _saveUserPreferences(groupByOption: event.groupByOption);
  }

  Stream<SearchState> _mapDictionarySelectionDialogueShowed(
      DictionarySelectionDialogueShowed event) async* {
    yield state.copyWith(showDictionarySelectionDialogue: false);
    yield* _saveUserPreferences(isDictionarySelectionDialogueShown: true);
  }

  Stream<SearchState> _mapWordDefinitionVisibilitySet(
      WordDefinitionVisibilitySet event) async* {
    yield state.copyWith(isWordDefinitionShowed: event.isWordDefinitionShowed);
  }

  Stream<SearchState> _mapBackToSearchWithoutResults(
      BackToSearchWithoutResults event) async* {
    yield state.copyWith(resultPresentState: ResultPresentState.noResult);
  }

  Stream<SearchState> _mapWordPageSortTypeChanged(
      SearchWordPageSortTypeChanged event) async* {
    yield state.copyWith(wordPageSortType: event.wordPageSortType);
    yield* _saveUserPreferences(wordPageSortType: event.wordPageSortType);
  }
}
