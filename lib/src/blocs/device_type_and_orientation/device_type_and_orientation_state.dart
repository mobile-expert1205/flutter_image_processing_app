import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';

abstract class DeviceTypeAndOrientationState extends Equatable {
  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class DeviceTypeAndOrientationKnownState extends DeviceTypeAndOrientationState {
  final DeviceTypeAndOrientationModel deviceTypeAndOrientation;
  final double wordPanelWidth;
  final double wordPanelLeftPadding;
  final double searchPanelWidth;
  final double portraitWidth;
  final double landscapeWidth;

  DeviceTypeAndOrientationKnownState({
    required this.deviceTypeAndOrientation,
    required this.wordPanelWidth,
    required this.searchPanelWidth,
    required this.wordPanelLeftPadding,
    required this.portraitWidth,
    required this.landscapeWidth,
  });

  @override
  List<Object> get props => [
        deviceTypeAndOrientation,
        wordPanelWidth,
        searchPanelWidth,
        wordPanelLeftPadding,
        portraitWidth,
        landscapeWidth,
      ];

  @override
  bool get stringify => true;

  DeviceTypeAndOrientationKnownState copyWith({
    DeviceTypeAndOrientationModel? deviceTypeAndOrientation,
    double? wordPanelWidth,
    double? searchPanelWidth,
    double? wordPanelLeftPadding,
    double? portraitWidth,
    double? landscapeWidth,
  }) {
    return DeviceTypeAndOrientationKnownState(
      deviceTypeAndOrientation:
          deviceTypeAndOrientation ?? this.deviceTypeAndOrientation,
      wordPanelWidth: wordPanelWidth ?? this.wordPanelWidth,
      searchPanelWidth: searchPanelWidth ?? this.searchPanelWidth,
      wordPanelLeftPadding: wordPanelLeftPadding ?? this.wordPanelLeftPadding,
      portraitWidth: portraitWidth ?? this.portraitWidth,
      landscapeWidth: landscapeWidth ?? this.landscapeWidth,
    );
  }
}

class DeviceTypeAndOrientationUnknownState
    extends DeviceTypeAndOrientationState {}
