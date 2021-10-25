import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';

import 'converters/json_bool_converter.dart';

part 'view_dictionary_event_model.g.dart';

@JsonSerializable()
class ViewDictionaryEventModel extends BaseEventModel {
  final String word;
  @JsonKey(name: 'is_present')
  @JsonBoolConverter()
  final bool isPresent;

  ViewDictionaryEventModel({
    required this.word,
    bool? isPresent,
  }) : isPresent = isPresent ?? false;

  @override
  String get name => 'view_dictionary';

  @override
  Map<String, dynamic> get parameters => _$ViewDictionaryEventModelToJson(this);
}
