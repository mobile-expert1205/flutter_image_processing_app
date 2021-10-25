import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';

/// Base class for search events.
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

/// Event when search was submitted.
class SearchSubmitted extends SearchEvent {
  final double maxWidth;
  final double? maxWidthLandscape;
  final String letters;
  final String startsWith;
  final String endsWith;
  final String contains;
  final int length;
  final int filledFilterCount;

  const SearchSubmitted({
    required this.maxWidth,
    this.maxWidthLandscape,
    required this.letters,
    required this.startsWith,
    required this.endsWith,
    required this.contains,
    required this.length,
    required this.filledFilterCount,
  });

  @override
  List<Object?> get props => [
        maxWidth,
        maxWidthLandscape,
        letters,
        startsWith,
        endsWith,
        contains,
        length,
        filledFilterCount,
      ];
}

/// Event when user changed advanced options visibility.
class SearchOptionsVisibilityChanged extends SearchEvent {
  final SearchOptionsVisibility searchOptionsVisibility;

  const SearchOptionsVisibilityChanged(this.searchOptionsVisibility);

  const SearchOptionsVisibilityChanged.none()
      : searchOptionsVisibility = SearchOptionsVisibility.none;

  const SearchOptionsVisibilityChanged.advancedSearch()
      : searchOptionsVisibility = SearchOptionsVisibility.advancedSearch;

  @override
  List<Object> get props => [searchOptionsVisibility];
}

/// Event when user set dictionary to search.
class SearchDictionarySet extends SearchEvent {
  final SearchDictionary searchDictionary;

  const SearchDictionarySet(this.searchDictionary);

  @override
  List<Object> get props => [searchDictionary];
}

/// Event to fetch user preferences.
class UserPreferencesFetched extends SearchEvent {}

/// Event to send feedback email
class SentFeedbackEmail extends SearchEvent {}

/// Event that selection
class DictionarySelectionDialogueShowed extends SearchEvent {}

/// Event when group by option was changed.
class GroupByOptionChanged extends SearchEvent {
  final GroupByOption groupByOption;

  const GroupByOptionChanged(this.groupByOption);

  const GroupByOptionChanged.wordLength()
      : groupByOption = GroupByOption.wordLength;

  const GroupByOptionChanged.points() : groupByOption = GroupByOption.points;

  @override
  List<Object> get props => [groupByOption];
}

class WordDefinitionVisibilitySet extends SearchEvent {
  final bool isWordDefinitionShowed;

  WordDefinitionVisibilitySet(this.isWordDefinitionShowed);

  @override
  List<Object> get props => [isWordDefinitionShowed];
}

class BackToSearchWithoutResults extends SearchEvent {}

/// Event when user changes sort order.
class SearchWordPageSortTypeChanged extends SearchEvent {
  final WordPageSortType wordPageSortType;

  const SearchWordPageSortTypeChanged({required this.wordPageSortType});

  @override
  List<Object> get props => [
        wordPageSortType,
      ];
}

/// Event to fetch user preferences.
class RemoteConfigFetched extends SearchEvent {
  final RemoteConfigModel remoteConfig;

  RemoteConfigFetched(this.remoteConfig);

  @override
  List<Object?> get props => [remoteConfig];
}
