// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_definition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryDefinitionModel _$DictionaryDefinitionModelFromJson(
    Map<String, dynamic> json) {
  return DictionaryDefinitionModel(
    id: json['id'] as int?,
    text: json['text'] as String?,
    partOfSpeech: json['part_of_speech'] as String?,
    synonyms:
        (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList(),
    examples:
        (json['examples'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$DictionaryDefinitionModelToJson(
        DictionaryDefinitionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'part_of_speech': instance.partOfSpeech,
      'synonyms': instance.synonyms,
      'examples': instance.examples,
    };
