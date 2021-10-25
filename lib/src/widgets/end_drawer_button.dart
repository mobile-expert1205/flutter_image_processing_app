import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_assets.dart';
import 'package:wordfinderx/src/widgets/dictionary_first_start_selector/dictionary_selector_overlay.dart';

/// Implements hamburger button with increased size to open end drawer.
class EndDrawerButton extends StatelessWidget {
  /// Constructor.
  const EndDrawerButton({
    Key? key,
  }) : super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(right: 16.0),
      icon: BlocBuilder<DeviceTypeAndOrientationBloc,
          DeviceTypeAndOrientationState>(
        buildWhen: _buildWhen,
        builder: (_, DeviceTypeAndOrientationState state) => _buildIcon(
          ValueKey(
            (state is DeviceTypeAndOrientationKnownState)
                ? state.deviceTypeAndOrientation.deviceOrientation
                : 'unknown',
          ),
        ),
      ),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }

  Widget _buildIcon(Key key) {
    return BlocBuilder<SearchBloc, SearchState>(
        key: key,
        buildWhen: (_, __) => false,
        builder: (BuildContext builderContext, SearchState state) {
          final Widget image = Image.asset(
            AppAssets.drawerButton,
            width: 28.0,
            height: 28.0,
          );

          if (state.showDictionarySelectionDialogue) {
            return DictionarySelectorOverlay(child: image);
          }

          return image;
        });
  }

  bool _buildWhen(DeviceTypeAndOrientationState previous,
          DeviceTypeAndOrientationState current) =>
      previous is DeviceTypeAndOrientationKnownState &&
      current is DeviceTypeAndOrientationKnownState &&
      previous.deviceTypeAndOrientation.deviceOrientation !=
          current.deviceTypeAndOrientation.deviceOrientation;
}
