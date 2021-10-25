import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/models/user_preferences_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';

/// This class represents a state of word page.
class WordPageState extends Equatable implements InProgressState {
  /// Word page model to show on UI.
  final WordPageModel wordPageModel;

  /// Search request to obtain parameters for nex page request.
  final SearchRequestModel request;

  /// Error message to show user.
  final WordPageErrorMessage errorMessage;

  /// Indicates to show progress indicator or not.
  @override
  final bool inProgress;

  /// Indicates the type of sort items.
  final WordPageSortType wordPageSortType;

  /// Constructor.
  WordPageState({
    required this.wordPageModel,
    required this.request,
    this.errorMessage = WordPageErrorMessage.none,
    this.inProgress = false,
  }) : wordPageSortType = request.wordPageSortType;

  /// The list of properties that will be used to determine whether
  /// two [Equatable]s are equal.
  @override
  List<Object> get props => [
        wordPageModel,
        request,
        errorMessage,
        inProgress,
        wordPageSortType,
      ];

  /// If set to `true`, the [toString] method will be overridden to output
  /// this [Equatable]'s [props].
  @override
  bool get stringify => true;

  /// Makes a copy of current instance with some new values.
  WordPageState copyWith({
    WordPageModel? wordPageModel,
    SearchRequestModel? request,
    WordPageErrorMessage? errorMessage,
    bool? inProgress,
    WordPageSortType? wordPageSortType,
  }) {
    return WordPageState(
      wordPageModel: wordPageModel ?? this.wordPageModel,
      request: request ?? this.request,
      errorMessage: errorMessage ?? this.errorMessage,
      inProgress: inProgress ?? this.inProgress,
    );
  }
}

/// Possible error types
enum WordPageErrorMessage { none, commonServerError }
