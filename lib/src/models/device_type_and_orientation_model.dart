enum MyDeviceType { phone, tablet }

enum MyDeviceOrientation { portrait, landscape }

class DeviceTypeAndOrientationModel {
  final MyDeviceType deviceType;
  final MyDeviceOrientation deviceOrientation;
  final double width;
  final double height;
  final double bottomPadding;
  final double topPadding;

  bool get isPortrait => deviceOrientation == MyDeviceOrientation.portrait;

  bool get isLandscape => deviceOrientation == MyDeviceOrientation.landscape;

  bool get isPhone => deviceType == MyDeviceType.phone;

  bool get isTablet => deviceType == MyDeviceType.tablet;

  bool get isTopNotch => topPadding > 0 && bottomPadding > 0;

  DeviceTypeAndOrientationModel({
    MyDeviceType? deviceType,
    MyDeviceOrientation? deviceOrientation,
    double? width,
    double? height,
    double? bottomPadding,
    double? topPadding,
  })  : deviceOrientation =
            deviceOrientation ?? MyDeviceOrientation.portrait,
        deviceType = deviceType ?? MyDeviceType.phone,
        width = width ?? 0,
        height = height ?? 0,
        bottomPadding = bottomPadding ?? 0,
        topPadding = topPadding ?? 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceTypeAndOrientationModel &&
          runtimeType == other.runtimeType &&
          deviceType == other.deviceType &&
          deviceOrientation == other.deviceOrientation &&
          width == other.width &&
          height == other.height &&
          bottomPadding == other.bottomPadding &&
          topPadding == other.topPadding;

  @override
  int get hashCode =>
      deviceType.hashCode ^
      deviceOrientation.hashCode ^
      width.hashCode ^
      height.hashCode ^
      bottomPadding.hashCode ^
      topPadding.hashCode;

  DeviceTypeAndOrientationModel copyWith({
    MyDeviceType? deviceType,
    MyDeviceOrientation? deviceOrientation,
    double? width,
    double? height,
    double? bottomPadding,
    double? topPadding,
  }) {
    return DeviceTypeAndOrientationModel(
      deviceOrientation: deviceOrientation ?? this.deviceOrientation,
      deviceType: deviceType ?? this.deviceType,
      width: width ?? this.width,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      topPadding: topPadding ?? this.topPadding,
      height: height ?? this.height,
    );
  }

  factory DeviceTypeAndOrientationModel.fromSize({
    required double width,
    required double height,
    double bottomPadding = 0,
    double topPadding = 0,
  }) {
    MyDeviceOrientation deviceOrientation;
    MyDeviceType deviceType;

    if (width < 600.0) {
      deviceOrientation = MyDeviceOrientation.portrait;
      deviceType = MyDeviceType.phone;
    } else if (height > width) {
      deviceOrientation = MyDeviceOrientation.portrait;
      deviceType = MyDeviceType.tablet;
    } else {
      deviceOrientation = MyDeviceOrientation.landscape;
      deviceType = MyDeviceType.tablet;
    }

    return DeviceTypeAndOrientationModel(
      deviceOrientation: deviceOrientation,
      deviceType: deviceType,
      width: width,
      height: height,
      bottomPadding: bottomPadding,
      topPadding: topPadding,
    );
  }

  @override
  String toString() {
    return 'DeviceTypeAndOrientationModel{deviceType: $deviceType, deviceOrientation: $deviceOrientation, width: $width, height: $height, bottomPadding: $bottomPadding}';
  }
}
