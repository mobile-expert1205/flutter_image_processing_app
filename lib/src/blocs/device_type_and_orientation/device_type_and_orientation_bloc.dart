import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';
import 'device_type_and_orientation.dart';

class DeviceTypeAndOrientationBloc
    extends Bloc<DeviceTypeAndOrientationEvent, DeviceTypeAndOrientationState> {
  DeviceTypeAndOrientationBloc()
      : super(DeviceTypeAndOrientationUnknownState());

  @override
  Stream<DeviceTypeAndOrientationState> mapEventToState(
      DeviceTypeAndOrientationEvent event) async* {
    if (event is DeviceTypeAndOrientationSet) {
      yield* _mapDeviceTypeAndOrientationSet(event);
    }
  }

  Stream<DeviceTypeAndOrientationState> _mapDeviceTypeAndOrientationSet(
      DeviceTypeAndOrientationSet event) async* {
    final DeviceTypeAndOrientationModel typeAndOrientation =
        DeviceTypeAndOrientationModel.fromSize(
      height: event.height,
      bottomPadding: event.bottomPadding,
      topPadding: event.topPadding,
      width: event.width,
    );

    final double widthSavePadding = 20.0;

    final double wordPanelWidthCoefPortrait = 0.5;
    final double wordPanelWidthCoefLandscape = 0.7;

    final double wordPanelWidthCoef = typeAndOrientation.isLandscape
        ? wordPanelWidthCoefLandscape
        : wordPanelWidthCoefPortrait;

    final double searchPanelWidthCoef =
        typeAndOrientation.isLandscape ? 0.3 : 0.5;

    double landscapeWidth = 0;
    double portraitWidth = 0;
    double wordPanelWidth = 0;
    double searchPanelWidth = 0;
    double wordPanelLeftPadding = 0;

    if (typeAndOrientation.deviceType == MyDeviceType.phone) {
      portraitWidth = event.width - widthSavePadding;
    } else {
      wordPanelLeftPadding = 16.0;
      wordPanelWidth = event.width * wordPanelWidthCoef;
      searchPanelWidth = event.width * searchPanelWidthCoef;

      portraitWidth =
          (min(event.width, event.height) * wordPanelWidthCoefPortrait -
                  wordPanelLeftPadding) -
              widthSavePadding;

      landscapeWidth =
          (max(event.width, event.height) * wordPanelWidthCoefLandscape -
                  wordPanelLeftPadding) -
              widthSavePadding;
    }

    final DeviceTypeAndOrientationState curState = state;
    if (curState is DeviceTypeAndOrientationKnownState) {
      yield curState.copyWith(
        deviceTypeAndOrientation: typeAndOrientation,
        wordPanelWidth: wordPanelWidth,
        searchPanelWidth: searchPanelWidth,
        landscapeWidth: landscapeWidth,
        portraitWidth: portraitWidth,
        wordPanelLeftPadding: wordPanelLeftPadding,
      );
    } else {
      yield DeviceTypeAndOrientationKnownState(
        deviceTypeAndOrientation: typeAndOrientation,
        wordPanelWidth: wordPanelWidth,
        searchPanelWidth: searchPanelWidth,
        landscapeWidth: landscapeWidth,
        portraitWidth: portraitWidth,
        wordPanelLeftPadding: wordPanelLeftPadding,
      );
    }
  }
}
