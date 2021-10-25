// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEventModel _$SearchEventModelFromJson(Map<String, dynamic> json) {
  return SearchEventModel(
    letter: json['letter'] as String,
    hasAdvanced: json['has_advanced'] as bool?,
  );
}

Map<String, dynamic> _$SearchEventModelToJson(SearchEventModel instance) =>
    <String, dynamic>{
      'letter': instance.letter,
      'has_advanced': const JsonBoolConverter().toJson(instance.hasAdvanced),
    };
