import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements fetching remote config values from Firebase
/// to implement A/B testing.
class FirebaseRemoteConfigProvider implements RemoteConfigProvider {
  /// Static instance to implement singleton.
  static final FirebaseRemoteConfigProvider _instance =
      FirebaseRemoteConfigProvider._internal();

  /// Private constructor.
  FirebaseRemoteConfigProvider._internal() {
    _getRemoteConfig();
  }

  /// Factory to provide singleton.
  factory FirebaseRemoteConfigProvider() => _instance;

  /// Key to get advanced options visibility value.
  static const String isAdvancedOnResultExpandedKey =
      'isAdvancedOnResultExpanded';

  static const String apiHostKey = 'api_url';

  static const String apiFallbackHostKey = 'api_fallback_url';

  static const String isHapticFeedbackEnabledKey = 'isHapticFeedbackEnabled';

  final BehaviorSubject<RemoteConfigModel> _remoteConfig =
      BehaviorSubject<RemoteConfigModel>();

  @override
  Stream<RemoteConfigModel> get remoteConfig => _remoteConfig.stream;

  /// Returns remote config.
  Future<RemoteConfigModel> _getRemoteConfig() async {
    // final RemoteConfigModel remoteConfigModelTmp = RemoteConfigModel(
    //   isAdvancedOnResultExpanded: true,
    // );
    //
    // await Future.delayed(Duration(seconds: 60));
    // print('******************************************* RemoteConfig fetched');
    //
    // return remoteConfigModelTmp;
    RemoteConfigModel remoteConfigModel;

    try {
      final RemoteConfig fbRemoteConfig = RemoteConfig.instance;

      await fbRemoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 30),
        minimumFetchInterval: Duration(hours: 12),
        //minimumFetchInterval: Duration(seconds: 30),
      ));

      final defaults = <String, dynamic>{
        isAdvancedOnResultExpandedKey: false,
        apiHostKey: '',
        apiFallbackHostKey: '',
      };
      await fbRemoteConfig.setDefaults(defaults);

      await fbRemoteConfig.fetchAndActivate();

      remoteConfigModel = RemoteConfigModel(
        isAdvancedOnResultExpanded:
            fbRemoteConfig.getBool(isAdvancedOnResultExpandedKey),
        apiHost: fbRemoteConfig.getString(apiHostKey),
        apiFallbackHost: fbRemoteConfig.getString(apiFallbackHostKey),
        isHapticFeedbackEnabled:
            fbRemoteConfig.getBool(isHapticFeedbackEnabledKey),
      );
    } catch (e) {
      remoteConfigModel = RemoteConfigModel();
    }

    _remoteConfig.add(remoteConfigModel);
    return remoteConfigModel;
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {
    _remoteConfig.close();
  }
}
