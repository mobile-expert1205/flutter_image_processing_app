import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/widgets/options_drawer.dart';
import 'package:wordfinderx/src/widgets/overlay_progress_indicator.dart';
import 'package:wordfinderx/src/widgets/search_result.dart';
import 'package:wordfinderx/src/widgets/common.dart';
import 'package:wordfinderx/src/widgets/search_without_results.dart';

/// This implements search screen to show input fields, results and etc.
class SearchScreen extends StatefulWidget {
  /// The page name to navigate to.
  static const String pageName = 'SearchScreen';

  /// Returns State object for this widget.
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

/// State class for SearchScreen widget.
class _SearchScreenState extends State<SearchScreen> {
  /// Search BLoC instance.
  SearchBloc? _searchBloc;

  /// Global key of Scaffold to find it through widget three.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  /// Called when a dependency of this [State] object changes.
  /// Used to initialize BLoC variable.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchBloc ??= BlocProvider.of<SearchBloc>(context);
  }

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      endDrawer: OptionsDrawer(searchBloc: _searchBloc!),
      body: _buildBody(),
    );
  }

  /// Returns content of the screen.
  Widget _buildBody() {
    return OverlayProgressIndicator<SearchBloc, SearchState>(
      bloc: _searchBloc!,
      child: BlocConsumer<SearchBloc, SearchState>(
        bloc: _searchBloc,
        listenWhen: (SearchState p, SearchState c) =>
            p.errorMessage != c.errorMessage,
        listener: _errorListener,
        buildWhen: (SearchState p, SearchState c) =>
            p.resultPresentState != c.resultPresentState,
        builder: (BuildContext ctx, SearchState state) {
          if (state.resultPresentState == ResultPresentState.noResult) {
            return SearchWithoutResults(searchBloc: _searchBloc!);
          }
          return SearchResult(
            searchBloc: _searchBloc!,
            deviceTypeAndOrientationBloc: BlocProvider.of(context),
          );
        },
      ),
    );
  }

  /// Listener to show errors on SnackBar.
  void _errorListener(BuildContext context, SearchState state) {
    if (state.errorMessage != SearchErrorMessage.none) {
      String message = '';
      switch (state.errorMessage) {
        case SearchErrorMessage.commonServerError:
          {
            message = LocaleKeys.serverError.tr();
            break;
          }
        case SearchErrorMessage.none:
          {
            message = '';
            break;
          }
      }
      if (message.isNotEmpty) {
        showTextOnSnackBar(text: message, context: context);
      }
    }
  }

  /// Closes the search BLoC.
  @override
  void dispose() {
    super.dispose();
    _searchBloc?.close();
  }
}
