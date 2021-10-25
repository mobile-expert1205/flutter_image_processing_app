import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';

/// This implements first screen that is showed when application is initialized.
class SplashScreen extends StatefulWidget {
  /// The page name to navigate to.
  static const String pageName = 'SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Describes the part of the user interface represented by this widget.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SearchBloc>(context).add(UserPreferencesFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext ctx, SearchState state) {
          return Container();
        },
      ),
    );
  }
}
