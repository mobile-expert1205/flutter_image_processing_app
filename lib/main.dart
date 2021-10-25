import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/logging_bloc_observer.dart';

import 'src/app.dart';

/// The main function of the application
void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  Bloc.observer = LoggingBlocObserver();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await _initCrashlytics();
      await EasyLocalization.ensureInitialized();

      runApp(
        /// Localizations for whole app
        EasyLocalization(
          //preloaderColor: AppColors.backgroundColor,
          supportedLocales: [Locale('en', 'US')],
          path: 'assets/translations',
          fallbackLocale: Locale('en', 'US'),
          child: App(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

Future<void> _initCrashlytics() async {
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}
