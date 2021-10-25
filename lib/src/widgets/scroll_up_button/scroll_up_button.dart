import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';

class ScrollUpButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollUpButton({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  _ScrollUpButtonState createState() => _ScrollUpButtonState(
        scrollController: scrollController,
      );
}

class _ScrollUpButtonState extends State<ScrollUpButton> {
  final ScrollController _scrollController;
  bool _isOffsetZero = true;
  late Widget _button;
  bool? isPhone;

  _ScrollUpButtonState({
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  @override
  void initState() {
    super.initState();
    _setDeviceType();
    _scrollController.addListener(_scrollListener);
    _button = _buildButton();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      buildWhen: _buildWhen,
      builder: _builder,
      listenWhen: _listenWhen,
      listener: _listener,
    );
  }

  bool _listenWhen(SearchState previous, SearchState current) =>
      previous.submitCount != current.submitCount;

  bool _buildWhen(SearchState previous, SearchState current) =>
      previous.resultPresentState != current.resultPresentState ||
      previous.isWordDefinitionShowed != current.isWordDefinitionShowed;

  void _listener(BuildContext context, SearchState state) {
    _isOffsetZero = !(isPhone ?? false);
    _setState();
  }

  void _setDeviceType() {
    if (isPhone == null) {
      final DeviceTypeAndOrientationState state =
          BlocProvider.of<DeviceTypeAndOrientationBloc>(context).state;
      if (state is DeviceTypeAndOrientationKnownState) {
        isPhone = state.deviceTypeAndOrientation.isPhone;
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.offset > 0 && _isOffsetZero) {
      _isOffsetZero = false;
      _setState();
    } else if (_scrollController.offset == 0 && !_isOffsetZero) {
      _isOffsetZero = true;
      _setState();
    }
  }

  void _setState() {
    if (mounted) setState(() {});
  }

  Widget _builder(BuildContext context, SearchState state) {
    if ((isPhone ?? false) && _scrollController.offset > 0 && _isOffsetZero) {
      _isOffsetZero = false;
    }

    final Widget child =
        state.resultPresentState == ResultPresentState.resultPresents &&
                !state.isWordDefinitionShowed &&
                !_isOffsetZero
            ? _button
            : Container();

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: child,
    );
  }

  Widget _buildButton() {
    return FloatingActionButton(
      onPressed: _scrollUp,
      elevation: 0,
      child: Icon(Icons.keyboard_arrow_up),
    );
  }

  @override
  void dispose() {
    try {
      _scrollController.removeListener(_scrollListener);
    } catch (e) {
      // ignore
    }
    super.dispose();
  }

  void _scrollUp() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }
}
