// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) {
  return SearchResultModel(
    request:
        SearchRequestModel.fromJson(json['request'] as Map<String, dynamic>),
    wordPages: (json['word_pages'] as List<dynamic>?)
            ?.map((e) => WordPageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    dictMatches: const JsonDictionaryMatchConverter()
        .fromJson(json['dict_matches'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'word_pages': instance.wordPages,
      'dict_matches':
          const JsonDictionaryMatchConverter().toJson(instance.dictMatches),
      'request': instance.request,
    };
