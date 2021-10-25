part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class ConfigRemoteConfigFetchedEvent extends ConfigEvent {
  final bool isHapticFeedbackEnabled;

  ConfigRemoteConfigFetchedEvent({bool? isHapticFeedbackEnabled})
      : isHapticFeedbackEnabled = isHapticFeedbackEnabled ?? false;

  @override
  List<Object?> get props => [
        isHapticFeedbackEnabled,
      ];
}
