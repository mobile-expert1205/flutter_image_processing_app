import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';

part 'clear_search_event_model.g.dart';

@JsonSerializable()
class ClearSearchEventModel extends BaseEventModel {
  ClearSearchEventModel();

  @override
  String get name => 'clear_search';

  @override
  Map<String, dynamic> get parameters => _$ClearSearchEventModelToJson(this);
}
