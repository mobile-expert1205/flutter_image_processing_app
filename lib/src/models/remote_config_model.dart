/// Model of remote config.
class RemoteConfigModel {
  /// Indicates to show advanced options or not.
  final bool isAdvancedOnResultExpanded;

  final String apiHost;

  final String apiFallbackHost;

  final bool isHapticFeedbackEnabled;

  /// Constructor.
  RemoteConfigModel({
    bool? isAdvancedOnResultExpanded,
    String? apiHost,
    String? apiFallbackHost,
    bool? isHapticFeedbackEnabled,
  })  : apiHost = apiHost != null && apiHost.isNotEmpty
            ? apiHost
            : 'fly.wordfinderapi.com',
        apiFallbackHost = apiFallbackHost != null && apiFallbackHost.isNotEmpty
            ? apiFallbackHost
            : 'v3.wordfinderapi.com',
        isAdvancedOnResultExpanded = isAdvancedOnResultExpanded ?? false,
        isHapticFeedbackEnabled = isHapticFeedbackEnabled ?? false;
}
