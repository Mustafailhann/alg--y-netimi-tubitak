import 'package:flutter/material.dart';
import '../../providers/annotation_edit_provider.dart';
import '../../providers/canvas_state_provider.dart';
import '../../models/annotation_model.dart';
import '../../utils/geometry_mapper.dart';

class ActiveDrawingPainter extends CustomPainter {
  final DraftAnnotation? draft;
  final CanvasState currentState;
  final List<AnnotationModel> selectedAnnotations;
  final Offset? dragDelta;

  ActiveDrawingPainter({
    required this.draft,
    required this.currentState,
    this.selectedAnnotations = const [],
    this.dragDelta,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final isMarquee = currentState == CanvasState.marqueeSelecting;

    final fillPaint = Paint()
      ..color = isMarquee ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = isMarquee ? Colors.blue : Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = isMarquee ? 1.0 : 2.0;

    final brushPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final handleStrokePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    void drawHandle(Offset center) {
      if (isMarquee) return;
      canvas.drawCircle(center, 5.0, handlePaint);
      canvas.drawCircle(center, 5.0, handleStrokePaint);
    }

    // 1. Draw translated multi-selection bodies if dragging
    if (dragDelta != null && selectedAnnotations.isNotEmpty) {
      for (final ann in selectedAnnotations) {
        if (ann.type == 'Rectangle') {
          final rect = GeometryMapper.jsonToRect(ann.geometry).shift(dragDelta!);
          canvas.drawRect(rect, fillPaint);
          canvas.drawRect(rect, strokePaint);
          drawHandle(rect.topLeft);
          drawHandle(rect.topRight);
          drawHandle(rect.bottomLeft);
          drawHandle(rect.bottomRight);
          drawHandle(Offset(rect.center.dx, rect.top));
          drawHandle(Offset(rect.right, rect.center.dy));
          drawHandle(Offset(rect.center.dx, rect.bottom));
          drawHandle(Offset(rect.left, rect.center.dy));
        } else if (ann.type == 'Polygon') {
          final points = GeometryMapper.jsonToPoints(ann.geometry).map((p) => p + dragDelta!).toList();
          if (points.isNotEmpty) {
            final path = Path()..moveTo(points.first.dx, points.first.dy);
            for (int i = 1; i < points.length; i++) { path.lineTo(points[i].dx, points[i].dy); }
            canvas.drawPath(path, strokePaint);
            if (points.length >= 3) {
              final fillPath = Path.from(path)..close();
              canvas.drawPath(fillPath, fillPaint);
            }
            for (final point in points) { drawHandle(point); }
          }
        } else if (ann.type == 'Brush') {
          final points = GeometryMapper.jsonToPoints(ann.geometry).map((p) => p + dragDelta!).toList();
          if (points.isNotEmpty) {
            final path = Path()..moveTo(points.first.dx, points.first.dy);
            for (int i = 1; i < points.length; i++) { path.lineTo(points[i].dx, points[i].dy); }
            canvas.drawPath(path, brushPaint);
          }
        }
      }
    }

    // 2. Draw draft (if single edit or drawing or marquee)
    if (draft != null) {
      switch (draft!.type) {
        case 'Rectangle':
          if (draft!.rect != null) {
            canvas.drawRect(draft!.rect!, fillPaint);
            canvas.drawRect(draft!.rect!, strokePaint);
            drawHandle(draft!.rect!.topLeft);
            drawHandle(draft!.rect!.topRight);
            drawHandle(draft!.rect!.bottomLeft);
            drawHandle(draft!.rect!.bottomRight);
            drawHandle(Offset(draft!.rect!.center.dx, draft!.rect!.top));
            drawHandle(Offset(draft!.rect!.right, draft!.rect!.center.dy));
            drawHandle(Offset(draft!.rect!.center.dx, draft!.rect!.bottom));
            drawHandle(Offset(draft!.rect!.left, draft!.rect!.center.dy));
          }
          break;

        case 'Polygon':
          if (draft!.points != null && draft!.points!.isNotEmpty) {
            final path = Path()..moveTo(draft!.points!.first.dx, draft!.points!.first.dy);
            for (int i = 1; i < draft!.points!.length; i++) { path.lineTo(draft!.points![i].dx, draft!.points![i].dy); }
            canvas.drawPath(path, strokePaint);
            if (draft!.points!.length >= 3) {
              final fillPath = Path.from(path)..close();
              canvas.drawPath(fillPath, fillPaint);
            }
            for (final point in draft!.points!) { drawHandle(point); }
          }
          break;

        case 'Brush':
          if (draft!.cachedPath != null) {
            canvas.drawPath(draft!.cachedPath!, brushPaint);
          } else if (draft!.points != null && draft!.points!.isNotEmpty) {
            final path = Path()..moveTo(draft!.points!.first.dx, draft!.points!.first.dy);
            for (int i = 1; i < draft!.points!.length; i++) { path.lineTo(draft!.points![i].dx, draft!.points![i].dy); }
            canvas.drawPath(path, brushPaint);
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant ActiveDrawingPainter oldDelegate) {
    return oldDelegate.draft != draft ||
           oldDelegate.currentState != currentState ||
           oldDelegate.dragDelta != dragDelta ||
           oldDelegate.selectedAnnotations != selectedAnnotations;
  }
}
