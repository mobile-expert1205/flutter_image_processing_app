import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/app_secrets.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';
import 'package:wordfinderx/src/resources/email_feedback_provider.dart';
import 'package:wordfinderx/src/resources/firebase_analytics_provider.dart';
import 'package:wordfinderx/src/resources/http_dictionary_provider.dart';
import 'package:wordfinderx/src/resources/http_search_provider.dart';
import 'package:wordfinderx/src/resources/main_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/resources/shared_prefernces_provider.dart';
import 'package:wordfinderx/src/resources/firebase_remote_config_provider.dart';
import 'package:wordfinderx/src/screens/splash_screen.dart';
import 'package:wordfinderx/src/widgets/common.dart';
import 'package:pedantic/pedantic.dart';

import 'blocs/app_router_bloc.dart';
import 'blocs/config/config_bloc.dart';
import 'blocs/device_info/device_info.dart';
import 'common/app_styles.dart';
import 'models/word_model.dart';
import 'resources/device_info_provider_imp.dart';
import 'resources/resources.dart';
import 'screens/search_screen.dart';

/// Main class of application that implements MaterialApp.
class App extends StatefulWidget {
  /// Instance of repository that provides global business logic of application.
  final Repository? repository;

  /// Constructor
  ///
  /// We can specify another [repository] for whole application.
  /// It may be needed to test.
  App({Key? key, this.repository}) : super(key: key);

  /// Creates a state for this stateful widget.
  @override
  _AppState createState() => _AppState();
}

/// State class for App class
class _AppState extends State<App> with WidgetsBindingObserver {
  /// GlobalKey to get access to Navigator object to control navigation.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  /// Instance of repository that provides global business logic of application.
  late Repository _repository;

  /// Subscription of stream of routes in instance of  RouterBloc.
  StreamSubscription? _routeSubscription;

  /// Instance of RouterBloc that provides navigation through application.
  late AppRouterBloc _routerBloc;

  bool _orientationWasSet = false;

  final DeviceTypeAndOrientationBloc _deviceTypeAndOrientationBloc =
      DeviceTypeAndOrientationBloc();

  late SearchBloc _searchBloc;

  /// Creates initial state.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

    /// Initialize RouterBloc instance
    _routerBloc = AppRouterBloc();

    /// If instance of Repository didn't provide through constructor
    /// would create default
    _repository = widget.repository ?? _getRepository();

    /// Subscribes to route stream that provides instance of RouterBloc class.
    _routeSubscription = _routerBloc.route.listen(_routeListener);
  }

  /// Listens to route events provided by instance of RouterBloc class.
  void _routeListener(AppRoute route) async {
    switch (route.routeActionType) {
      case RouteActionType.push:
        {
          unawaited(_navigatorKey.currentState?.pushNamed(route.routeName));
          break;
        }
      case RouteActionType.pushReplacement:
        {
          unawaited(_navigatorKey.currentState
              ?.pushReplacementNamed(route.routeName));
          break;
        }
    }
  }

  /// Returns an instance of Repository class.
  Repository _getRepository() {
    /// Instance of function that calculates word screen width. It's necessary
    /// to pre-layout compact result mode in order to split into separate lines.
    final WordWidthCalculator wordWidthCalculator =
        (WordModel wordModel) => calculateWordWidth(
              wordModel: wordModel,
              wordStyle: AppStyles.wordBlockWord,
              pointStyle: AppStyles.wordBlockPoints,
              paddingValue: 36,
            );

    /// Shared preferences provider to store user preferences locally.
    final PreferencesProvider preferencesProvider = SharedPreferencesProvider();

    /// Provider to fetch remote config from Firebase.
    final RemoteConfigProvider remoteConfigProvider =
        FirebaseRemoteConfigProvider();

    /// Provider to send Google Analytics.
    final AnalyticsProvider analyticsProvider = FirebaseAnalyticsProvider();

    /// Provider of information about device (deviceType, os, version, etc.)
    final DeviceInfoProvider deviceInfoProvider = DeviceInfoProviderImpl();

    /// Provider to send feedback through email.
    final FeedbackProvider feedbackProvider = EmailFeedbackProvider();

    /// Provider to get words definitions.
    final DictionaryProvider dictionaryProvider = HttpDictionaryProvider();

    /// Creates instance of main repository.
    return MainRepository(
      searchProvider: HttpSearchProvider(),
      wordWidthCalculator: wordWidthCalculator,
      localPreferencesProvider: preferencesProvider,
      remoteConfigProvider: remoteConfigProvider,
      analyticsProvider: analyticsProvider,
      deviceInfoProvider: deviceInfoProvider,
      feedbackProvider: feedbackProvider,
      dictionaryProvider: dictionaryProvider,
    );
  }

  /// Builds widget tree
  @override
  Widget build(BuildContext context) {
    _setOrientation(context);

    final PurchaseBloc purchaseBloc = PurchaseBloc(AppSecrets())
      ..add(PurchaseInitEvent());

    _searchBloc = SearchBloc(
      repository: _repository,
      appRouterBloc: _routerBloc,
      purchaseBloc: purchaseBloc,
    );

    return RepositoryProvider<Repository>.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _searchBloc),
          BlocProvider.value(value: _deviceTypeAndOrientationBloc),
          BlocProvider.value(value: purchaseBloc),
          BlocProvider(create: (_) => InputBloc(_repository, _searchBloc)),
          BlocProvider(create: (_) => DeviceInfoBloc(_repository)),
          BlocProvider(create: (_) => ConfigBloc(_repository), lazy: false),
        ],
        child: MaterialApp(
          builder: (BuildContext ctx, Widget? child) => MediaQuery(
            data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
            child: child!,
          ),
          //showPerformanceOverlay: true,
          //checkerboardOffscreenLayers: true,
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: _getThemeData(context),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routes: _getRoutes(),
        ),
      ),
    );
  }

  void _setOrientation(BuildContext context) {
    if (!_orientationWasSet) {
      _orientationWasSet = true;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;

        final DeviceTypeAndOrientationModel deviceTypeAndOrientationModel =
            DeviceTypeAndOrientationModel.fromSize(
          width: renderBox.size.width,
          height: renderBox.size.height,
        );
        if (deviceTypeAndOrientationModel.deviceType == MyDeviceType.phone) {
          SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp],
          );
        }

        _updateMetrics();
      });
    }
  }

  /// Returns theme data to customize UI colors and styles
  ThemeData _getThemeData(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.primaryColor,
      unselectedWidgetColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        hoverColor: Colors.white,
        focusColor: Colors.white,
        border: InputBorder.none,
      ),
    );
  }

  /// Returns possible routes for application
  Map<String, WidgetBuilder> _getRoutes() {
    return <String, WidgetBuilder>{
      '/': (_) => SplashScreen(),
      SplashScreen.pageName: (_) => SplashScreen(),
      SearchScreen.pageName: (_) => SearchScreen(),
    };
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateMetrics();
  }

  void _updateMetrics() {
    if (WidgetsBinding.instance?.window != null) {
      final MediaQueryData mediaData =
          MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

      _deviceTypeAndOrientationBloc.add(DeviceTypeAndOrientationSet(
        width: mediaData.size.width,
        height: mediaData.size.height,
        bottomPadding: mediaData.viewPadding.bottom,
        topPadding: mediaData.viewPadding.top,
      ));
    }
  }

  /// Disposes of all prior initialized instances and subscriptions.
  @override
  void dispose() {
    _deviceTypeAndOrientationBloc.close();
    WidgetsBinding.instance?.removeObserver(this);
    _repository.dispose();
    _routeSubscription?.cancel();
    _routerBloc.dispose();
    super.dispose();
  }
}
