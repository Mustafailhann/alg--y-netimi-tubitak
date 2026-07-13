import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/annotation_model.dart';

class DraftAnnotation {
  final String? originalId; // Null if creating new
  final String type; // 'Rectangle', 'Polygon', 'Brush'
  final Rect? rect;
  final List<Offset>? points;
  final Path? cachedPath;

  DraftAnnotation({
    this.originalId,
    required this.type,
    this.rect,
    this.points,
    this.cachedPath,
  });

  DraftAnnotation copyWith({
    String? type,
    Rect? rect,
    List<Offset>? points,
    Path? cachedPath,
  }) {
    return DraftAnnotation(
      originalId: originalId,
      type: type ?? this.type,
      rect: rect ?? this.rect,
      points: points ?? this.points,
      cachedPath: cachedPath ?? this.cachedPath,
    );
  }
}

class AnnotationEditNotifier extends StateNotifier<DraftAnnotation?> {
  AnnotationEditNotifier() : super(null);

  void startDraft(String type, {Rect? rect, List<Offset>? points, String? originalId}) {
    Path? cachedPath;
    if (type == 'Brush' && points != null && points.isNotEmpty) {
      cachedPath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        cachedPath.lineTo(points[i].dx, points[i].dy);
      }
    }
    state = DraftAnnotation(
      type: type,
      rect: rect,
      points: points,
      originalId: originalId,
      cachedPath: cachedPath,
    );
  }

  void updateRect(Rect rect) {
    if (state != null) {
      state = state!.copyWith(rect: rect);
    }
  }

  void updatePoints(List<Offset> points) {
    if (state != null) {
      state = state!.copyWith(points: points);
    }
  }

  void addPoint(Offset point) {
    if (state != null && state!.points != null) {
      final newPoints = [...state!.points!, point];
      final Path? newCachedPath = state!.cachedPath;
      if (state!.type == 'Brush' && newCachedPath != null) {
        newCachedPath.lineTo(point.dx, point.dy);
      }
      state = state!.copyWith(points: newPoints, cachedPath: newCachedPath);
    }
  }

  void clearDraft() {
    state = null;
  }
}

final activeDraftProvider = StateNotifierProvider<AnnotationEditNotifier, DraftAnnotation?>((ref) {
  return AnnotationEditNotifier();
});

/// Holds the currently selected annotations
final selectedAnnotationsProvider = StateProvider<List<AnnotationModel>>((ref) => []);
