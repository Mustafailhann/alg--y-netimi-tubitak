import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/canvas_state_provider.dart';

class CanvasKeyboardHandler extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onDelete;
  final VoidCallback onEscape;

  const CanvasKeyboardHandler({
    super.key,
    required this.child,
    required this.onUndo,
    required this.onRedo,
    required this.onCopy,
    required this.onPaste,
    required this.onDelete,
    required this.onEscape,
  });

  @override
  ConsumerState<CanvasKeyboardHandler> createState() => _CanvasKeyboardHandlerState();
}

class _CanvasKeyboardHandlerState extends ConsumerState<CanvasKeyboardHandler> {
  final FocusNode _focusNode = FocusNode();
  CanvasTool? _previousTool;
  bool _isSpacePressed = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    final isControlPressed = HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlRight) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaRight);

    final isShiftPressed = HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight);

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space && !_isSpacePressed) {
        _isSpacePressed = true;
        final currentStateModel = ref.read(canvasStateProvider);
        if (currentStateModel.activeTool != CanvasTool.pan) {
          _previousTool = currentStateModel.activeTool;
          ref.read(canvasStateProvider.notifier).setTool(CanvasTool.pan);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onEscape();
      } else if (event.logicalKey == LogicalKeyboardKey.delete || event.logicalKey == LogicalKeyboardKey.backspace) {
        widget.onDelete();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyZ) {
        if (isShiftPressed) {
          widget.onRedo();
        } else {
          widget.onUndo();
        }
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyC) {
        widget.onCopy();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
        widget.onPaste();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        _isSpacePressed = false;
        if (_previousTool != null) {
          ref.read(canvasStateProvider.notifier).setTool(_previousTool!);
          _previousTool = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }
}
