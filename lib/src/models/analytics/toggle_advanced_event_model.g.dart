// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_advanced_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToggleAdvancedEventModel _$ToggleAdvancedEventModelFromJson(
    Map<String, dynamic> json) {
  return ToggleAdvancedEventModel(
    searchOptionsVisibility: const SearchOptionsVisibilityConverter()
        .fromJson(json['current_state'] as String),
  );
}

Map<String, dynamic> _$ToggleAdvancedEventModelToJson(
        ToggleAdvancedEventModel instance) =>
    <String, dynamic>{
      'current_state': const SearchOptionsVisibilityConverter()
          .toJson(instance.searchOptionsVisibility),
    };
