import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wordfinderx/src/models/dictionary_not_found_model.dart';

import 'package:wordfinderx/src/models/dictionary_word_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

class HttpDictionaryProvider implements DictionaryProvider {
  static final HttpDictionaryProvider _instance =
      HttpDictionaryProvider._internal();

  HttpDictionaryProvider._internal();

  factory HttpDictionaryProvider() => _instance;

  /// Instance of HTTP client to interact with API over HTTP protocol.
  final http.Client _client = http.Client();

  /// Hostname to send request.
  static const _host = 'dict-api.com';

  /// Dictionary API endpoint.
  static const _dictEndPoint = '/api/words';

  @override
  Future<DictionaryWordModel> getWordDefinition(String word) async {
    try {
      assert(word.isNotEmpty);

      final Uri uri = Uri.https(_host, _dictEndPoint + '/$word');
      final http.Response response = await _client.get(uri);
      if (_isHttpResponseOk(response)) {
        return DictionaryWordModel.fromJson(jsonDecode(response.body));
      } else {
        return _getError(response);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  /// Tests if HTTP-response is successful.
  bool _isHttpResponseOk(http.Response response) {
    return response.statusCode == 200;
  }

  Future<DictionaryWordModel> _getError(http.Response response) {
    if (response.statusCode == 404) {
      return Future.error(DictionaryNotFoundModel());
    }
    return Future.error(response.body);
  }

  @override
  void dispose() {
    _client.close();
  }
}
