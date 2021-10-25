import 'word_model.dart';

class WordCompactPageModel {
  final double maxWidth;
  double _currentWidthAcc = 0;
  final List<List<WordModel>> wordCompactList;

  WordCompactPageModel({double? maxWidth})
      : maxWidth = maxWidth ?? 0,
        wordCompactList = [];

  void addWord(WordModel wordModel) {
    if (maxWidth == 0) return;

    if (_currentWidthAcc + wordModel.screenWidth < maxWidth) {
      if (wordCompactList.isEmpty) {
        wordCompactList.add([wordModel]);
        _currentWidthAcc = wordModel.screenWidth;
      } else {
        List<WordModel> lastWordRow = wordCompactList.last;
        lastWordRow.add(wordModel);
        _currentWidthAcc += wordModel.screenWidth;
      }
    } else {
      wordCompactList.add([wordModel]);
      _currentWidthAcc = wordModel.screenWidth;
    }
  }

  bool get isEmpty => maxWidth == 0;

  @override
  String toString() {
    return 'WordCompactPageModel{maxWidth: $maxWidth, _currentWidthAcc: $_currentWidthAcc, wordCompactList: $wordCompactList}';
  }
}
