import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';

/// This class represents a state of search.
class SearchState extends Equatable implements InProgressState {
  /// Search options are visible or not.
  final SearchOptionsVisibility searchOptionsVisibility;

  /// Results of search.
  final SearchResultModel? searchResultModel;

  /// Dictionary to search.
  final SearchDictionary searchDictionary;

  /// Option to group search result.
  final GroupByOption groupByOption;

  /// The main repository instance.
  final Repository repository;

  /// Error message to show for users.
  final SearchErrorMessage errorMessage;

  /// Indicator to show progress indicator.
  @override
  final bool inProgress;

  /// Indicates if there is results or not.
  final ResultPresentState resultPresentState;

  /// Is current dict matches letters.
  final bool isCurrentDictMatches;

  /// Points in current dictionary if current dict matches letters.
  final int pointsInCurrentDict;

  /// The app is running for the first time and need to show
  /// Dictionary selection dialogue.
  final bool showDictionarySelectionDialogue;

  /// User preferences.
  final UserPreferencesModel userPreferencesModel;

  final bool isWordDefinitionShowed;

  final int submitCount;

  final WordPageSortType wordPageSortType;

  bool get isResultPresent =>
      resultPresentState == ResultPresentState.resultPresents;

  final bool isAdvancedOnResultExpanded;

  /// Constructor.
  SearchState(
    this.repository, {
    this.searchOptionsVisibility = SearchOptionsVisibility.none,
    this.searchResultModel,
    this.searchDictionary = SearchDictionary.all_en,
    this.errorMessage = SearchErrorMessage.none,
    this.inProgress = false,
    this.resultPresentState = ResultPresentState.noResult,
    this.isCurrentDictMatches = false,
    this.pointsInCurrentDict = 0,
    this.groupByOption = GroupByOption.wordLength,
    this.showDictionarySelectionDialogue = false,
    UserPreferencesModel? userPreferencesModel,
    this.isWordDefinitionShowed = false,
    this.submitCount = 0,
    this.wordPageSortType = WordPageSortType.points,
    this.isAdvancedOnResultExpanded = false,
  }) : userPreferencesModel = userPreferencesModel ?? UserPreferencesModel();

  /// The list of properties that will be used to determine whether
  /// two [Equatable]s are equal.
  @override
  List<Object?> get props => [
        searchOptionsVisibility,
        searchResultModel,
        searchDictionary,
        errorMessage,
        inProgress,
        resultPresentState,
        isCurrentDictMatches,
        pointsInCurrentDict,
        groupByOption,
        showDictionarySelectionDialogue,
        userPreferencesModel,
        isWordDefinitionShowed,
        submitCount,
        wordPageSortType,
        isAdvancedOnResultExpanded,
      ];

  /// If set to `true`, the [toString] method will be overridden to output
  /// this [Equatable]'s [props].
  @override
  bool get stringify => true;

  /// Makes a copy of current instance with some new values.
  SearchState copyWith({
    SearchOptionsVisibility? searchOptionsVisibility,
    SearchResultModel? searchResultModel,
    SearchDictionary? searchDictionary,
    SearchErrorMessage? errorMessage,
    bool? inProgress,
    ResultPresentState? resultPresentState,
    bool? isCurrentDictMatches,
    int? pointsInCurrentDict,
    GroupByOption? groupByOption,
    bool? showDictionarySelectionDialogue,
    UserPreferencesModel? userPreferencesModel,
    bool? isWordDefinitionShowed,
    bool increaseSubmitCount = false,
    WordPageSortType? wordPageSortType,
    bool? isAdvancedOnResultExpanded,
  }) {
    return SearchState(
      repository,
      searchOptionsVisibility:
          searchOptionsVisibility ?? this.searchOptionsVisibility,
      searchResultModel: searchResultModel ?? this.searchResultModel,
      searchDictionary: searchDictionary ?? this.searchDictionary,
      errorMessage: errorMessage ?? this.errorMessage,
      inProgress: inProgress ?? this.inProgress,
      resultPresentState: resultPresentState ?? this.resultPresentState,
      isCurrentDictMatches: isCurrentDictMatches ?? this.isCurrentDictMatches,
      pointsInCurrentDict: pointsInCurrentDict ?? this.pointsInCurrentDict,
      groupByOption: groupByOption ?? this.groupByOption,
      showDictionarySelectionDialogue: showDictionarySelectionDialogue ??
          this.showDictionarySelectionDialogue,
      userPreferencesModel: userPreferencesModel ?? this.userPreferencesModel,
      isWordDefinitionShowed:
          isWordDefinitionShowed ?? this.isWordDefinitionShowed,
      submitCount: increaseSubmitCount ? submitCount + 1 : submitCount,
      wordPageSortType: wordPageSortType ?? this.wordPageSortType,
      isAdvancedOnResultExpanded:
          isAdvancedOnResultExpanded ?? this.isAdvancedOnResultExpanded,
    );
  }
}

/// Possible error types
enum SearchErrorMessage { none, commonServerError }

/// Possible results presents
enum ResultPresentState { noResult, emptyResult, resultPresents }
