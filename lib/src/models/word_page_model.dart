import 'package:json_annotation/json_annotation.dart';
import 'package:wordfinderx/src/models/word_model.dart';

import 'word_compact_page_model.dart';

part 'word_page_model.g.dart';

/// Model of word's page.
@JsonSerializable()
class WordPageModel {
  /// Array of words to show in table mode.
  @JsonKey(name: 'word_list')
  final List<WordModel> wordList;

  /// Array of rows of words to show in compact mode.
  @JsonKey(ignore: true)
  final WordCompactPageModel wordCompactPage;
  @JsonKey(ignore: true)
  final WordCompactPageModel wordCompactPageLandscape;
  @JsonKey(defaultValue: 0)
  final int length;
  @JsonKey(name: 'num_words')
  final int numWords;
  @JsonKey(name: 'num_pages')
  final int numPages;
  @JsonKey(name: 'current_page')
  final int currentPage;

  /// Constructor.
  WordPageModel({
    required this.wordList,
    required this.length,
    required this.numWords,
    required this.numPages,
    required this.currentPage,
    WordCompactPageModel? wordCompactPage,
    WordCompactPageModel? wordCompactPageLandscape,
  })  : wordCompactPage = wordCompactPage ?? WordCompactPageModel(),
        wordCompactPageLandscape =
            wordCompactPageLandscape ?? WordCompactPageModel(),
        assert(numWords >= 0),
        assert(numPages >= 0),
        assert(currentPage >= 0);

  /// Creates instance from Map values.
  factory WordPageModel.fromJson(Map<String, dynamic> json) =>
      _$WordPageModelFromJson(json);

  /// Returns true if there are more words than this page contains already.
  bool get isMorePages => currentPage < numPages;

  WordPageModel copyWith({
    WordCompactPageModel? wordCompactPage,
    WordCompactPageModel? wordCompactPageLandscape,
  }) {
    return WordPageModel(
      wordList: wordList,
      length: length,
      numWords: numWords,
      numPages: numPages,
      currentPage: currentPage,
      wordCompactPage: wordCompactPage ?? this.wordCompactPage,
      wordCompactPageLandscape:
          wordCompactPageLandscape ?? this.wordCompactPageLandscape,
    );
  }

  /// String representation of instance.
  @override
  String toString() {
    return 'WordPageModel{wordList: $wordList, wordCompactPage: $wordCompactPage, wordCompactPageLandscape: $wordCompactPageLandscape, length: $length, numWords: $numWords, numPages: $numPages, currentPage: $currentPage}';
  }
}
