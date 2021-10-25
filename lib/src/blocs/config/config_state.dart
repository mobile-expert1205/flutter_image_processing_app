part of 'config_bloc.dart';

class ConfigState extends Equatable {
  final bool isHapticFeedbackEnabled;

  const ConfigState({bool? isHapticFeedbackEnabled})
      : isHapticFeedbackEnabled = isHapticFeedbackEnabled ?? false;

  ConfigState copyWith({bool? isHapticFeedbackEnabled}) => ConfigState(
        isHapticFeedbackEnabled:
            isHapticFeedbackEnabled ?? this.isHapticFeedbackEnabled,
      );

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        isHapticFeedbackEnabled,
      ];
}
