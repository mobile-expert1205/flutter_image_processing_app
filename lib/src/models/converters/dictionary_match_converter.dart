import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';

class JsonDictionaryMatchConverter
    implements
        JsonConverter<Map<SearchDictionary, bool>, Map<String, dynamic>> {
  const JsonDictionaryMatchConverter();

  @override
  Map<SearchDictionary, bool> fromJson(Map<String, dynamic> json) {
    final Map<SearchDictionary, bool> result = {};
    try {
      json.forEach((key, value) {
        try {
          final SearchDictionary dictionary = _getDictionary(key);
          result[dictionary] = value as bool;
        } catch (e) {
          // ignored, really.
        }
      });
    } catch (e) {
      // ignored, really.
    }
    return result;
  }

  @override
  Map<String, dynamic> toJson(Map<SearchDictionary, bool> value) {
    return {};
  }

  SearchDictionary _getDictionary(String value) {
    switch (value) {
      case 'otcwl':
        return SearchDictionary.otcwl;
      case 'sowpods':
        return SearchDictionary.sowpods;
      case 'wwf':
        return SearchDictionary.wwf;
      case 'all_en':
        return SearchDictionary.all_en;
    }
    throw 'Unknown dictionary';
  }
}
