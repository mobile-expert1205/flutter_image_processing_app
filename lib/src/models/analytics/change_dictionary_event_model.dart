import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';

import '../search_request_model.dart';

part 'change_dictionary_event_model.g.dart';

@JsonSerializable()
class ChangeDictionaryEventModel extends BaseEventModel {
  @JsonKey(name: 'dict_value')
  final SearchDictionary dictionary;

  ChangeDictionaryEventModel({required this.dictionary});

  @override
  String get name => 'change_dictionary';

  @override
  Map<String, dynamic> get parameters =>
      _$ChangeDictionaryEventModelToJson(this);
}
