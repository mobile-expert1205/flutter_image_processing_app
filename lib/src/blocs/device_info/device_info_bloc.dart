import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/device_info_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

part 'device_info_event.dart';

part 'device_info_state.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  final Repository _repository;

  DeviceInfoBloc(Repository repository)
      : _repository = repository,
        super(DeviceInfoInitial()) {
    _fetchDeviceInfo();
  }

  void _fetchDeviceInfo() async {
    try {
      final DeviceInfoModel deviceInfoModel = await _repository.getDeviceInfo();
      add(DeviceInfoFetchedSuccessfullyEvent(deviceInfoModel));
    } catch (e) {
      add(DeviceInfoFetchFailureEvent(e));
    }
  }

  @override
  Stream<DeviceInfoState> mapEventToState(
    DeviceInfoEvent event,
  ) async* {
    if (event is DeviceInfoFetchedSuccessfullyEvent) {
      yield* _mapDeviceInfoFetchedEvent(event);
    } else if (event is DeviceInfoFetchFailureEvent) {
      yield* _mapDeviceInfoFetchFailureEvent(event);
    }
  }

  Stream<DeviceInfoState> _mapDeviceInfoFetchedEvent(
      DeviceInfoFetchedSuccessfullyEvent event) async* {
    yield DeviceInfoFetchedSuccessfullyState(event.deviceInfoModel);
  }

  Stream<DeviceInfoState> _mapDeviceInfoFetchFailureEvent(
      DeviceInfoFetchFailureEvent event) async* {
    yield DeviceInfoFetchFailureState(event.error);
  }
}
