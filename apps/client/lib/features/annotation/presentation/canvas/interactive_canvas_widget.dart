import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/annotation_model.dart';
import '../../providers/canvas_state_provider.dart';
import '../../providers/annotation_edit_provider.dart';
import '../../providers/annotation_providers.dart';
import '../../providers/history_provider.dart';
import '../../providers/hover_state_provider.dart';
import '../../commands/create_command.dart';
import '../../commands/modify_geometry_command.dart';
import '../../commands/delete_command.dart';
import '../../commands/batch_command.dart';
import '../../commands/canvas_command.dart';
import '../../utils/hit_test_utils.dart';
import '../../utils/geometry_mapper.dart';
import '../../utils/keyboard_handler.dart';
import '../../utils/douglas_peucker.dart';
import 'annotation_painter.dart';
import 'active_drawing_painter.dart';
import 'floating_context_menu.dart';

class InteractiveCanvasWidget extends ConsumerStatefulWidget {
  final String groundTruthId;
  final String imageUrl;
  final double mediaWidth;
  final double mediaHeight;
  final bool isReadOnly;
  final bool isStudentMode;
  final Map<String, String>? headers;

  const InteractiveCanvasWidget({
    super.key,
    required this.groundTruthId,
    required this.imageUrl,
    required this.mediaWidth,
    required this.mediaHeight,
    this.isReadOnly = false,
    this.isStudentMode = false,
    this.headers,
  });

  @override
  ConsumerState<InteractiveCanvasWidget> createState() => _InteractiveCanvasWidgetState();
}

class _InteractiveCanvasWidgetState extends ConsumerState<InteractiveCanvasWidget> {
  bool _isInitialized = false;
  final TransformationController _transformationController = TransformationController();
  
  // Track pointer for drawing
  Offset? _startDragOffset;
  int? _editingHandleIndex;
  int _activePointers = 0;

  Offset _getCanvasOffset(Offset localPosition) {
    final inverse = Matrix4.copy(_transformationController.value)..invert();
    final vec = vector_math.Vector3(localPosition.dx, localPosition.dy, 0);
    final transformed = inverse.transform3(vec);
    return Offset(transformed.x, transformed.y);
  }

  void _onPointerDown(PointerDownEvent event) {
    _activePointers++;
    final stateModel = ref.read(canvasStateProvider);
    if (stateModel.currentState == CanvasState.saving) return;

    if (_activePointers >= 2 || stateModel.activeTool == CanvasTool.pan) {
      ref.read(canvasStateProvider.notifier).setState(CanvasState.panning);
      return;
    }

    final canvasOffset = _getCanvasOffset(event.localPosition);
    final tool = stateModel.activeTool;
    final draftNotifier = ref.read(activeDraftProvider.notifier);
    final draft = ref.read(activeDraftProvider);

    if (stateModel.currentState == CanvasState.editing && draft != null) {
      if (draft.type == 'Rectangle' && draft.rect != null) {
        final handle = HitTestUtils.hitTestRectHandle(canvasOffset, draft.rect!);
        if (handle != -1) {
          _editingHandleIndex = handle;
          ref.read(canvasStateProvider.notifier).setState(CanvasState.dragging);
          return;
        }
      } else if (draft.type == 'Polygon' && draft.points != null) {
        final handle = HitTestUtils.hitTestPolygonHandle(canvasOffset, draft.points!);
        if (handle != -1) {
          _editingHandleIndex = handle;
          ref.read(canvasStateProvider.notifier).setState(CanvasState.dragging);
          return;
        }
      }
      
      bool hitBody = false;
      if (draft.type == 'Rectangle' && HitTestUtils.hitTestRect(canvasOffset, draft.rect!)) hitBody = true;
      if (draft.type == 'Polygon' && HitTestUtils.hitTestPolygon(canvasOffset, draft.points!)) hitBody = true;
      if (draft.type == 'Brush' && HitTestUtils.hitTestPath(canvasOffset, draft.points!)) hitBody = true;

      if (hitBody) {
        _editingHandleIndex = -1;
        _startDragOffset = canvasOffset;
        ref.read(canvasStateProvider.notifier).setState(CanvasState.dragging);
        return;
      }
      
      ref.read(selectedAnnotationsProvider.notifier).state = [];
      draftNotifier.clearDraft();
    }

    if (tool == CanvasTool.select && (stateModel.currentState == CanvasState.idle || stateModel.currentState == CanvasState.editing)) {
      final selected = ref.read(selectedAnnotationsProvider);
      
      // 1. Hit test handles of the currently selected annotation
      if (selected.isNotEmpty) {
        final ann = selected.first;
        int handle = -1;
        if (ann.type == 'Rectangle') {
          handle = HitTestUtils.hitTestRectHandle(canvasOffset, GeometryMapper.jsonToRect(ann.geometry));
        } else if (ann.type == 'Polygon') {
          handle = HitTestUtils.hitTestPolygonHandle(canvasOffset, GeometryMapper.jsonToPoints(ann.geometry));
        }

        if (handle != -1) {
          // Load into draft for resizing/vertex editing
          if (ann.type == 'Rectangle') {
            draftNotifier.startDraft('Rectangle', rect: GeometryMapper.jsonToRect(ann.geometry), originalId: ann.id);
          } else {
            draftNotifier.startDraft('Polygon', points: GeometryMapper.jsonToPoints(ann.geometry), originalId: ann.id);
          }
          _editingHandleIndex = handle;
          ref.read(canvasStateProvider.notifier).setState(CanvasState.dragging);
          return;
        }
      }

      // 2. Hit test bodies
      final annotations = ref.read(annotationsByGroundTruthProvider(widget.groundTruthId)).valueOrNull ?? [];
      AnnotationModel? hitAnn;
      for (final ann in annotations.reversed) {
        bool hit = false;
        if (ann.type == 'Rectangle') hit = HitTestUtils.hitTestRect(canvasOffset, GeometryMapper.jsonToRect(ann.geometry));
        else if (ann.type == 'Polygon') hit = HitTestUtils.hitTestPolygon(canvasOffset, GeometryMapper.jsonToPoints(ann.geometry));
        else if (ann.type == 'Brush') hit = HitTestUtils.hitTestPath(canvasOffset, GeometryMapper.jsonToPoints(ann.geometry));

        if (hit) {
          hitAnn = ann;
          break;
        }
      }

      if (hitAnn != null) {
        // Enforce single selection
        if (selected.isEmpty || selected.first.id != hitAnn.id) {
          ref.read(selectedAnnotationsProvider.notifier).state = [hitAnn];
        }
        _editingHandleIndex = -1;
        _startDragOffset = canvasOffset;
        ref.read(canvasStateProvider.notifier).setState(CanvasState.dragging);
        draftNotifier.clearDraft();
        return;
      }

      ref.read(canvasStateProvider.notifier).setState(CanvasState.marqueeSelecting);
      _startDragOffset = canvasOffset;
      draftNotifier.startDraft('Rectangle', rect: Rect.fromPoints(canvasOffset, canvasOffset));
    } else if (tool == CanvasTool.rectangle) {
      ref.read(canvasStateProvider.notifier).setState(CanvasState.drawingRectangle);
      _startDragOffset = canvasOffset;
      draftNotifier.startDraft('Rectangle', rect: Rect.fromPoints(canvasOffset, canvasOffset));
    } else if (tool == CanvasTool.brush) {
      ref.read(canvasStateProvider.notifier).setState(CanvasState.drawingBrush);
      draftNotifier.startDraft('Brush', points: [canvasOffset]);
    } else if (tool == CanvasTool.polygon) {
      if (stateModel.currentState != CanvasState.drawingPolygon) {
        ref.read(canvasStateProvider.notifier).setState(CanvasState.drawingPolygon);
        draftNotifier.startDraft('Polygon', points: [canvasOffset]);
      } else {
        draftNotifier.addPoint(canvasOffset);
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    final stateModel = ref.read(canvasStateProvider);
    if (stateModel.currentState == CanvasState.saving || stateModel.currentState == CanvasState.panning) return;

    final rawOffset = _getCanvasOffset(event.localPosition);
    // Clamp offset to bounds
    final canvasOffset = Offset(
      rawOffset.dx.clamp(0.0, widget.mediaWidth),
      rawOffset.dy.clamp(0.0, widget.mediaHeight),
    );

    final draftNotifier = ref.read(activeDraftProvider.notifier);
    final draft = ref.read(activeDraftProvider);

    if (stateModel.currentState == CanvasState.drawingRectangle || stateModel.currentState == CanvasState.marqueeSelecting) {
      if (_startDragOffset != null) {
        final double left = math.min(_startDragOffset!.dx, canvasOffset.dx);
        final double top = math.min(_startDragOffset!.dy, canvasOffset.dy);
        double width = (canvasOffset.dx - _startDragOffset!.dx).abs();
        double height = (canvasOffset.dy - _startDragOffset!.dy).abs();
        
        if (stateModel.currentState != CanvasState.marqueeSelecting) {
          if (width < 5.0) width = 5.0;
          if (height < 5.0) height = 5.0;
        }
        
        draftNotifier.updateRect(Rect.fromLTWH(left, top, width, height));
      }
    } else if (stateModel.currentState == CanvasState.drawingBrush) {
      if (draft != null && draft.points != null && draft.points!.isNotEmpty) {
        final lastPoint = draft.points!.last;
        if ((canvasOffset - lastPoint).distance > 3.0) {
          draftNotifier.addPoint(canvasOffset);
        }
      }
    } else if (stateModel.currentState == CanvasState.dragging) {
      if (_editingHandleIndex == -1) {
        if (_startDragOffset != null) {
          final delta = canvasOffset - _startDragOffset!;
          final currentDelta = stateModel.dragDelta ?? Offset.zero;
          ref.read(canvasStateProvider.notifier).setDragDelta(currentDelta + delta);
          _startDragOffset = canvasOffset;
        }
      } else if (draft != null && draft.type == 'Rectangle' && draft.rect != null && _editingHandleIndex != null) {
        double left = draft.rect!.left;
        double top = draft.rect!.top;
        double right = draft.rect!.right;
        double bottom = draft.rect!.bottom;
        
        switch (_editingHandleIndex) {
          case 0: left = canvasOffset.dx; top = canvasOffset.dy; break;
          case 1: right = canvasOffset.dx; top = canvasOffset.dy; break;
          case 2: right = canvasOffset.dx; bottom = canvasOffset.dy; break;
          case 3: left = canvasOffset.dx; bottom = canvasOffset.dy; break;
          case 4: top = canvasOffset.dy; break;
          case 5: right = canvasOffset.dx; break;
          case 6: bottom = canvasOffset.dy; break;
          case 7: left = canvasOffset.dx; break;
        }
        
        if (right - left < 5.0) {
          if (_editingHandleIndex == 0 || _editingHandleIndex == 3 || _editingHandleIndex == 7) left = right - 5.0;
          else right = left + 5.0;
        }
        if (bottom - top < 5.0) {
          if (_editingHandleIndex == 0 || _editingHandleIndex == 1 || _editingHandleIndex == 4) top = bottom - 5.0;
          else bottom = top + 5.0;
        }
        
        draftNotifier.updateRect(Rect.fromLTRB(left, top, right, bottom));
      } else if (draft != null && draft.type == 'Polygon' && draft.points != null && _editingHandleIndex != null) {
        final newPoints = List<Offset>.from(draft.points!);
        newPoints[_editingHandleIndex!] = canvasOffset;
        draftNotifier.updatePoints(newPoints);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _activePointers--;
    if (_activePointers < 0) _activePointers = 0;
    
    final stateModel = ref.read(canvasStateProvider);
    if (stateModel.currentState == CanvasState.saving) return;

    if (stateModel.currentState == CanvasState.panning) {
      if (_activePointers == 0) {
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
      }
      return;
    }

    if (stateModel.currentState == CanvasState.marqueeSelecting) {
      final draft = ref.read(activeDraftProvider);
      if (draft != null && draft.rect != null) {
        final marqueeRect = draft.rect!;
        final annotations = ref.read(annotationsByGroundTruthProvider(widget.groundTruthId)).valueOrNull ?? [];
        final List<AnnotationModel> selected = [];
        
        for (final ann in annotations) {
          dynamic geometry;
          if (ann.type == 'Rectangle') geometry = GeometryMapper.jsonToRect(ann.geometry);
          else geometry = GeometryMapper.jsonToPoints(ann.geometry);
          
          if (HitTestUtils.hitTestMarquee(marqueeRect, geometry)) {
            selected.clear(); // Only keep one annotation
            selected.add(ann);
          }
        }
        
        ref.read(selectedAnnotationsProvider.notifier).state = selected;
        ref.read(canvasStateProvider.notifier).setState(selected.isEmpty ? CanvasState.idle : CanvasState.editing);
      } else {
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
      }
      ref.read(activeDraftProvider.notifier).clearDraft();
    } else if (stateModel.currentState == CanvasState.drawingRectangle ||
        stateModel.currentState == CanvasState.drawingBrush ||
        stateModel.currentState == CanvasState.dragging) {
      _saveDraft();
    }
    
    _startDragOffset = null;
    _editingHandleIndex = null;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _activePointers--;
    if (_activePointers < 0) _activePointers = 0;
    
    final stateModel = ref.read(canvasStateProvider);
    if (stateModel.currentState == CanvasState.panning) {
      if (_activePointers == 0) {
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
      }
    } else {
      ref.read(activeDraftProvider.notifier).clearDraft();
      ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
    }
    
    _startDragOffset = null;
    _editingHandleIndex = null;
  }

  void _onDoubleTap() {
    final stateModel = ref.read(canvasStateProvider);
    if (stateModel.currentState == CanvasState.drawingPolygon) {
      _saveDraft();
    }
  }

  Future<void> _saveDraft() async {
    final stateModel = ref.read(canvasStateProvider);
    final draft = ref.read(activeDraftProvider);
    final history = ref.read(historyProvider.notifier);
    
    // Bounds checking helper
    bool isOutOfBounds(dynamic geom) {
      if (geom is Rect) {
        return geom.left < 0 || geom.top < 0 || geom.right > widget.mediaWidth || geom.bottom > widget.mediaHeight;
      } else if (geom is List<Offset>) {
        for (final p in geom) {
          if (p.dx < 0 || p.dy < 0 || p.dx > widget.mediaWidth || p.dy > widget.mediaHeight) return true;
        }
      }
      return false;
    }

    // Check Multi-Selection Body Drag
    if (stateModel.dragDelta != null && stateModel.dragDelta != Offset.zero) {
      final selected = ref.read(selectedAnnotationsProvider);
      final commands = <CanvasCommand>[];
      bool outOfBounds = false;
      for (final ann in selected) {
        dynamic shiftedGeom;
        Map<String, dynamic> newGeometry = {};
        if (ann.type == 'Rectangle') {
          shiftedGeom = GeometryMapper.jsonToRect(ann.geometry).shift(stateModel.dragDelta!);
          newGeometry = GeometryMapper.rectToJson(shiftedGeom);
        } else {
          shiftedGeom = GeometryMapper.jsonToPoints(ann.geometry).map((p) => p + stateModel.dragDelta!).toList();
          newGeometry = GeometryMapper.pointsToJson(shiftedGeom);
        }
        
        if (isOutOfBounds(shiftedGeom)) {
          outOfBounds = true;
          break;
        }
        
        commands.add(ModifyGeometryCommand(
          groundTruthId: widget.groundTruthId,
          annotationId: ann.id,
          type: ann.type,
          oldGeometry: ann.geometry,
          newGeometry: newGeometry,
        ));
      }
      
      if (outOfBounds) {
        ref.read(canvasStateProvider.notifier).setDragDelta(null);
        return; // Reject drag if it pushes any annotation out of bounds
      }
      
      if (commands.isNotEmpty) {
        final CanvasCommand cmd = commands.length == 1 ? commands.first : BatchCommand(commands);
        ref.read(canvasStateProvider.notifier).setDragDelta(null);
        await history.executeCommand(cmd);
        // Do not clear selection so user can drag again
        return;
      }
    }

    if (draft == null) return;
    
    // Validation
    // Policy (Sprint 4B): Self-intersecting polygons are intentionally accepted.
    // Validation of self-intersection is deferred to a future sprint. No runtime validation is required.
    dynamic draftGeom;
    if (draft.type == 'Rectangle') {
      if (draft.rect == null || draft.rect!.width * draft.rect!.height <= 0) {
        ref.read(activeDraftProvider.notifier).clearDraft();
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
        return;
      }
      draftGeom = draft.rect;
    } else if (draft.type == 'Polygon') {
      if (draft.points == null || draft.points!.length < 3) {
        ref.read(activeDraftProvider.notifier).clearDraft();
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
        return;
      }
      draftGeom = draft.points;
    } else if (draft.type == 'Brush') {
      if (draft.points == null || draft.points!.length < 2) {
        ref.read(activeDraftProvider.notifier).clearDraft();
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
        return;
      }
      draftGeom = draft.points;
    }
    
    if (draftGeom != null && isOutOfBounds(draftGeom)) {
      ref.read(activeDraftProvider.notifier).clearDraft();
      ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
      return;
    }

    Map<String, dynamic> geometry = {};
    if (draft.type == 'Rectangle') {
      geometry = GeometryMapper.rectToJson(draft.rect!);
    } else {
      // Douglas-Peucker integration: simplify the brush stroke exactly once before sending to API
      List<Offset> pointsToSave = draft.points!;
      if (draft.type == 'Brush') {
        pointsToSave = DouglasPeucker.simplify(pointsToSave, 3.0);
      }
      geometry = GeometryMapper.pointsToJson(pointsToSave);
    }

    CanvasCommand command;
    if (draft.originalId == null) {
      command = CreateAnnotationCommand(
        groundTruthId: widget.groundTruthId,
        type: draft.type,
        geometry: geometry,
        isStudentMode: widget.isStudentMode,
      );
      // Only clear selection on creation
      ref.read(selectedAnnotationsProvider.notifier).state = []; 
    } else {
      final annotations = ref.read(annotationsByGroundTruthProvider(widget.groundTruthId)).valueOrNull ?? [];
      final oldAnn = annotations.firstWhere((a) => a.id == draft.originalId);
      command = ModifyGeometryCommand(
        groundTruthId: widget.groundTruthId,
        annotationId: draft.originalId!,
        type: draft.type,
        oldGeometry: oldAnn.geometry,
        newGeometry: geometry,
      );
      // Keep selection after modification
    }
    
    ref.read(activeDraftProvider.notifier).clearDraft();
    try {
      await history.executeCommand(command);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  MouseCursor _getCursorForState(CanvasStateModel stateModel) {
    if (stateModel.currentState == CanvasState.panning || stateModel.activeTool == CanvasTool.pan) {
      return SystemMouseCursors.grab;
    }
    if (stateModel.currentState == CanvasState.dragging) {
      return SystemMouseCursors.grabbing;
    }
    final state = stateModel.currentState;
    if (state == CanvasState.drawingRectangle ||
        state == CanvasState.drawingPolygon ||
        state == CanvasState.drawingBrush ||
        stateModel.activeTool != CanvasTool.select) {
      return SystemMouseCursors.precise;
    }
    if (state == CanvasState.selecting) {
      return SystemMouseCursors.precise;
    }
    return SystemMouseCursors.basic;
  }

  @override
  Widget build(BuildContext context) {
    final stateModel = ref.read(canvasStateProvider);
    final annotationsAsync = ref.watch(annotationsByGroundTruthProvider(widget.groundTruthId));
    final draft = ref.watch(activeDraftProvider);
    final selectedAnnotations = ref.watch(selectedAnnotationsProvider);
    final history = ref.read(historyProvider.notifier);

    return CanvasKeyboardHandler(
      onUndo: () => history.undo(),
      onRedo: () => history.redo(),
      onCopy: () {},
      onPaste: () {},
      onDelete: () async {
        if (selectedAnnotations.isNotEmpty) {
          final commands = selectedAnnotations.map((ann) => DeleteAnnotationCommand(
            groundTruthId: widget.groundTruthId,
            annotationId: ann.id,
            type: ann.type,
            geometry: ann.geometry,
          )).toList();
          
          final CanvasCommand cmd = commands.length == 1 ? commands.first : BatchCommand(commands);
          await history.executeCommand(cmd);
          ref.read(selectedAnnotationsProvider.notifier).state = [];
        }
      },
      onEscape: () {
        ref.read(selectedAnnotationsProvider.notifier).state = [];
        ref.read(activeDraftProvider.notifier).clearDraft();
        ref.read(canvasStateProvider.notifier).setState(CanvasState.idle);
      },
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
          if (!_isInitialized && constraints.maxWidth > 0 && constraints.maxHeight > 0) {
            _isInitialized = true;
            final double scaleX = constraints.maxWidth / widget.mediaWidth;
            final double scaleY = constraints.maxHeight / widget.mediaHeight;
            final double scale = math.min(scaleX, scaleY) * 0.95; // 95% of viewport
            
            final double dx = (constraints.maxWidth - (widget.mediaWidth * scale)) / 2;
            final double dy = (constraints.maxHeight - (widget.mediaHeight * scale)) / 2;
            
            _transformationController.value = Matrix4.identity()
              ..translate(dx, dy)
              ..scale(scale);
          }

          return MouseRegion(
            cursor: _getCursorForState(stateModel),
            onHover: (event) {
              if (stateModel.currentState != CanvasState.idle && stateModel.currentState != CanvasState.editing) return;
              final canvasOffset = _getCanvasOffset(event.localPosition);
              final annotations = ref.read(annotationsByGroundTruthProvider(widget.groundTruthId)).valueOrNull ?? [];
              String? hitId;
              for (final ann in annotations.reversed) {
                bool hit = false;
                if (ann.type == 'Rectangle') hit = HitTestUtils.hitTestRect(canvasOffset, GeometryMapper.jsonToRect(ann.geometry));
                else if (ann.type == 'Polygon') hit = HitTestUtils.hitTestPolygon(canvasOffset, GeometryMapper.jsonToPoints(ann.geometry));
                else if (ann.type == 'Brush') hit = HitTestUtils.hitTestPath(canvasOffset, GeometryMapper.jsonToPoints(ann.geometry));

                if (hit) {
                  hitId = ann.id;
                  break;
                }
              }
              if (ref.read(hoveredAnnotationProvider) != hitId) {
                ref.read(hoveredAnnotationProvider.notifier).state = hitId;
              }
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: _onPointerDown,
              onPointerMove: _onPointerMove,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              child: GestureDetector(
                onDoubleTap: _onDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: stateModel.activeTool == CanvasTool.pan,
                  scaleEnabled: stateModel.activeTool == CanvasTool.pan,
                  constrained: false,
                  minScale: 0.1,
                  maxScale: 10.0,
                  child: Container(
                    color: Colors.transparent, // Capture events
                    width: widget.mediaWidth,
                    height: widget.mediaHeight,
                    child: Stack(
                      children: [
                        // 1. Image
                        IgnorePointer(
                          child: SizedBox(
                            width: widget.mediaWidth,
                            height: widget.mediaHeight,
                            child: Image.network(
                              widget.imageUrl,
                              headers: widget.headers,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        
                        // 2. Saved Annotations
                        RepaintBoundary(
                          child: SizedBox(
                            width: widget.mediaWidth,
                            height: widget.mediaHeight,
                            child: annotationsAsync.when(
                              data: (annotations) => Consumer(
                                builder: (context, ref, _) {
                                  final hoveredId = ref.watch(hoveredAnnotationProvider);
                                  return CustomPaint(
                                    painter: AnnotationPainter(
                                      annotations: annotations,
                                      selectedAnnotationIds: selectedAnnotations.map((a) => a.id).toSet(),
                                      hoveredAnnotationId: hoveredId,
                                      isDragging: stateModel.dragDelta != null,
                                    ),
                                  );
                                },
                              ),
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ),
                        ),

                        // 3. Active Draft
                        RepaintBoundary(
                          child: SizedBox(
                            width: widget.mediaWidth,
                            height: widget.mediaHeight,
                            child: CustomPaint(
                              painter: ActiveDrawingPainter(
                                draft: draft,
                                currentState: stateModel.currentState,
                                selectedAnnotations: selectedAnnotations,
                                dragDelta: stateModel.dragDelta,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      if (selectedAnnotations.isNotEmpty && stateModel.currentState == CanvasState.idle)
        FloatingContextMenu(
          annotations: selectedAnnotations,
          transform: _transformationController.value,
          onDelete: () async {
            final commands = selectedAnnotations.map((ann) => DeleteAnnotationCommand(
              groundTruthId: widget.groundTruthId,
              annotationId: ann.id,
              type: ann.type,
              geometry: ann.geometry,
            )).toList();
            final CanvasCommand cmd = commands.length == 1 ? commands.first : BatchCommand(commands);
            await history.executeCommand(cmd);
            ref.read(selectedAnnotationsProvider.notifier).state = [];
          },
          onDuplicate: () async {
            final commands = selectedAnnotations.map((ann) {
              Map<String, dynamic> newGeometry = {};
              const offset = Offset(20, 20); // shift duplicate by 20px
              if (ann.type == 'Rectangle') {
                newGeometry = GeometryMapper.rectToJson(GeometryMapper.jsonToRect(ann.geometry).shift(offset));
              } else {
                newGeometry = GeometryMapper.pointsToJson(GeometryMapper.jsonToPoints(ann.geometry).map((p) => p + offset).toList());
              }
              return CreateAnnotationCommand(
                groundTruthId: widget.groundTruthId,
                type: ann.type,
                geometry: newGeometry,
                isStudentMode: widget.isStudentMode,
              );
            }).toList();
            final CanvasCommand cmd = commands.length == 1 ? commands.first : BatchCommand(commands);
            await history.executeCommand(cmd);
            ref.read(selectedAnnotationsProvider.notifier).state = [];
          },
        ),
      ],
    ),
  );
}
}
