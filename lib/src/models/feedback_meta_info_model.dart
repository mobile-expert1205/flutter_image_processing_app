import 'package:wordfinderx/src/models/device_info_model.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';

class FeedbackMetaInfoModel {
  final DeviceInfoModel deviceInfo;
  final SearchDictionary searchDictionary;

  FeedbackMetaInfoModel({
    required this.deviceInfo,
    required this.searchDictionary,
  });
}
