import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:wordfinderx/src/models/analytics/base_event_model.dart';
import 'package:wordfinderx/src/resources/resources.dart';

/// This class implements sending events to Google Analytics.
class FirebaseAnalyticsProvider implements AnalyticsProvider {
  /// Static instance to implement singleton.
  static final FirebaseAnalyticsProvider _instance =
      FirebaseAnalyticsProvider._internal();

  /// Instance of Firebase analytics class.
  final FirebaseAnalytics _firebaseAnalytics;

  /// Private constructor.
  FirebaseAnalyticsProvider._internal()
      : _firebaseAnalytics = FirebaseAnalytics();

  /// Factory to provide singleton.
  factory FirebaseAnalyticsProvider() => _instance;

  /// Sends an event to GA
  @override
  Future<void> sendEvent(BaseEventModel event) async {
    if (kDebugMode) {
      print(
        'Send event ${event.name} to GA with '
        'parameters: ${event.parameters}',
      );
    }

    return _firebaseAnalytics.logEvent(
      name: event.name,
      parameters: event.parameters,
    );
  }

  /// Disposes all allocated resources.
  @override
  void dispose() {}
}
