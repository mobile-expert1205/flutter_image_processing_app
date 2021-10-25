part of 'input_bloc.dart';

class InputState extends Equatable {
  final String letters;
  final String startsWith;
  final String endsWith;
  final String contains;
  final String length;
  final int unFocusSequence;
  final int cleanSequence;
  final int filledFilterCount;
  final bool isSearchAllowed;

  InputState({
    String? letters,
    String? startsWith,
    String? endsWith,
    String? contains,
    String? length,
    int? unFocusSequence,
    int? cleanSequence,
  })  : letters = letters ?? '',
        startsWith = startsWith ?? '',
        endsWith = endsWith ?? '',
        contains = contains ?? '',
        length = length ?? '',
        unFocusSequence = unFocusSequence ?? 0,
        cleanSequence = cleanSequence ?? 0,
        filledFilterCount = startsWith.calcForFilter +
            endsWith.calcForFilter +
            contains.calcForFilter +
            length.calcForFilter,
        isSearchAllowed = letters.testForSearch ||
            startsWith.testForSearch ||
            endsWith.testForSearch ||
            contains.testForSearch ||
            length.testForSearch;

  InputState copyWith({
    String? letters,
    String? startsWith,
    String? endsWith,
    String? contains,
    String? length,
    int? unFocusSequence,
    int? cleanSequence,
  }) =>
      InputState(
        letters: letters ?? this.letters,
        startsWith: startsWith ?? this.startsWith,
        endsWith: endsWith ?? this.endsWith,
        contains: contains ?? this.contains,
        length: length ?? this.length,
        unFocusSequence: unFocusSequence ?? this.unFocusSequence,
        cleanSequence: cleanSequence ?? this.cleanSequence,
      );

  @override
  List<Object?> get props => [
        letters,
        length,
        startsWith,
        endsWith,
        contains,
        length,
        unFocusSequence,
        cleanSequence,
        filledFilterCount,
        isSearchAllowed,
      ];

  @override
  bool? get stringify => true;
}

extension StringAsFilter on String? {
  int get calcForFilter => testForSearch ? 1 : 0;

  bool get testForSearch => this?.isNotEmpty ?? false;
}
