import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:package_info/package_info.dart';
import 'package:wordfinderx/src/models/device_info_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

class DeviceInfoProviderImpl extends DeviceInfoProvider {
  /// Returns information about device (deviceType, os, version, etc.)
  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    final NetworkType networkType = await _getNetworkType();

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return DeviceInfoModel(
        device: '${androidInfo.manufacturer} ${androidInfo.device}',
        os: 'Android',
        osVersion: androidInfo.version.release,
        networkType: networkType,
        appVersion: packageInfo.version,
        appBuildNumber: packageInfo.buildNumber,
      );
    }
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return DeviceInfoModel(
        device: iosInfo.model,
        networkType: networkType,
        osVersion: iosInfo.systemVersion,
        os: iosInfo.systemName,
        appVersion: packageInfo.version,
        appBuildNumber: packageInfo.buildNumber,
      );
    }
    return Future.error('Unknown platform');
  }

  /// Returns current connected network type
  Future<NetworkType> _getNetworkType() async {
    final ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return NetworkType.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return NetworkType.wifi;
    }
    return NetworkType.unknown;
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {}
}
