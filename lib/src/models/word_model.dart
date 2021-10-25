import 'package:json_annotation/json_annotation.dart';

part 'word_model.g.dart';

/// Model of word inside search results.
@JsonSerializable()
class WordModel {
  final String word;
  final int points;
  final List<int> wildcards;

  /// The screen width that is occupied by this word. This value is used
  /// for aggregating words into rows in compact result mode.
  @JsonKey(ignore: true)
  final double screenWidth;

  /// Constructor.
  WordModel({
    required this.word,
    required this.points,
    double? screenWidth,
    this.wildcards = const [],
  })  : assert(word.isNotEmpty),
        assert(points >= 0),
        screenWidth =
            (screenWidth != null && screenWidth >= 0) ? screenWidth : 0;

  /// Creates instance from Map values.
  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);

  /// Makes a copy of current instance with some new values.
  WordModel copyWith({double? screenWidth}) {
    return WordModel(
      word: word,
      points: points,
      screenWidth: screenWidth ?? this.screenWidth,
      wildcards: wildcards,
    );
  }

  /// String representation of instance.
  @override
  String toString() {
    return 'WordModel{word: $word, points: $points, wildcards: $wildcards, screenWidth: $screenWidth}';
  }
}
