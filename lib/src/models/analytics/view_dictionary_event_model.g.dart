// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_dictionary_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewDictionaryEventModel _$ViewDictionaryEventModelFromJson(
    Map<String, dynamic> json) {
  return ViewDictionaryEventModel(
    word: json['word'] as String,
    isPresent: json['is_present'] as bool?,
  );
}

Map<String, dynamic> _$ViewDictionaryEventModelToJson(
        ViewDictionaryEventModel instance) =>
    <String, dynamic>{
      'word': instance.word,
      'is_present': const JsonBoolConverter().toJson(instance.isPresent),
    };
