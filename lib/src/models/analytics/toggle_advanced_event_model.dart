import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';
import 'package:wordfinderx/src/models/analytics/converters/search_options_visibility_bool_converter.dart';

import '../user_preferences_model.dart';

part 'toggle_advanced_event_model.g.dart';

@JsonSerializable()
class ToggleAdvancedEventModel extends BaseEventModel {
  @JsonKey(name: 'current_state')
  @SearchOptionsVisibilityConverter()
  final SearchOptionsVisibility searchOptionsVisibility;

  ToggleAdvancedEventModel({
    required this.searchOptionsVisibility,
  });

  @override
  String get name => 'toggle_advanced';

  @override
  Map<String, dynamic> get parameters => _$ToggleAdvancedEventModelToJson(this);
}
