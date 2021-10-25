import 'package:flutter/material.dart';

enum DeviceTypeAndOrientation { phone, tabletPortrait, tabletLandscape }

mixin DeviceTypeAndOrientationMixin {
  DeviceTypeAndOrientation getDeviceTypeAndOrientation(Size size) {
    if (size.shortestSide < 600.0) return DeviceTypeAndOrientation.phone;
    if (size.height > size.width) return DeviceTypeAndOrientation.tabletPortrait;
    return DeviceTypeAndOrientation.tabletLandscape;
  }
}
