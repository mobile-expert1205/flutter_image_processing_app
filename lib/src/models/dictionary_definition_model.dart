import 'package:json_annotation/json_annotation.dart';

part 'dictionary_definition_model.g.dart';

@JsonSerializable()
class DictionaryDefinitionModel {
  final int id;
  final String text;
  @JsonKey(name: 'part_of_speech')
  final String partOfSpeech;
  final List<String> synonyms;
  final List<String> examples;

  DictionaryDefinitionModel({
    required int? id,
    String? text,
    String? partOfSpeech,
    List<String>? synonyms,
    List<String>? examples,
  })  : text = text ?? '',
        partOfSpeech = partOfSpeech ?? '',
        id = id ?? 0,
        synonyms = synonyms ?? const [],
        examples = examples ?? const [];

  Map<String, dynamic> toJson() => _$DictionaryDefinitionModelToJson(this);

  factory DictionaryDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$DictionaryDefinitionModelFromJson(json);
}
