import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/dictionary_definition_model.dart';

part 'dictionary_word_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DictionaryWordModel {
  final int id;
  final String name;
  final String about;
  final List<DictionaryDefinitionModel> definitions;

  DictionaryWordModel({
    int? id,
    String? name,
    String? about,
    List<DictionaryDefinitionModel>? definitions,
  })  : name = name ?? '',
        id = id ?? 0,
        about = about ?? '',
        definitions = definitions ?? const [];

  Map<String, dynamic> toJson() => _$DictionaryWordModelToJson(this);

  factory DictionaryWordModel.fromJson(Map<String, dynamic> json) =>
      _$DictionaryWordModelFromJson(json);
}
