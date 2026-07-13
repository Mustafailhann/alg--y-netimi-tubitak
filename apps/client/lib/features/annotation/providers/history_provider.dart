import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../commands/canvas_command.dart';
import '../providers/canvas_state_provider.dart';
import '../providers/annotation_providers.dart';

class HistoryState {
  final bool canUndo;
  final bool canRedo;
  final bool isExecuting;

  HistoryState({
    required this.canUndo,
    required this.canRedo,
    required this.isExecuting,
  });

  HistoryState copyWith({
    bool? canUndo,
    bool? canRedo,
    bool? isExecuting,
  }) {
    return HistoryState(
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      isExecuting: isExecuting ?? this.isExecuting,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final Ref _ref;
  final List<CanvasCommand> _undoStack = [];
  final List<CanvasCommand> _redoStack = [];
  static const int _maxHistory = 50;

  HistoryNotifier(this._ref) : super(HistoryState(canUndo: false, canRedo: false, isExecuting: false));

  /// Executes a new command and adds it to the undo stack. Clears the redo stack.
  Future<void> executeCommand(CanvasCommand command) async {
    if (state.isExecuting) return; // Prevent concurrent modifications
    
    // Changing state locally before execution to block other actions
    _ref.read(canvasStateProvider.notifier).setState(CanvasState.saving);
    state = state.copyWith(isExecuting: true);

    try {
      await command.execute(_ref);

      _undoStack.add(command);
      if (_undoStack.length > _maxHistory) {
        _undoStack.removeAt(0);
      }
      _redoStack.clear();
      
      _updateState();
      
      // Single invalidation after success
      _ref.invalidate(annotationsByGroundTruthProvider(command.groundTruthId));
      _ref.invalidate(participantAnnotationProvider(command.groundTruthId));
    } catch (e, st) {
      debugPrint('Command execution failed: $e');
      debugPrint(st.toString());
      rethrow;
    } finally {
      state = state.copyWith(isExecuting: false);
      _ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
    }
  }

  Future<void> undo() async {
    if (state.isExecuting || _undoStack.isEmpty) return;
    
    final command = _undoStack.removeLast();
    _ref.read(canvasStateProvider.notifier).setState(CanvasState.saving);
    state = state.copyWith(isExecuting: true);

    try {
      await command.undo(_ref);
      _redoStack.add(command);
      _updateState();
      
      // Single invalidation after success
      _ref.invalidate(annotationsByGroundTruthProvider(command.groundTruthId));
      _ref.invalidate(participantAnnotationProvider(command.groundTruthId));
    } catch (e) {
      debugPrint('Undo failed: $e');
      // If undo fails, we put it back on the undo stack to not lose it
      _undoStack.add(command);
    } finally {
      state = state.copyWith(isExecuting: false);
      _ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
    }
  }

  Future<void> redo() async {
    if (state.isExecuting || _redoStack.isEmpty) return;
    
    final command = _redoStack.removeLast();
    _ref.read(canvasStateProvider.notifier).setState(CanvasState.saving);
    state = state.copyWith(isExecuting: true);

    try {
      await command.execute(_ref);
      _undoStack.add(command);
      _updateState();
      
      // Single invalidation after success
      _ref.invalidate(annotationsByGroundTruthProvider(command.groundTruthId));
      _ref.invalidate(participantAnnotationProvider(command.groundTruthId));
    } catch (e) {
      debugPrint('Redo failed: $e');
      _redoStack.add(command);
    } finally {
      state = state.copyWith(isExecuting: false);
      _ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
    }
  }

  void _updateState() {
    state = state.copyWith(
      canUndo: _undoStack.isNotEmpty,
      canRedo: _redoStack.isNotEmpty,
    );
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier(ref);
});
