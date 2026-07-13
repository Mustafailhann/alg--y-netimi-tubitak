import 'package:flutter/material.dart';
import '../../models/annotation_model.dart';
import '../../utils/geometry_mapper.dart';

class AnnotationPainter extends CustomPainter {
  final List<AnnotationModel> annotations;
  final Set<String> selectedAnnotationIds;
  final String? hoveredAnnotationId;
  final bool isDragging;

  AnnotationPainter({
    required this.annotations,
    required this.selectedAnnotationIds,
    this.hoveredAnnotationId,
    this.isDragging = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final annotation in annotations) {
      final isSelected = selectedAnnotationIds.contains(annotation.id);
      final isHovered = hoveredAnnotationId == annotation.id;

      // Skip drawing the original annotation if it's currently being dragged (ActiveDrawingPainter handles the translated body)
      if (isSelected && isDragging) continue;

      final rectPaint = Paint()
        ..color = isSelected ? Colors.orange.withValues(alpha: 0.3) : (isHovered ? Colors.blue.withValues(alpha: 0.4) : Colors.blue.withValues(alpha: 0.3))
        ..style = PaintingStyle.fill;
      
      final rectBorderPaint = Paint()
        ..color = isSelected ? Colors.orange : (isHovered ? Colors.blueAccent : Colors.blue)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.0 : 2.0;
        
      if (isSelected || isHovered) {
        rectBorderPaint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0);
      }

      final polyPaint = Paint()
        ..color = isSelected ? Colors.orange.withValues(alpha: 0.3) : (isHovered ? Colors.green.withValues(alpha: 0.4) : Colors.green.withValues(alpha: 0.3))
        ..style = PaintingStyle.fill;
        
      final polyBorderPaint = Paint()
        ..color = isSelected ? Colors.orange : (isHovered ? Colors.greenAccent : Colors.green)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.0 : 2.0;

      if (isSelected || isHovered) {
        polyBorderPaint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0);
      }

      final brushPaint = Paint()
        ..color = isSelected ? Colors.orange : (isHovered ? Colors.redAccent : Colors.red)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 4.0 : 3.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (isSelected || isHovered) {
        brushPaint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0);
      }

      switch (annotation.type) {
        case 'Rectangle':
          final rect = GeometryMapper.jsonToRect(annotation.geometry);
          canvas.drawRect(rect, rectPaint);
          canvas.drawRect(rect, rectBorderPaint);
          break;
        case 'Polygon':
          final points = GeometryMapper.jsonToPoints(annotation.geometry);
          if (points.isNotEmpty) {
            final path = Path()..moveTo(points.first.dx, points.first.dy);
            for (int i = 1; i < points.length; i++) {
              path.lineTo(points[i].dx, points[i].dy);
            }
            path.close();
            canvas.drawPath(path, polyPaint);
            canvas.drawPath(path, polyBorderPaint);
          }
          break;
        case 'Brush':
          final points = GeometryMapper.jsonToPoints(annotation.geometry);
          if (points.isNotEmpty) {
            final path = Path()..moveTo(points.first.dx, points.first.dy);
            for (int i = 1; i < points.length; i++) {
              path.lineTo(points[i].dx, points[i].dy);
            }
            canvas.drawPath(path, brushPaint);
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnnotationPainter oldDelegate) {
    return oldDelegate.annotations != annotations ||
           oldDelegate.selectedAnnotationIds.length != selectedAnnotationIds.length || 
           !oldDelegate.selectedAnnotationIds.containsAll(selectedAnnotationIds) ||
           oldDelegate.hoveredAnnotationId != hoveredAnnotationId ||
           oldDelegate.isDragging != isDragging;
  }
}
