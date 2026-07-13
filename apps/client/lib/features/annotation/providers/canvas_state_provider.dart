import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CanvasTool {
  select,
  rectangle,
  polygon,
  brush,
  pan,
}

enum CanvasState {
  idle,
  selecting,
  marqueeSelecting,
  drawingRectangle,
  drawingPolygon,
  drawingBrush,
  editing,
  dragging,
  panning,
  saving,
}

class CanvasStateModel {
  final CanvasTool activeTool;
  final CanvasState currentState;
  final Matrix4 transform;
  final String? errorMessage;
  final Offset? dragDelta;

  CanvasStateModel({
    this.activeTool = CanvasTool.select,
    this.currentState = CanvasState.idle,
    Matrix4? transform,
    this.errorMessage,
    this.dragDelta,
  }) : transform = transform ?? Matrix4.identity();

  CanvasStateModel copyWith({
    CanvasTool? activeTool,
    CanvasState? currentState,
    Matrix4? transform,
    String? errorMessage,
    Offset? dragDelta,
  }) {
    return CanvasStateModel(
      activeTool: activeTool ?? this.activeTool,
      currentState: currentState ?? this.currentState,
      transform: transform ?? this.transform,
      errorMessage: errorMessage ?? this.errorMessage,
      dragDelta: dragDelta ?? this.dragDelta,
    );
  }
}

class CanvasStateNotifier extends StateNotifier<CanvasStateModel> {
  CanvasStateNotifier() : super(CanvasStateModel());

  void setTool(CanvasTool tool) {
    if (state.currentState == CanvasState.saving) return;
    
    CanvasState nextState = CanvasState.idle;
    switch (tool) {
      case CanvasTool.select:
      case CanvasTool.rectangle:
      case CanvasTool.polygon:
      case CanvasTool.brush:
        nextState = CanvasState.idle; // Start drawing/selecting upon interaction
        break;
      case CanvasTool.pan:
        nextState = CanvasState.panning;
        break;
    }
    
    state = state.copyWith(activeTool: tool, currentState: nextState);
  }

  void setState(CanvasState newState, {String? errorMessage}) {
    state = state.copyWith(currentState: newState, errorMessage: errorMessage);
  }

  void setTransform(Matrix4 newTransform) {
    state = state.copyWith(transform: newTransform);
  }

  void setDragDelta(Offset? delta) {
    state = state.copyWith(dragDelta: delta);
  }

  void resetError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

final canvasStateProvider = StateNotifierProvider<CanvasStateNotifier, CanvasStateModel>((ref) {
  return CanvasStateNotifier();
});
