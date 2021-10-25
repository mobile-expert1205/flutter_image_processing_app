// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryWordModel _$DictionaryWordModelFromJson(Map<String, dynamic> json) {
  return DictionaryWordModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    about: json['about'] as String?,
    definitions: (json['definitions'] as List<dynamic>?)
        ?.map((e) =>
            DictionaryDefinitionModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DictionaryWordModelToJson(
        DictionaryWordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'about': instance.about,
      'definitions': instance.definitions.map((e) => e.toJson()).toList(),
    };
