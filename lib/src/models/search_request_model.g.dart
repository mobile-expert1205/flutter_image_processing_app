// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRequestModel _$SearchRequestModelFromJson(Map<String, dynamic> json) {
  return SearchRequestModel(
    letters: json['letters'] as String?,
    startsWith: json['starts_with'] as String?,
    endsWith: json['ends_with'] as String?,
    contains: json['must_contain'] as String?,
    pageSize: json['page_size'] as int,
    pageToken: json['page_token'] as int,
    length: json['length'] as int,
    dictionary: _$enumDecode(_$SearchDictionaryEnumMap, json['dictionary']),
    wordPageSortType:
        _$enumDecode(_$WordPageSortTypeEnumMap, json['word_sorting']),
    groupByLength: json['group_by_length'] as bool,
  );
}

Map<String, dynamic> _$SearchRequestModelToJson(SearchRequestModel instance) =>
    <String, dynamic>{
      'letters': instance.letters,
      'starts_with': instance.startsWith,
      'ends_with': instance.endsWith,
      'must_contain': instance.contains,
      'page_size': instance.pageSize,
      'page_token': instance.pageToken,
      'length': instance.length,
      'dictionary': _$SearchDictionaryEnumMap[instance.dictionary],
      'word_sorting': _$WordPageSortTypeEnumMap[instance.wordPageSortType],
      'group_by_length': instance.groupByLength,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$SearchDictionaryEnumMap = {
  SearchDictionary.otcwl: 'otcwl',
  SearchDictionary.sowpods: 'sowpods',
  SearchDictionary.wwf: 'wwf',
  SearchDictionary.all_en: 'all_en',
};

const _$WordPageSortTypeEnumMap = {
  WordPageSortType.az: 'az',
  WordPageSortType.za: 'za',
  WordPageSortType.points: 'points',
};
