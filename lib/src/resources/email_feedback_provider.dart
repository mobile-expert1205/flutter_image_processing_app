import 'package:url_launcher/url_launcher.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/models/device_info_model.dart';

import 'package:wordfinderx/src/models/feedback_meta_info_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';
import 'package:easy_localization/easy_localization.dart';

/// Provider to send feedback through email.
class EmailFeedbackProvider implements FeedbackProvider {
  static const String _scheme = 'mailto';
  static const String _path = 'support@word.tips';
  static const String _subjectParam = 'subject';
  static const String _bodyParam = 'body';

  /// Sends feedback with meta info about device and application settings
  @override
  void sendFeedback(FeedbackMetaInfoModel feedbackMetaInfoModel) async {
    final String url = _scheme +
        ':$_path' +
        '?$_subjectParam=' +
        LocaleKeys.feedbackSubject.tr() +
        '&$_bodyParam=' +
        _getEmailBody(feedbackMetaInfoModel);

    await launch(Uri.encodeFull(url));
  }

  /// Returns email body pre-filled with device and application info
  String _getEmailBody(FeedbackMetaInfoModel feedbackMetaInfoModel) {
    return '\n\n---------\n' +
        LocaleKeys.device.tr() +
        ': ${feedbackMetaInfoModel.deviceInfo.device}\n' +
        LocaleKeys.os.tr() +
        ': ${feedbackMetaInfoModel.deviceInfo.os}\n' +
        LocaleKeys.osVersion.tr() +
        ': ${feedbackMetaInfoModel.deviceInfo.osVersion}\n' +
        LocaleKeys.network.tr() +
        ': ${_getNetwork(feedbackMetaInfoModel)}\n' +
        LocaleKeys.dictionary.tr() +
        ': ${_getDictionary(feedbackMetaInfoModel)}\n' +
        LocaleKeys.appVersion.tr() +
        ': ${_getApplicationVersion(feedbackMetaInfoModel)}\n';
  }

  /// Returns network type connection (Wi-Fi/ Mobile)
  String _getNetwork(FeedbackMetaInfoModel feedbackMetaInfoModel) {
    switch (feedbackMetaInfoModel.deviceInfo.networkType) {
      case NetworkType.mobile:
        return LocaleKeys.mobile.tr();
      case NetworkType.wifi:
        return LocaleKeys.wifi.tr();
      case NetworkType.unknown:
        return LocaleKeys.unknown.tr();
    }
  }

  /// Returns a dictionary to search
  String _getDictionary(FeedbackMetaInfoModel feedbackMetaInfoModel) {
    return feedbackMetaInfoModel.searchDictionary
        .toString()
        .replaceFirst('SearchDictionary.', '');
  }

  /// Returns a dictionary to search
  String _getApplicationVersion(FeedbackMetaInfoModel feedbackMetaInfoModel) {
    return '${feedbackMetaInfoModel.deviceInfo.appVersion} '
        '(${feedbackMetaInfoModel.deviceInfo.appBuildNumber})';
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {}
}
