part of 'device_info_bloc.dart';

abstract class DeviceInfoState extends Equatable {
  const DeviceInfoState();

  @override
  List<Object> get props => [];

  @override
  bool? get stringify => true;
}

class DeviceInfoInitial extends DeviceInfoState {
  const DeviceInfoInitial();
}

class DeviceInfoFetchedSuccessfullyState extends DeviceInfoState {
  final DeviceInfoModel deviceInfoModel;

  DeviceInfoFetchedSuccessfullyState(this.deviceInfoModel);

  @override
  List<Object> get props => [deviceInfoModel];
}

class DeviceInfoFetchFailureState extends DeviceInfoState {
  final Object error;

  const DeviceInfoFetchFailureState(this.error);
}
