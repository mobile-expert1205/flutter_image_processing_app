import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';

import 'converters/dictionary_match_converter.dart';

part 'search_result_model.g.dart';

/// This model represents search results given from API.
@JsonSerializable()
class SearchResultModel {
  /// List of word pages.
  @JsonKey(name: 'word_pages', defaultValue: [])
  final List<WordPageModel> wordPages;

  /// Dictionary matches.
  @JsonKey(name: 'dict_matches')
  @JsonDictionaryMatchConverter()
  final Map<SearchDictionary, bool> dictMatches;

  /// Copy of request to keep request parameters. Used in pagination queries.
  final SearchRequestModel request;

  /// Constructor.
  SearchResultModel({
    required this.request,
    this.wordPages = const [],
    this.dictMatches = const {},
  });

  /// Creates instance from Map values.
  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  /// String representation of instance.
  @override
  String toString() {
    return 'SearchResultModel{wordPages: $wordPages, dictMatches: $dictMatches, request: $request}';
  }
}
