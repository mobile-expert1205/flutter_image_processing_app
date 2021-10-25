import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/blocs/config/config_bloc.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/widgets/custom_keyboard/custom_keyboard_decoration.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';

import 'custom_keyboard_builder.dart';

class CustomKeyboard extends StatefulWidget
    with KeyboardCustomPanelMixin<CustomKeyboardEvent>, PreferredSizeWidget {
  static const int _tapDelayMSec = 250;
  static const int _repeatDelayMSec = 250;

  final ValueNotifier<CustomKeyboardEvent> valueNotifier;
  final String footerText;
  final String wildcard;
  final CustomKeyboardDecoration decoration;
  final CustomKeyboardBuilder customKeyboardBuilder;

  const CustomKeyboard({
    Key? key,
    required this.valueNotifier,
    required this.decoration,
    required this.customKeyboardBuilder,
    this.footerText = '',
    this.wildcard = '',
  }) : super(key: key);

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();

  @override
  ValueNotifier<CustomKeyboardEvent> get notifier => valueNotifier;

  @override
  Size get preferredSize => _getPreferredSize();

  Size _getPreferredSize() {
    double height;
    if (footerText.isNotEmpty) {
      height = decoration.heightWithFooter;
    } else {
      height = decoration.height;
    }
    return Size.fromHeight(height);
  }
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  Timer? _repeatTimer;
  Timer? _tapDelayTimer;
  bool _isHapticFeedbackEnabled = false;

  @override
  void initState() {
    super.initState();
    _isHapticFeedbackEnabled =
        BlocProvider.of<ConfigBloc>(context).state.isHapticFeedbackEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc, ConfigState>(
      listener: _configBlocListener,
      listenWhen: _configBlocListenWhen,
      child: widget.customKeyboardBuilder.build(
        footer: _buildFooter,
        backspaceButton: _buildBackspaceButton,
        lastRow: _buildLastRow,
        bottom: _buildBottomPadding,
        lettersRowBuilder: _buildLettersRow,
        width: widget.decoration.width,
        height: widget._getPreferredSize().height,
      ),
    );
  }

  void _configBlocListener(BuildContext context, ConfigState state) {
    _isHapticFeedbackEnabled = state.isHapticFeedbackEnabled;
  }

  bool _configBlocListenWhen(ConfigState previous, ConfigState current) =>
      _isHapticFeedbackEnabled != current.isHapticFeedbackEnabled;

  Widget _buildLettersRow(
    List<String> letters, {
    List<Widget> suffix = const [],
  }) {
    List<Widget> children =
        letters.map((letter) => _buildLetterKey(letter)).toList();

    if (suffix.isNotEmpty) {
      children.addAll(suffix);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget _buildLetterKey(String letter) {
    return _buildMaterialTap(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.decoration.letterKeyHorizontalPadding / 2,
          vertical: widget.decoration.letterKeyVerticalPadding / 2,
        ),
        child: Container(
          width: widget.decoration.letterKeyWidth,
          height: widget.decoration.letterKeyHeight,
          decoration: widget.decoration.keyBoxDecoration,
          child: Center(
            child: Text(
              letter,
              style: AppStyles.keyboardSymbols.copyWith(
                fontSize: widget.decoration.letterKeyFontSize,
              ),
            ),
          ),
        ),
      ),
      onTapDown: () {
        widget.updateValue(CustomKeyboardEvent.symbol(letter));
        _restartTimers(symbol: letter);
        _lightImpact();
      },
      onTap: () {
        _stopTimers();
      },
      onTapCancel: () {
        _stopTimers();
      },
    );
  }

  void _stopTimers() {
    if (_repeatTimer?.isActive ?? false) _repeatTimer!.cancel();
    _repeatTimer = null;
    if (_tapDelayTimer?.isActive ?? false) _tapDelayTimer!.cancel();
    _tapDelayTimer = null;
  }

  void _restartTimers({String? symbol, bool? isBackspace}) {
    _stopTimers();
    if (symbol != null || isBackspace != null) {
      _tapDelayTimer = Timer(
        Duration(milliseconds: CustomKeyboard._tapDelayMSec),
        () => _processDelayedTap(symbol: symbol, isBackspace: isBackspace),
      );
    }
  }

  void _processDelayedTap({String? symbol, bool? isBackspace}) {
    if (symbol != null) {
      _repeatTimer = Timer.periodic(
        Duration(milliseconds: CustomKeyboard._repeatDelayMSec),
        (_) {
          widget.updateValue(CustomKeyboardEvent.symbol(symbol));
          _lightImpact();
        },
      );
    } else if (isBackspace ?? false) {
      widget.updateValue(CustomKeyboardEvent.clear());
    }
  }

  Widget _buildFooter() {
    if (widget.footerText.isNotEmpty) {
      return Container(
        width: widget.decoration.width,
        height: widget.decoration.footerHeight,
        color: AppColors.lightGreyColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FittedBox(
            child: Center(
              child: Text(
                widget.footerText,
                style: AppStyles.keyboardSymbols.copyWith(
                  fontSize: widget.decoration.footerFontSize,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox.fromSize(
          size: Size.fromWidth(
            widget.decoration.searchButtonHorizontalPadding,
          ),
        ),
        if (widget.wildcard.isNotEmpty) _buildSpecSymbolButton(widget.wildcard),
        Expanded(child: Container()),
        _buildSearchButton(),
        SizedBox.fromSize(
          size: Size.fromWidth(
            widget.decoration.searchButtonHorizontalPadding,
          ),
        )
      ],
    );
  }

  Widget _buildSearchButton() {
    return _buildMaterialTap(
      child: Container(
        width: widget.decoration.searchKeyWidth,
        height: widget.decoration.letterKeyHeight,
        decoration: widget.decoration.keyBoxDecoration.copyWith(
          color: AppColors.primaryColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.black,
              size: widget.decoration.searchFontSize,
            ),
            SizedBox.fromSize(size: Size.fromWidth(8.0)),
            Text(
              LocaleKeys.search_lc.tr(),
              style: AppStyles.keyboardSymbols.copyWith(
                fontSize: widget.decoration.searchFontSize,
              ),
            ),
          ],
        ),
      ),
      onTapDown: () {
        widget.updateValue(CustomKeyboardEvent.submit());
        _lightImpact();
      },
    );
  }

  Widget _buildSpecSymbolButton(String symbol) {
    return _buildMaterialTap(
      child: Container(
        width: widget.decoration.specSymbolKeyWidth,
        height: widget.decoration.letterKeyHeight,
        decoration: widget.decoration.keyBoxDecoration,
        child: Center(
          child: Text(
            symbol,
            style: AppStyles.keyboardSymbols.copyWith(
              fontSize: widget.decoration.letterKeyFontSize,
            ),
          ),
        ),
      ),
      onTapDown: () {
        widget.updateValue(CustomKeyboardEvent.symbol(symbol));
        _restartTimers(symbol: symbol);
        _lightImpact();
      },
      onTap: () {
        _stopTimers();
      },
      onTapCancel: () {
        _stopTimers();
      },
    );
  }

  Widget _buildMaterialTap({
    required Widget child,
    required VoidCallback onTapDown,
    VoidCallback? onTap,
    VoidCallback? onTapCancel,
    VoidCallback? onLongPress,
  }) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap ?? () {},
              onLongPress: onLongPress,
              onTapCancel: onTapCancel,
              onTapDown: (_) => onTapDown(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackspaceButton() {
    return _buildMaterialTap(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.decoration.letterKeyHorizontalPadding / 2,
          vertical: widget.decoration.letterKeyVerticalPadding / 2,
        ),
        child: Container(
          width: widget.decoration.backspaceKeyWidth,
          height: widget.decoration.letterKeyHeight,
          decoration: widget.decoration.keyBoxDecoration,
          child: Center(
            child: Icon(
              Icons.backspace,
              size: widget.decoration.letterKeyFontSize,
            ),
          ),
        ),
      ),
      onTapDown: () {
        widget.updateValue(CustomKeyboardEvent.backspace());
        _restartTimers(isBackspace: true);
        _lightImpact();
      },
      onTap: () {
        _stopTimers();
      },
      onTapCancel: () {
        _stopTimers();
      },
    );
  }

  Widget _buildBottomPadding() {
    return SizedBox.fromSize(
      size: Size.fromHeight(widget.decoration.bottomPadding),
      child: Container(
        color: AppColors.mediumGreyColor,
      ),
    );
  }

  void _lightImpact() {
    if (_isHapticFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}
