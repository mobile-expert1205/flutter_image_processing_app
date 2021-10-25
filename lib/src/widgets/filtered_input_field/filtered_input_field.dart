import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/widgets/ink_well_stack.dart';

import '../custom_keyboard/custom_keyboard_actions_item_config.dart';

class TextValue {
  final String text;
  final int cursorPosition;

  TextValue({
    String? text,
    int? cursorPosition,
  })  : text = text ?? '',
        cursorPosition = cursorPosition ?? 0;

  TextValue copyWith({
    String? text,
    int? cursorPosition,
  }) =>
      TextValue(
        text: text ?? this.text,
        cursorPosition: cursorPosition ?? this.cursorPosition,
      );
}

/// Type of Function to get string value
/// from bloc state to show into TextInput.
typedef InitialStringGetter<S> = String Function(S);

/// Type of Function to get sequence id
/// to determinate when does unfocus this field.
typedef UnFocusSequenceGetter<S> = int Function(S);

/// Type of Function to get sequence id
/// to determinate when does unfocus this field.
typedef CleanSequenceGetter<S> = int Function(S);

/// Type of Function to get bloc event to change value into bloc.
typedef ChangedValueEventGetter<E> = E Function(String);

/// Type of Function to get bloc event to submit search.
typedef SubmitEventGetter<E> = E Function();

/// Type of Function to get bloc event to clean input field.
typedef CleanEventGetter<E> = E Function();

typedef ProcessKeyboardEventDelegate = TextValue Function(
    TextValue value, CustomKeyboardEvent event);

/// This class implements universal input field to interact with BLoC.
/// [B] - BLoC type.
/// [E] - BloC event type.
/// [S] - BLoC state type.
class FilteredInputField<B extends Bloc<E, S>, E, S> extends StatefulWidget {
  /// Instance of function to get string value from bloc state to show
  /// into TextInput.
  final InitialStringGetter<S> initialStringGetter;

  /// Instance of function to get bloc event to change value into bloc.
  final ChangedValueEventGetter<E> changeEventGetter;

  /// Instance of function to get sequence id to determinate
  /// when does unfocus this field.
  final UnFocusSequenceGetter<S>? unFocusSequenceGetter;

  final CleanSequenceGetter<S>? cleanSequenceGetter;

  /// Input decoration to customize Input Field.
  final InputDecoration? decoration;

  /// Text align for this input field;
  final TextAlign? textAlign;

  /// Text style for this input field;
  final TextStyle? textStyle;

  /// Instance of function to get bloc event to submit search.
  final SubmitEventGetter<E> submitEventGetter;

  final CustomKeyboardActionsItemConfig actionsItemConfig;

  /// Instance of function function to get bloc event to clean input field.
  final CleanEventGetter<E>? cleanEventGetter;

  /// The padding of clean icon.
  final EdgeInsets? cleanIconPadding;

  final Widget? alternativeCleanAction;

  final ProcessKeyboardEventDelegate processKeyboardEventDelegate;

  /// Constructor.
  FilteredInputField({
    Key? key,
    required this.initialStringGetter,
    required this.changeEventGetter,
    required this.submitEventGetter,
    required this.actionsItemConfig,
    required this.processKeyboardEventDelegate,
    this.cleanEventGetter,
    this.decoration,
    this.unFocusSequenceGetter,
    this.textAlign,
    this.textStyle,
    this.cleanIconPadding,
    this.alternativeCleanAction,
    this.cleanSequenceGetter,
  }) : super(key: key);

  @override
  _FilteredInputFieldState createState() => _FilteredInputFieldState<B, E, S>(
        initialStringGetter: initialStringGetter,
        changeEventGetter: changeEventGetter,
        decoration: decoration,
        unFocusSequenceGetter: unFocusSequenceGetter,
        textAlign: textAlign,
        textStyle: textStyle,
        actionsItemConfig: actionsItemConfig,
        submitEventGetter: submitEventGetter,
        cleanEventGetter: cleanEventGetter,
        cleanIconPadding: cleanIconPadding,
        alternativeCleanAction: alternativeCleanAction,
        processKeyboardEventDelegate: processKeyboardEventDelegate,
        clearSequenceGetter: cleanSequenceGetter,
      );
}

/// Implements state object to this widget.
class _FilteredInputFieldState<B extends Bloc<E, S>, E, S>
    extends State<FilteredInputField> {
  /// Instance of function to get string value from bloc state to show into TextInput.
  final InitialStringGetter<S> _initialStringGetter;

  /// Instance of function to get bloc event to change value into bloc.
  final ChangedValueEventGetter<E> _changeEventGetter;

  /// Controller to manage value of input field.
  final TextEditingController _textEditingController;

  /// Input decoration to customize Input Field.
  final InputDecoration? _decoration;

  /// Text align for this input field;
  final TextAlign _textAlign;

  /// Text style for this input field;
  final TextStyle _textStyle;

  /// Instance of function to get sequence id to determinate when does unfocus this field.
  final UnFocusSequenceGetter<S>? _unFocusSequenceGetter;

  final CleanSequenceGetter<S>? _cleanSequenceGetter;

  /// Instance of function to get bloc event to submit search.
  final SubmitEventGetter<E> _submitEventGetter;

  final CustomKeyboardActionsItemConfig _actionsItemConfig;

  /// Instance of function function to get bloc event to clean input field.
  final CleanEventGetter<E>? _cleanEventGetter;

  /// The padding of clean icon.
  final EdgeInsets _cleanIconPadding;

  final Widget? _alternativeCleanAction;

  TextValue _textValue;

  final ProcessKeyboardEventDelegate _processKeyboardEventDelegate;

  /// Constructor.
  _FilteredInputFieldState({
    required InitialStringGetter<S> initialStringGetter,
    required ChangedValueEventGetter<E> changeEventGetter,
    required CustomKeyboardActionsItemConfig actionsItemConfig,
    required SubmitEventGetter<E> submitEventGetter,
    required ProcessKeyboardEventDelegate processKeyboardEventDelegate,
    UnFocusSequenceGetter<S>? unFocusSequenceGetter,
    InputDecoration? decoration,
    TextAlign? textAlign,
    TextStyle? textStyle,
    CleanEventGetter<E>? cleanEventGetter,
    EdgeInsets? cleanIconPadding,
    Widget? alternativeCleanAction,
    CleanSequenceGetter<S>? clearSequenceGetter,
  })  : _initialStringGetter = initialStringGetter,
        _changeEventGetter = changeEventGetter,
        _decoration = decoration,
        _textEditingController = TextEditingController(),
        _textAlign = textAlign ?? TextAlign.left,
        _textStyle = textStyle ?? AppStyles.inputField,
        _unFocusSequenceGetter = unFocusSequenceGetter,
        _actionsItemConfig = actionsItemConfig,
        _submitEventGetter = submitEventGetter,
        _cleanEventGetter = cleanEventGetter,
        _cleanIconPadding = cleanIconPadding ?? EdgeInsets.zero,
        _alternativeCleanAction = alternativeCleanAction,
        _textValue = TextValue(),
        _processKeyboardEventDelegate = processKeyboardEventDelegate,
        _cleanSequenceGetter = clearSequenceGetter;

  /// Init state.
  /// Called when this object is inserted into the tree.
  @override
  void initState() {
    super.initState();
    final String initialText =
        _initialStringGetter(BlocProvider.of<B>(context).state);
    _textEditingController.text = initialText;
    _textValue =
        TextValue(text: initialText, cursorPosition: initialText.length);
    _textEditingController.addListener(_editControllerListener);
    _actionsItemConfig.valueNotifier.addListener(_valueNotifierListener);
  }

  /// Listener to obtain fresh imputed value by user.
  void _editControllerListener() {
    final int pos = _textEditingController.value.selection.start;
    _textValue = _textValue.copyWith(cursorPosition: pos);
  }

  void _valueNotifierListener() {
    final CustomKeyboardEvent event = _actionsItemConfig.valueNotifier.value;
    if (event.eventType == CustomKeyboardEventType.submit) {
      BlocProvider.of<B>(context).add(_submitEventGetter());
    } else {
      _processKeyboardEvent(event);
    }
  }

  void _processKeyboardEvent(CustomKeyboardEvent event) {
    if (event.eventType == CustomKeyboardEventType.clear) {
      _clear();
      BlocProvider.of<B>(context).add(_changeEventGetter(_textValue.text));
    } else {
      _textValue = _processKeyboardEventDelegate(_textValue, event);
      _updateControllerValue();
      BlocProvider.of<B>(context).add(_changeEventGetter(_textValue.text));
    }
  }

  void _updateControllerValue() {
    setState(() {
      _textEditingController.value = TextEditingValue(
        text: _textValue.text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: _textValue.cursorPosition),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _buildInputWithBlocs()),
      _buildCleanIcon(),
    ]);
  }

  Widget _buildInputWithBlocs() {
    Widget result = _buildInputField();
    if (_unFocusSequenceGetter != null) {
      result = _buildUnFocusBloc(result);
    }
    if (_cleanSequenceGetter != null) {
      result = _buildClearBloc(result);
    }

    return result;
  }

  /// Builds Listener to listen to BLoC.
  /// This case is needed when only unFocus functionality is needed.
  Widget _buildUnFocusBloc(Widget child) {
    return BlocListener<B, S>(
      listener: _blocUnFocusListener,
      listenWhen: _unFocusListenWhen,
      child: child,
    );
  }

  /// Determines when widget should be unFocused.
  bool _unFocusListenWhen(S previous, S current) {
    return _unFocusSequenceGetter != null
        ? _unFocusSequenceGetter!(previous) != _unFocusSequenceGetter!(current)
        : false;
  }

  /// UnFocus input field.
  void _blocUnFocusListener(BuildContext ctx, S state) {
    _actionsItemConfig.focusNode.unfocus();
  }

  /// Builds Listener to listen to BLoC.
  /// This case is needed when only unFocus functionality is needed.
  Widget _buildClearBloc(Widget child) {
    return BlocListener<B, S>(
      listener: _blocCleanListener,
      listenWhen: _cleanListenWhen,
      child: child,
    );
  }

  /// Determines when widget should be unFocused.
  bool _cleanListenWhen(S previous, S current) {
    return _cleanSequenceGetter != null
        ? _cleanSequenceGetter!(previous) != _cleanSequenceGetter!(current)
        : false;
  }

  /// UnFocus input field.
  void _blocCleanListener(BuildContext ctx, S state) {
    _clear();
  }

  /// Describes the part of the user interface represented by this widget.
  Widget _buildInputField() {
    return TextFormField(
      cursorColor: Colors.black,
      enableInteractiveSelection: true,
      readOnly: true,
      showCursor: true,
      style: _textStyle,
      textAlign: _textAlign,
      focusNode: _actionsItemConfig.focusNode,
      controller: _textEditingController,
      keyboardType: TextInputType.visiblePassword,
      decoration: _decoration,
    );
  }

  // /// Determines when value should be updated.
  // bool _valueListenWhen(S previous, S current) {
  //   return _targetStringGetter(previous) != _targetStringGetter(current) ||
  //       _positionGetter(previous) != _positionGetter(current) ||
  //       _targetStringGetter(current) != _textEditingController.text ||
  //       _positionGetter(current) !=
  //           _textEditingController.value.selection.start;
  // }
  //
  // /// Updates value in Input field.
  // void _valueBlocListener(BuildContext ctx, S state) {
  //   _lastPositionFromBloc = _positionGetter(state);
  //   _textEditingController.value = TextEditingValue(
  //     text: _targetStringGetter(state),
  //     selection: TextSelection.fromPosition(
  //       TextPosition(offset: _lastPositionFromBloc),
  //     ),
  //   );
  // }

  /// Returns clean icon.
  Widget _buildCleanIcon() {
    final bool isClean = _textValue.text.isEmpty;
    return Padding(
      padding: _cleanIconPadding,
      child: _alternativeCleanAction != null && isClean
          ? _alternativeCleanAction
          : InkWellStack(
              onTap: _clearAndSendEvent,
              child: Icon(
                Icons.cancel,
                color: isClean
                    ? AppColors.filterCleanIconInActive
                    : AppColors.filterCleanIconActive,
                // size: _cleanIconSize,
              ),
            ),
    );
  }

  void _clearAndSendEvent() {
    _clear();
    if (_cleanEventGetter != null) {
      BlocProvider.of<B>(context).add(_cleanEventGetter!());
    }
  }

  void _clear() {
    _textValue = TextValue();
    _updateControllerValue();
  }

  // /// Determines when clean icon should be build.
  // bool _cleanIconBuildWhen({
  //   required S previous,
  //   required S current,
  //   required IsCleanGetter<S> isCleanGetter,
  // }) {
  //   return isCleanGetter(previous) != isCleanGetter(current);
  // }

  /// Disposes text editing controller.
  @override
  void dispose() {
    _textEditingController.removeListener(_editControllerListener);
    _textEditingController.dispose();
    _actionsItemConfig.valueNotifier.removeListener(_valueNotifierListener);
    super.dispose();
  }
}
