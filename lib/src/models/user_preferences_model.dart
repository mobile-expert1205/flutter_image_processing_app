import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';

part 'user_preferences_model.g.dart';

/// Possible search options visibility.
enum SearchOptionsVisibility { none, advancedSearch }

/// Possible sort options.
enum GroupByOption { wordLength, points }

enum WordPageSortType { az, za, points }

/// Class contains information about user preferences across whole app.
@JsonSerializable()
class UserPreferencesModel {
  final bool isAdvancedOnResultExpanded;

  /// Selected dictionary to search.
  final SearchDictionary searchDictionary;

  /// Selected sort type for search.
  final GroupByOption groupByOption;

  /// The app has never shown the Dictionary selection dialogue.
  final bool isDictionarySelectionDialogueShown;

  final WordPageSortType wordPageSortType;

  /// Constructor.
  UserPreferencesModel({
    this.isAdvancedOnResultExpanded = false,
    this.searchDictionary = SearchDictionary.all_en,
    this.groupByOption = GroupByOption.wordLength,
    this.isDictionarySelectionDialogueShown = false,
    this.wordPageSortType = WordPageSortType.points,
  });

  /// Makes a copy of current instance with some new values.
  UserPreferencesModel copyWith({
    bool? isAdvancedOnResultExpanded,
    SearchDictionary? searchDictionary,
    GroupByOption? groupByOption,
    bool? isDictionarySelectionDialogueShown,
    WordPageSortType? wordPageSortType,
  }) {
    return UserPreferencesModel(
      isAdvancedOnResultExpanded:
          isAdvancedOnResultExpanded ?? this.isAdvancedOnResultExpanded,
      searchDictionary: searchDictionary ?? this.searchDictionary,
      groupByOption: groupByOption ?? this.groupByOption,
      isDictionarySelectionDialogueShown: isDictionarySelectionDialogueShown ??
          this.isDictionarySelectionDialogueShown,
      wordPageSortType: wordPageSortType ?? this.wordPageSortType,
    );
  }

  /// Converts instance values to Map.
  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);

  /// Creates instance from Map values.
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);

  /// String representation of instance.
  @override
  String toString() {
    return 'UserPreferencesModel{isAdvancedOnResultExpanded: $isAdvancedOnResultExpanded, searchDictionary: $searchDictionary, groupByOption: $groupByOption, isDictionarySelectionDialogueShown: $isDictionarySelectionDialogueShown, wordPageSortType: $wordPageSortType}';
  }
}
