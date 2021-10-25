import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wordfinderx/src/models/remote_config_model.dart';

import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements interaction with Word Finder API.
class HttpSearchProvider implements SearchProvider {
  /// Static instance to implement singleton.
  static final HttpSearchProvider _instance = HttpSearchProvider._internal();

  /// Private constructor.
  HttpSearchProvider._internal();

  /// Factory to provide singleton.
  factory HttpSearchProvider() => _instance;

  /// Instance of HTTP client to interact with API over HTTP protocol.
  final http.Client _client = http.Client();

  /// Search API endpoint.
  static const _searchEndPoint = '/api/search';

  RemoteConfigModel _remoteConfig = RemoteConfigModel();

  /// Does search request to the API and processed response and handle errors.
  @override
  Future<SearchResultModel> search(SearchRequestModel request) async {
    //return SearchResultModel.fromJson(jsonDecode(json));
    try {
      final Map<String, String> params = request.toParams();
      return await _searchWithHost(host: _remoteConfig.apiHost, params: params)
          .catchError(
        (_) => _searchWithHost(
          host: _remoteConfig.apiFallbackHost,
          params: params,
        ),
      );
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<SearchResultModel> _searchWithHost({
    required String host,
    required Map<String, String> params,
  }) async {
    if (kDebugMode) {
      print('HTTP try to search with host:$host');
    }
    try {
      final Uri uri = Uri.https(host, _searchEndPoint, params);
      final http.Response response = await _client.get(uri);
      if (_isHttpResponseOk(response)) {
        return SearchResultModel.fromJson(jsonDecode(response.body));
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        return Future.error(response.body);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Future.error(error);
    }
  }

  /// Tests if HTTP-response is successful.
  bool _isHttpResponseOk(http.Response response) {
    return response.statusCode == 200;
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {
    _client.close();
  }

  @override
  void setRemoteConfig(RemoteConfigModel remoteConfig) {
    _remoteConfig = remoteConfig;
  }
}

const String json = '''
{
  "request": {
    "letters": "fd??",
    "starts_with": "",
    "ends_with": "",
    "shorter_than": 0,
    "longer_than": 0,
    "length": 0,
    "must_contain": "",
    "must_not_contain": "",
    "must_contain_multiple": "",
    "must_contain_char1": "",
    "must_contain_char2": "",
    "contains": "",
    "not_contains": "",
    "contains_multiple": "",
    "contains_char1": "",
    "contains_char2": "",
    "pattern": "",
    "regexp": "",
    "dictionary": "wwf",
    "return_results": true,
    "pre_defined": false,
    "is_search": false,
    "group_by_length": true,
    "page_size": 20,
    "page_token": 1,
    "sort_alphabet": false,
    "word_sorting": "points",
    "letter_limit": 0
  },
  "letters_for_search": "fd??",
  "search_results": 421,
  "search_duration": 0,
  "filter_results": 359,
  "filter_duration": 0,
  "word_pages": [
    {
      "word_list": [
        {
          "word": "daff",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "daft",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "deaf",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "defi",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "deft",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "defy",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "delf",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "diff",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "difs",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "doff",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "duff",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "fade",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "fado",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "fads",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "fard",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "feds",
          "points": 6,
          "wildcards": [
            1,
            3
          ]
        },
        {
          "word": "feed",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "fend",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "feod",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "feud",
          "points": 6,
          "wildcards": [
            1,
            2
          ]
        }
      ],
      "length": 4,
      "num_words": 33,
      "num_pages": 2,
      "current_page": 1
    },
    {
      "word_list": [
        {
          "word": "def",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "dif",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fad",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fed",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fid",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fud",
          "points": 6,
          "wildcards": [
            1
          ]
        },
        {
          "word": "aff",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "aft",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "arf",
          "points": 4,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "bff",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "eff",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "efs",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "eft",
          "points": 4,
          "wildcards": [
            0,
            2
          ]
        },
        {
          "word": "elf",
          "points": 4,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "emf",
          "points": 4,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "erf",
          "points": 4,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "fab",
          "points": 4,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "fah",
          "points": 4,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "fan",
          "points": 4,
          "wildcards": [
            1,
            2
          ]
        },
        {
          "word": "fap",
          "points": 4,
          "wildcards": [
            1,
            2
          ]
        }
      ],
      "length": 3,
      "num_words": 208,
      "num_pages": 11,
      "current_page": 1
    },
    {
      "word_list": [
        {
          "word": "ef",
          "points": 4,
          "wildcards": [
            0
          ]
        },
        {
          "word": "fa",
          "points": 4,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fe",
          "points": 4,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fi",
          "points": 4,
          "wildcards": [
            1
          ]
        },
        {
          "word": "fu",
          "points": 4,
          "wildcards": [
            1
          ]
        },
        {
          "word": "if",
          "points": 4,
          "wildcards": [
            0
          ]
        },
        {
          "word": "of",
          "points": 4,
          "wildcards": [
            0
          ]
        },
        {
          "word": "ad",
          "points": 2,
          "wildcards": [
            0
          ]
        },
        {
          "word": "da",
          "points": 2,
          "wildcards": [
            1
          ]
        },
        {
          "word": "de",
          "points": 2,
          "wildcards": [
            1
          ]
        },
        {
          "word": "do",
          "points": 2,
          "wildcards": [
            1
          ]
        },
        {
          "word": "ed",
          "points": 2,
          "wildcards": [
            0
          ]
        },
        {
          "word": "id",
          "points": 2,
          "wildcards": [
            0
          ]
        },
        {
          "word": "od",
          "points": 2,
          "wildcards": [
            0
          ]
        },
        {
          "word": "aa",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "ab",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "ae",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "ag",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "ah",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        },
        {
          "word": "ai",
          "points": 0,
          "wildcards": [
            0,
            1
          ]
        }
      ],
      "length": 2,
      "num_words": 118,
      "num_pages": 6,
      "current_page": 1
    }
  ],
  "returned_results": 60,
  "pagination_duration": 0,
  "dict_matches": {
    "otcwl": false,
    "sowpods": false,
    "wwf": false,
    "bla-bla-bla": true
  },
  "has_dict_match": false
}
''';
