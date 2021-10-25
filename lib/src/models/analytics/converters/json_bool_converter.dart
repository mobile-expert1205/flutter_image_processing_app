import 'package:json_annotation/json_annotation.dart';

class JsonBoolConverter implements JsonConverter<bool, int> {
  const JsonBoolConverter();

  @override
  bool fromJson(int json) {
    return json == 1;
  }

  @override
  int toJson(bool value) {
    return value ? 1 : 0;
  }
}
