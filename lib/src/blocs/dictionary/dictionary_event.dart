part of 'dictionary_bloc.dart';

abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

class DictionaryFetchDefinitionEvent extends DictionaryEvent {}
