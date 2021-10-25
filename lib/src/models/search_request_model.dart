import 'package:json_annotation/json_annotation.dart';

import 'user_preferences_model.dart';

part 'search_request_model.g.dart';

/// Possible types of dictionary to search into.
enum SearchDictionary { otcwl, sowpods, wwf, all_en }

/// Model of search request to send to the API.
@JsonSerializable()
class SearchRequestModel {
  final String letters;
  @JsonKey(name: 'starts_with')
  final String startsWith;
  @JsonKey(name: 'ends_with')
  final String endsWith;
  @JsonKey(name: 'must_contain')
  final String contains;
  @JsonKey(name: 'page_size')
  final int pageSize;
  @JsonKey(name: 'page_token')
  final int pageToken;
  final int length;
  final SearchDictionary dictionary;
  @JsonKey(name: 'word_sorting')
  final WordPageSortType wordPageSortType;
  @JsonKey(name: 'group_by_length')
  final bool groupByLength;

  /// Constructor.
  SearchRequestModel({
    String? letters,
    String? startsWith,
    String? endsWith,
    String? contains,
    this.pageSize = 20,
    this.pageToken = 1,
    this.length = 1,
    this.dictionary = SearchDictionary.all_en,
    this.wordPageSortType = WordPageSortType.points,
    this.groupByLength = true,
  })  : startsWith = startsWith != null ? startsWith.toLowerCase() : '',
        endsWith = endsWith != null ? endsWith.toLowerCase() : '',
        contains = contains != null ? contains.toLowerCase() : '',
        letters = letters != null ? letters.toLowerCase() : '';

  /// Makes a copy of current instance with some new values.
  SearchRequestModel copyWith({
    int? pageToken,
    int? length,
    WordPageSortType? wordPageSortType,
    bool? groupByLength,
  }) {
    return SearchRequestModel(
      letters: letters,
      startsWith: startsWith,
      endsWith: endsWith,
      contains: contains,
      pageSize: pageSize,
      pageToken: pageToken ?? this.pageToken,
      length: length ?? this.length,
      dictionary: dictionary,
      wordPageSortType: wordPageSortType ?? this.wordPageSortType,
      groupByLength: groupByLength ?? this.groupByLength,
    );
  }

  /// Converts instance values to Map.
  Map<String, dynamic> toJson() => _$SearchRequestModelToJson(this)
    ..removeWhere((key, value) => value == null || value == '' || value == 0);

  /// Converts instance values to params Map.
  Map<String, String> toParams() {
    final Map<String, dynamic> optionsMap = toJson();
    return optionsMap
        .map((key, value) => MapEntry<String, String>(key, '$value'));
  }

  /// Creates instance from Map values.
  factory SearchRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SearchRequestModelFromJson(json);

  @override
  String toString() {
    return 'SearchRequestModel{letters: $letters, startsWith: $startsWith, endsWith: $endsWith, contains: $contains, pageSize: $pageSize, pageToken: $pageToken, length: $length, dictionary: $dictionary, wordPageSortType: $wordPageSortType, groupByLength: $groupByLength}';
  }
}
