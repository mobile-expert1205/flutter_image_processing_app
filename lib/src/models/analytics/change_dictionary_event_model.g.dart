// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_dictionary_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeDictionaryEventModel _$ChangeDictionaryEventModelFromJson(
    Map<String, dynamic> json) {
  return ChangeDictionaryEventModel(
    dictionary: _$enumDecode(_$SearchDictionaryEnumMap, json['dict_value']),
  );
}

Map<String, dynamic> _$ChangeDictionaryEventModelToJson(
        ChangeDictionaryEventModel instance) =>
    <String, dynamic>{
      'dict_value': _$SearchDictionaryEnumMap[instance.dictionary],
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
