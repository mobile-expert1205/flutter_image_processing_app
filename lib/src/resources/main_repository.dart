import 'package:wordfinderx/src/models/analytics/change_dictionary_event_model.dart';
import 'package:wordfinderx/src/models/analytics/clear_search_event_model.dart';
import 'package:wordfinderx/src/models/analytics/search_event_model.dart';
import 'package:wordfinderx/src/models/analytics/toggle_advanced_event_model.dart';
import 'package:wordfinderx/src/models/analytics/view_dictionary_event_model.dart';
import 'package:wordfinderx/src/models/device_info_model.dart';
import 'package:wordfinderx/src/models/dictionary_word_model.dart';
import 'package:wordfinderx/src/models/feedback_meta_info_model.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/models/word_compact_page_model.dart';
import 'package:wordfinderx/src/models/word_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements main repository functionality.
class MainRepository implements Repository {
  /// Static instance to implement singleton.
  static final MainRepository _instance = MainRepository._internal();

  /// Instance of class that implements interaction with search API.
  SearchProvider? _searchProvider;

  /// Instance of class implements get and save locally user's preferences.
  PreferencesProvider? _localPreferencesProvider;

  /// Function to calculate word width that is occupied on the screen.
  WordWidthCalculator? _wordWidthCalculator;

  /// Instance of class that implements interaction with remote config.
  RemoteConfigProvider? _remoteConfigProvider;

  /// Instance of class that implements sending analytics.
  AnalyticsProvider? _analyticsProvider;

  /// Instance of class that provides information about device (deviceType, os, version, etc.)
  DeviceInfoProvider? _deviceInfoProvider;

  /// Instance of class that send feedback
  FeedbackProvider? _feedbackProvider;

  /// Instance of dictionary provider
  DictionaryProvider? _dictionaryProvider;

  /// Private constructor.
  MainRepository._internal();

  /// Factory to provide singleton.
  factory MainRepository({
    SearchProvider? searchProvider,
    WordWidthCalculator? wordWidthCalculator,
    PreferencesProvider? localPreferencesProvider,
    RemoteConfigProvider? remoteConfigProvider,
    AnalyticsProvider? analyticsProvider,
    DeviceInfoProvider? deviceInfoProvider,
    FeedbackProvider? feedbackProvider,
    DictionaryProvider? dictionaryProvider,
  }) {
    if (_instance._remoteConfigProvider == null) {
      assert(remoteConfigProvider != null);
      _instance._remoteConfigProvider = remoteConfigProvider;
    }

    if (_instance._searchProvider == null) {
      assert(searchProvider != null);
      _instance._searchProvider = searchProvider;
      _instance._remoteConfigProvider!.remoteConfig.first
          .then(searchProvider!.setRemoteConfig);
    }
    if (_instance._wordWidthCalculator == null) {
      assert(wordWidthCalculator != null);
      _instance._wordWidthCalculator = wordWidthCalculator;
    }

    if (_instance._localPreferencesProvider == null) {
      assert(localPreferencesProvider != null);
      _instance._localPreferencesProvider = localPreferencesProvider;
    }

    if (_instance._analyticsProvider == null) {
      assert(analyticsProvider != null);
      _instance._analyticsProvider = analyticsProvider;
    }

    if (_instance._deviceInfoProvider == null) {
      assert(deviceInfoProvider != null);
      _instance._deviceInfoProvider = deviceInfoProvider;
    }

    if (_instance._feedbackProvider == null) {
      assert(feedbackProvider != null);
      _instance._feedbackProvider = feedbackProvider;
    }

    if (_instance._dictionaryProvider == null) {
      assert(dictionaryProvider != null);
      _instance._dictionaryProvider = dictionaryProvider;
    }

    return _instance;
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {
    _searchProvider?.dispose();
    _searchProvider = null;
    _localPreferencesProvider?.dispose();
    _localPreferencesProvider = null;
    _remoteConfigProvider?.dispose();
    _remoteConfigProvider = null;
    _analyticsProvider?.dispose();
    _analyticsProvider = null;
    _deviceInfoProvider?.dispose();
    _deviceInfoProvider = null;
    _feedbackProvider?.dispose();
    _feedbackProvider = null;
    _dictionaryProvider?.dispose();
    _dictionaryProvider = null;
  }

  /// Searches words by given request and maximum screen width that is
  /// used to combine words into rows to pre-layout compact results view.
  @override
  Future<SearchResultModel> search({
    required SearchRequestModel request,
    required double maxWidth,
    double? maxWidthLandscape,
  }) async {
    final SearchResultModel searchResultModel =
        await _searchProvider!.search(request);
    return _calculateWordWidth(searchResultModel, maxWidth, maxWidthLandscape);
  }

  /// Returns search result with set words width.
  SearchResultModel _calculateWordWidth(
    SearchResultModel searchResultModel,
    double maxWidth,
    double? maxWidthLandscape,
  ) {
    if (maxWidth > 0) {
      List<WordPageModel> wordPageList = [];

      searchResultModel.wordPages.forEach((WordPageModel orgWordPageModel) {
        WordPageModel wordPageModel = orgWordPageModel.copyWith(
          wordCompactPage: WordCompactPageModel(maxWidth: maxWidth),
          wordCompactPageLandscape:
              WordCompactPageModel(maxWidth: maxWidthLandscape),
        );

        final List<WordModel> wordWithWidthList = [];

        wordPageModel.wordList.forEach((WordModel wordModel) {
          final WordModel modelWithWidth =
              wordModel.copyWith(screenWidth: _wordWidthCalculator!(wordModel));
          wordWithWidthList.add(modelWithWidth);

          wordPageModel.wordCompactPage.addWord(modelWithWidth);
          wordPageModel.wordCompactPageLandscape.addWord(modelWithWidth);
        });
        wordPageModel.wordList.clear();
        wordPageModel.wordList.addAll(wordWithWidthList);

        wordPageList.add(wordPageModel);
      });
      searchResultModel.wordPages.clear();
      searchResultModel.wordPages.addAll(wordPageList);
    }
    return searchResultModel;
  }

  /// Searches more words by given request and maximum screen width that is
  /// used to combine words into rows to pre-layout compact results view.
  /// [currentWordList] is used also to prevent skips in array concatenation area.
  @override
  Future<SearchResultModel> searchMore({
    required SearchRequestModel request,
    required List<WordModel> currentWordList,
    required double maxWidth,
    double? maxWidthLandscape,
  }) async {
    final SearchResultModel searchResultModel =
        await _searchProvider!.search(request);

    assert(searchResultModel.wordPages.length == 1);
    searchResultModel.wordPages[0].wordList.insertAll(0, currentWordList);
    return _calculateWordWidth(searchResultModel, maxWidth, maxWidthLandscape);
  }

  /// Returns user's preferences.
  @override
  Future<UserPreferencesModel> getPreferences() async {
    return await _localPreferencesProvider!.getPreferences();
  }

  /// Returns remote config.
  @override
  Stream<RemoteConfigModel> get remoteConfig =>
      _remoteConfigProvider!.remoteConfig;

  /// Sets user's preferences.
  @override
  Future<void> setPreferences(UserPreferencesModel userPreferences) {
    return _localPreferencesProvider!.setPreferences(userPreferences);
  }

  /// Opens email dialogue to send feedback email
  @override
  void sendFeedbackEmail({required SearchDictionary searchDictionary}) async {
    final DeviceInfoModel deviceInfoModel =
        await _deviceInfoProvider!.getDeviceInfo();
    final FeedbackMetaInfoModel feedbackMetaInfoModel = FeedbackMetaInfoModel(
      deviceInfo: deviceInfoModel,
      searchDictionary: searchDictionary,
    );

    _feedbackProvider!.sendFeedback(feedbackMetaInfoModel);
  }

  @override
  Future<void> sendSearchEvent({
    required String letters,
    bool? isAdvancedSearchUsed,
  }) async {
    final SearchEventModel event = SearchEventModel(
      letter: letters,
      hasAdvanced: isAdvancedSearchUsed,
    );

    return _analyticsProvider!.sendEvent(event);
  }

  @override
  Future<DictionaryWordModel> getWordDefinition(String word) async {
    return _dictionaryProvider!.getWordDefinition(word);
  }

  @override
  Future<void> sendChangeDictionaryEvent(
      {required SearchDictionary dictionary}) async {
    final ChangeDictionaryEventModel event = ChangeDictionaryEventModel(
      dictionary: dictionary,
    );

    return _analyticsProvider!.sendEvent(event);
  }

  @override
  Future<void> sendClearSearchEvent() async {
    final ClearSearchEventModel event = ClearSearchEventModel();

    return _analyticsProvider!.sendEvent(event);
  }

  /// Sends event of changing advanced options visibility to Analytics system.
  /// For example, Google Analytics.
  @override
  Future<void> sendToggleAdvancedEvent({
    required SearchOptionsVisibility searchOptionsVisibility,
  }) async {
    final ToggleAdvancedEventModel event = ToggleAdvancedEventModel(
      searchOptionsVisibility: searchOptionsVisibility,
    );

    return _analyticsProvider!.sendEvent(event);
  }

  @override
  Future<void> sendViewDictionaryEvent({
    required String word,
    bool? isPresent,
  }) async {
    final ViewDictionaryEventModel event = ViewDictionaryEventModel(
      word: word,
      isPresent: isPresent,
    );

    return _analyticsProvider!.sendEvent(event);
  }

  @override
  Future<DeviceInfoModel> getDeviceInfo() {
    return _deviceInfoProvider!.getDeviceInfo();
  }
}
