// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordPageModel _$WordPageModelFromJson(Map<String, dynamic> json) {
  return WordPageModel(
    wordList: (json['word_list'] as List<dynamic>)
        .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    length: json['length'] as int? ?? 0,
    numWords: json['num_words'] as int,
    numPages: json['num_pages'] as int,
    currentPage: json['current_page'] as int,
  );
}

Map<String, dynamic> _$WordPageModelToJson(WordPageModel instance) =>
    <String, dynamic>{
      'word_list': instance.wordList,
      'length': instance.length,
      'num_words': instance.numWords,
      'num_pages': instance.numPages,
      'current_page': instance.currentPage,
    };
