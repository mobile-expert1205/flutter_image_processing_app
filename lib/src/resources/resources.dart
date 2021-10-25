import 'package:wordfinderx/src/models/analytics/base_event_model.dart';
import 'package:wordfinderx/src/models/device_info_model.dart';
import 'package:wordfinderx/src/models/dictionary_word_model.dart';
import 'package:wordfinderx/src/models/feedback_meta_info_model.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';

/// Function type that returns width of word that it occupied on the screen.
typedef WordWidthCalculator = double Function(WordModel);

/// Abstract class of main application repository.
abstract class Repository {
  /// Searches words by given request and maximum screen width that is
  /// used to combine words into rows to pre-layout compact results view.
  Future<SearchResultModel> search({
    required SearchRequestModel request,
    required double maxWidth,
    double? maxWidthLandscape,
  });

  /// Searches more words by given request and maximum screen width that is
  /// used to combine words into rows to pre-layout compact results view.
  /// [currentWordList] is used also to prevent skips in array concatenation area.
  Future<SearchResultModel> searchMore({
    required SearchRequestModel request,
    required List<WordModel> currentWordList,
    required double maxWidth,
    double? maxWidthLandscape,
  });

  /// Returns user's preferences.
  Future<UserPreferencesModel> getPreferences();

  /// Returns remote config
  Stream<RemoteConfigModel> get remoteConfig;

  /// Sets user's preferences.
  Future<void> setPreferences(UserPreferencesModel userPreferences);

  /// Opens email dialogue to send feedback email
  void sendFeedbackEmail({required SearchDictionary searchDictionary});

  /// Fetches the word definitions
  Future<DictionaryWordModel> getWordDefinition(String word);

  /// Sends search event.
  Future<void> sendSearchEvent({
    required String letters,
    bool? isAdvancedSearchUsed,
  });

  /// Sends a dictionary event
  Future<void> sendChangeDictionaryEvent({
    required SearchDictionary dictionary,
  });

  /// Sends a clear search event
  Future<void> sendClearSearchEvent();

  /// Sends a view dictionary event
  Future<void> sendViewDictionaryEvent({
    required String word,
    bool? isPresent,
  });

  /// Sends event of changing advanced options visibility to Analytics system.
  /// For example, Google Analytics.
  Future<void> sendToggleAdvancedEvent({
    required SearchOptionsVisibility searchOptionsVisibility,
  });

  Future<DeviceInfoModel> getDeviceInfo();

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class of API search provider.
abstract class SearchProvider {
  /// Does search with given [request] and returns result.
  Future<SearchResultModel> search(SearchRequestModel request);

  void setRemoteConfig(RemoteConfigModel remoteConfig);

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class of user's preferences provider.
abstract class PreferencesProvider {
  /// Returns stored user's preferences.
  Future<UserPreferencesModel> getPreferences();

  /// Sets (saves) user's preferences.
  Future<void> setPreferences(UserPreferencesModel userPreferences);

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class that fetches remote config for A/B testing.
abstract class RemoteConfigProvider {
  /// Returns remote config.
  Stream<RemoteConfigModel> get remoteConfig;

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class that sends events to analytics system.
abstract class AnalyticsProvider {
  /// Sends an event to GA
  Future<void> sendEvent(BaseEventModel event);

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class that provides information about device (deviceType, os, version, etc.)
abstract class DeviceInfoProvider {
  /// Returns information about device (deviceType, os, version, etc.)
  Future<DeviceInfoModel> getDeviceInfo();

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class that send feedback
abstract class FeedbackProvider {
  /// Sends feedback with meta info about device and application settings
  void sendFeedback(FeedbackMetaInfoModel feedbackMetaInfoModel);

  /// Disposes all allocated resources.
  void dispose();
}

/// Abstract class of dictionary provider
abstract class DictionaryProvider {
  /// Fetches the word definitions
  Future<DictionaryWordModel> getWordDefinition(String word);

  /// Disposes all allocated resources.
  void dispose();
}
