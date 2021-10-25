part of 'dictionary_bloc.dart';

enum DictionaryStage { inProgress, success, fail, notFound }

class DictionaryState extends Equatable {
  final DictionaryStage stage;
  final String word;
  final DictionaryWordModel? dictionaryWordModel;

  const DictionaryState({
    required this.word,
    required this.stage,
    this.dictionaryWordModel,
  });

  DictionaryState.init(String word)
      : stage = DictionaryStage.inProgress,
        word = word,
        dictionaryWordModel = null;

  @override
  List<Object?> get props => [
        stage,
        word,
        dictionaryWordModel,
      ];

  @override
  bool get stringify => true;

  DictionaryState copyWith({
    DictionaryStage? stage,
    String? word,
    DictionaryWordModel? dictionaryWordModel,
  }) =>
      DictionaryState(
        stage: stage ?? this.stage,
        word: word ?? this.word,
        dictionaryWordModel: dictionaryWordModel ?? this.dictionaryWordModel,
      );
}

extension BoolTests on DictionaryStage {
  bool get isInProgress => this == DictionaryStage.inProgress;

  bool get success => this == DictionaryStage.success;

  bool get fail => this == DictionaryStage.fail;

  bool get notFound => this == DictionaryStage.notFound;
}
