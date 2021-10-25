import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/widgets/app_bar_widget.dart';
import 'package:wordfinderx/src/widgets/custom_keyboard/custom_keyboard_actions_config_mixin.dart';
import 'package:wordfinderx/src/widgets/sliver_to_box_adapter_filled.dart';
import 'end_drawer_button.dart';
import 'logo.dart';

/// This class implements search screen without any results.
/// The first screen after splash that is visible for a user.
class SearchWithoutResults extends StatefulWidget {
  /// Instance of BLoC to interact with.
  final SearchBloc searchBloc;

  /// Constructor.
  SearchWithoutResults({Key? key, required this.searchBloc}) : super(key: key);

  @override
  _SearchWithoutResultsState createState() => _SearchWithoutResultsState();
}

class _SearchWithoutResultsState extends State<SearchWithoutResults>
    with CustomKeyboardActionsConfigMixin {
  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceTypeAndOrientationBloc,
        DeviceTypeAndOrientationState>(
      builder: (BuildContext ctx, DeviceTypeAndOrientationState state) {
        if (state is DeviceTypeAndOrientationKnownState) {
          return _buildContent(state);
        }

        return Container();
      },
    );
  }

  GestureDetector _buildContent(DeviceTypeAndOrientationKnownState state) {
    return GestureDetector(
      onTap: () => BlocProvider.of<InputBloc>(context).add(UnFocusRequested()),
      child: KeyboardActions(
        config: keyboardActionsConfig!,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: LogoAppBarWidget(),
              pinned: true,
              automaticallyImplyLeading: false,
              actions: [EndDrawerButton()],
            ),
            SliverToBoxAdapterFilled(
              key: ValueKey(state.deviceTypeAndOrientation.height),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Container()),
                    FittedBox(
                        child: Logo(style: AppStyles.logoLine1SearchPage)),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        bottom: 14.0,
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600.0),
                        child: buildSearchField(widget.searchBloc),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 600.0),
                      child: buildSearchOptions(
                        widget.searchBloc,
                        collapsable: false,
                      ),
                    ),
                    Expanded(flex: 2, child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
