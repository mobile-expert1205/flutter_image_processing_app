// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) {
  return WordModel(
    word: json['word'] as String,
    points: json['points'] as int,
    wildcards:
        (json['wildcards'] as List<dynamic>).map((e) => e as int).toList(),
  );
}

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      'word': instance.word,
      'points': instance.points,
      'wildcards': instance.wildcards,
    };
