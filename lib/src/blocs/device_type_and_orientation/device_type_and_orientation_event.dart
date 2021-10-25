import 'package:equatable/equatable.dart';

abstract class DeviceTypeAndOrientationEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DeviceTypeAndOrientationSet extends DeviceTypeAndOrientationEvent {
  final double width;
  final double height;
  final double bottomPadding;
  final double topPadding;

  DeviceTypeAndOrientationSet({
    required this.width,
    required this.height,
    required this.bottomPadding,
    required this.topPadding,
  });

  @override
  List<Object> get props => [
        width,
        height,
        bottomPadding,
        topPadding,
      ];

  @override
  bool get stringify => true;
}
