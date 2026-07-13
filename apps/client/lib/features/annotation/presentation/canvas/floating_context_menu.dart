import 'package:flutter/material.dart';
import '../../models/annotation_model.dart';
import '../../utils/geometry_mapper.dart';

class FloatingContextMenu extends StatelessWidget {
  final List<AnnotationModel> annotations;
  final Matrix4 transform;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const FloatingContextMenu({
    super.key,
    required this.annotations,
    required this.transform,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    if (annotations.isEmpty) return const SizedBox.shrink();

    // 1. Compute collective bounding box in canvas coordinates
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final ann in annotations) {
      if (ann.type == 'Rectangle') {
        final rect = GeometryMapper.jsonToRect(ann.geometry);
        if (rect.left < minX) minX = rect.left;
        if (rect.top < minY) minY = rect.top;
        if (rect.right > maxX) maxX = rect.right;
        if (rect.bottom > maxY) maxY = rect.bottom;
      } else {
        final points = GeometryMapper.jsonToPoints(ann.geometry);
        for (final p in points) {
          if (p.dx < minX) minX = p.dx;
          if (p.dy < minY) minY = p.dy;
          if (p.dx > maxX) maxX = p.dx;
          if (p.dy > maxY) maxY = p.dy;
        }
      }
    }

    if (minX == double.infinity) return const SizedBox.shrink();

    // 2. Transform the top-center point to screen coordinates
    final canvasTopCenter = Offset((minX + maxX) / 2, minY);
    final transformedPoint = MatrixUtils.transformPoint(transform, canvasTopCenter);

    // 3. Position the menu slightly above the bounding box
    final menuY = transformedPoint.dy - 60.0;
    final menuX = transformedPoint.dx;

    return Positioned(
      top: menuY < 10 ? 10 : menuY,
      left: menuX - 60, // approximate centering
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              tooltip: 'Çoğalt',
              onPressed: onDuplicate,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
            Container(width: 1, height: 24, color: Colors.grey[300]),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              tooltip: 'Sil',
              onPressed: onDelete,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
