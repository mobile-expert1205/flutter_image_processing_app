import 'package:flutter_bloc/flutter_bloc.dart';

mixin ErrorCatcherMixin<S,E> on Bloc<S,E> {
  void errorCatcher(Object error, StackTrace stackTrace) {
    addError(error, stackTrace);
  }
}
