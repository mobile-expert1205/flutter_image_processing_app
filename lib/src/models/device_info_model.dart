enum NetworkType { unknown, wifi, mobile }

class DeviceInfoModel {
  final String device;
  final String os;
  final String osVersion;
  final NetworkType networkType;
  final String appVersion;
  final String appBuildNumber;

  DeviceInfoModel({
    this.device = '',
    this.os = '',
    this.osVersion = '',
    this.networkType = NetworkType.unknown,
    this.appVersion = '',
    this.appBuildNumber = '',
  });
}
