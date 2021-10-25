part of 'device_info_bloc.dart';

abstract class DeviceInfoEvent extends Equatable {
  const DeviceInfoEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class DeviceInfoFetchedSuccessfullyEvent extends DeviceInfoEvent {
  final DeviceInfoModel deviceInfoModel;

  const DeviceInfoFetchedSuccessfullyEvent(this.deviceInfoModel);

  @override
  List<Object?> get props => [deviceInfoModel];
}

class DeviceInfoFetchFailureEvent extends DeviceInfoEvent {
  final Object error;

  const DeviceInfoFetchFailureEvent(this.error);
}
