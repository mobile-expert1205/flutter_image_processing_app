import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';

import 'converters/json_bool_converter.dart';

part 'search_event_model.g.dart';

@JsonSerializable()
class SearchEventModel extends BaseEventModel {
  final String letter;
  @JsonKey(name: 'has_advanced')
  @JsonBoolConverter()
  final bool hasAdvanced;

  SearchEventModel({
    required this.letter,
    bool? hasAdvanced,
  }) : hasAdvanced = hasAdvanced ?? false;

  @override
  String get name => 'search';

  @override
  Map<String, dynamic> get parameters => _$SearchEventModelToJson(this);
}
