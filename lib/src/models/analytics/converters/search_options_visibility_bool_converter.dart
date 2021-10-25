import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';

class SearchOptionsVisibilityConverter
    implements JsonConverter<SearchOptionsVisibility, String> {
  const SearchOptionsVisibilityConverter();

  @override
  SearchOptionsVisibility fromJson(String json) {
    if ('collapsed'.compareTo(json) == 0) {
      return SearchOptionsVisibility.none;
    }
    if ('expanded'.compareTo(json) == 0) {
      return SearchOptionsVisibility.advancedSearch;
    }
    throw 'Error converting string $json to SearchOptionsVisibility';
  }

  @override
  String toJson(SearchOptionsVisibility value) {
    switch (value) {
      case SearchOptionsVisibility.none:
        return 'collapsed';
      case SearchOptionsVisibility.advancedSearch:
        return 'expanded';
    }
  }
}
