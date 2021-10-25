import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';

/// Base class for all word page events.
abstract class WordPageEvent extends Equatable {
  /// Constructor.
  const WordPageEvent();

  /// The list of properies that will be used to determine whether
  /// two [Equatable]s are equal.
  @override
  List<Object?> get props => [];

  /// If set to `true`, the [toString] method will be overridden to output
  /// this [Equatable]'s [props].
  @override
  bool get stringify => true;
}

/// Event when user requested more words.
class ShowMoreRequested extends WordPageEvent {
  /// This is max width of the view to distribute word over lines.
  final double maxWidth;
  final double? maxWidthLandscape;

  /// Constructor.
  const ShowMoreRequested({
    required this.maxWidth,
    this.maxWidthLandscape,
  });

  /// The list of properies that will be used to determine whether
  /// two [Equatable]s are equal.
  @override
  List<Object?> get props => [
        maxWidth,
        maxWidthLandscape,
      ];
}

/// Event when user changes sort order.
class WordPageSortTypeChanged extends WordPageEvent {
  /// This is max width of the view to distribute word over lines.
  final double maxWidth;
  final double? maxWidthLandscape;

  final WordPageSortType wordPageSortType;

  const WordPageSortTypeChanged({
    required this.wordPageSortType,
    required this.maxWidth,
    this.maxWidthLandscape,
  })  : assert(maxWidth > 0);

  @override
  List<Object?> get props => [
        wordPageSortType,
        maxWidthLandscape,
      ];
}
