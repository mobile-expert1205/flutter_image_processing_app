import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/widgets/dictionary_first_start_selector/dictionary_selector_dialogue.dart';
import 'package:wordfinderx/src/widgets/dictionary_first_start_selector/dictionary_selector_painter.dart';
import 'package:pedantic/pedantic.dart';

class DictionarySelectorOverlay extends StatefulWidget {
  final Widget child;

  DictionarySelectorOverlay({required this.child, Key? key}) : super(key: key);

  @override
  _DictionarySelectorOverlayState createState() =>
      _DictionarySelectorOverlayState();
}

class _DictionarySelectorOverlayState extends State<DictionarySelectorOverlay>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _dialogueOverlayEntry;
  OverlayEntry? _arrowOverlayEntry;
  late AnimationController _animationController;
  bool _showingInProgress = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showingInProgress) {
      _showingInProgress = true;
      _showOverlayDelayed(context);
    }
    return widget.child;
  }

  void _insertArrowOverlay(BuildContext context, Offset dialoguePosition) {
    if (_arrowOverlayEntry != null) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox;

    if (renderBox == null || !renderBox.attached) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    _arrowOverlayEntry = OverlayEntry(builder: (BuildContext overlayContext) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: _removeOverlay,
          child: _wrapWithAnimationBuilder(
            CustomPaint(
              painter: DictionarySelectorPainter(
                menuButtonOffset: position,
                menuButtonSize: renderBox.size,
                menuCircleRadialPadding: 10.0,
                arrowLineStartPoint: Offset(
                  mediaQueryData.size.width / 3,
                  dialoguePosition.dy - 5,
                ),
              ),
            ),
          ),
        ),
      );
    });

    Overlay.of(context)?.insert(
      _arrowOverlayEntry!,
      below: _dialogueOverlayEntry,
    );
  }

  Widget _wrapWithAnimationBuilder(Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext animationContext, Widget? child) {
        return Opacity(
          opacity: _animationController.value,
          child: child,
        );
      },
      child: child,
    );
  }

  void _showOverlayDelayed(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));

    BlocProvider.of<SearchBloc>(context)
        .add(DictionarySelectionDialogueShowed());

    _dialogueOverlayEntry =
        OverlayEntry(builder: (BuildContext overlayContext) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: _wrapWithAnimationBuilder(
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 600.0),
              child: DictionarySelectorDialogue(
                onSubmit: _removeOverlay,
                onHeightCallback: (Offset o) => _insertArrowOverlay(context, o),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context)?.insert(_dialogueOverlayEntry!);
    unawaited(_animationController.forward());
  }

  void _removeOverlay() {
    _dialogueOverlayEntry?.remove();
    _dialogueOverlayEntry = null;
    _arrowOverlayEntry?.remove();
    _arrowOverlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }
}
