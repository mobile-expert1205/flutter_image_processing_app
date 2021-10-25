// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferencesModel _$UserPreferencesModelFromJson(Map<String, dynamic> json) {
  return UserPreferencesModel(
    isAdvancedOnResultExpanded: json['isAdvancedOnResultExpanded'] as bool,
    searchDictionary:
        _$enumDecode(_$SearchDictionaryEnumMap, json['searchDictionary']),
    groupByOption: _$enumDecode(_$GroupByOptionEnumMap, json['groupByOption']),
    isDictionarySelectionDialogueShown:
        json['isDictionarySelectionDialogueShown'] as bool,
    wordPageSortType:
        _$enumDecode(_$WordPageSortTypeEnumMap, json['wordPageSortType']),
  );
}

Map<String, dynamic> _$UserPreferencesModelToJson(
        UserPreferencesModel instance) =>
    <String, dynamic>{
      'isAdvancedOnResultExpanded': instance.isAdvancedOnResultExpanded,
      'searchDictionary': _$SearchDictionaryEnumMap[instance.searchDictionary],
      'groupByOption': _$GroupByOptionEnumMap[instance.groupByOption],
      'isDictionarySelectionDialogueShown':
          instance.isDictionarySelectionDialogueShown,
      'wordPageSortType': _$WordPageSortTypeEnumMap[instance.wordPageSortType],
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

const _$GroupByOptionEnumMap = {
  GroupByOption.wordLength: 'wordLength',
  GroupByOption.points: 'points',
};

const _$WordPageSortTypeEnumMap = {
  WordPageSortType.az: 'az',
  WordPageSortType.za: 'za',
  WordPageSortType.points: 'points',
};
