part of 'input_bloc.dart';

abstract class InputEvent extends Equatable {
  const InputEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class LettersClearRequested extends InputEvent {}

class StartsWithClearRequested extends InputEvent {}

class EndsWithClearRequested extends InputEvent {}

class ContainsClearRequested extends InputEvent {}

class LengthClearRequested extends InputEvent {}

class UnFocusRequested extends InputEvent {}

class LettersChanged extends InputEvent {
  final String value;

  const LettersChanged(this.value);

  @override
  List<Object> get props => [value];
}

class StartWithChanged extends InputEvent {
  final String value;

  const StartWithChanged(this.value);

  @override
  List<Object> get props => [value];
}

class EndWithChanged extends InputEvent {
  final String value;

  const EndWithChanged(this.value);

  @override
  List<Object> get props => [value];
}

class ContainsChanged extends InputEvent {
  final String value;

  const ContainsChanged(this.value);

  @override
  List<Object> get props => [value];
}

class LengthChanged extends InputEvent {
  final String value;

  const LengthChanged(this.value);

  @override
  List<Object> get props => [value];
}

/// Event when search was submitted.
class InputSubmitted extends InputEvent {
  final double maxWidth;
  final double? maxWidthLandscape;

  const InputSubmitted({
    required this.maxWidth,
    this.maxWidthLandscape,
  });

  @override
  List<Object?> get props => [
        maxWidth,
        maxWidthLandscape,
      ];
}
