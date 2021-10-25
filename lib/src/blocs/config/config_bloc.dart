import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordfinderx/src/models/remote_config_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

part 'config_event.dart';

part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final Repository _repository;
  StreamSubscription? _remoteConfigSubscription;

  ConfigBloc(this._repository) : super(ConfigState()) {
    _init();
  }

  void _init() {
    _remoteConfigSubscription =
        _repository.remoteConfig.listen(_remoteConfigListener);
  }

  void _remoteConfigListener(RemoteConfigModel remoteConfigModel) {
    add(
      ConfigRemoteConfigFetchedEvent(
        isHapticFeedbackEnabled: remoteConfigModel.isHapticFeedbackEnabled,
      ),
    );
  }

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is ConfigRemoteConfigFetchedEvent) {
      yield* _mapConfigRemoteConfigFetchedEvent(event);
    }
  }

  Stream<ConfigState> _mapConfigRemoteConfigFetchedEvent(
      ConfigRemoteConfigFetchedEvent event) async* {
    yield state.copyWith(
      isHapticFeedbackEnabled: event.isHapticFeedbackEnabled,
    );
  }

  @override
  Future<void> close() {
    _remoteConfigSubscription?.cancel();
    _remoteConfigSubscription = null;
    return super.close();
  }
}
