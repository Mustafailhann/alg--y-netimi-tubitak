import 'dart:math' as math;
import 'dart:ui';

class HitTestUtils {
  /// The fixed logical pixel tolerance for hit testing (10px as per spec).
  static const double hitTolerance = 10.0;

  /// Returns true if [point] is inside or near the border of [rect].
  static bool hitTestRect(Offset point, Rect rect) {
    return rect.inflate(hitTolerance).contains(point);
  }

  /// Returns true if [point] is within [hitTolerance] of any handle in [rect].
  /// Returns the index of the handle:
  /// 0: TL, 1: TR, 2: BR, 3: BL, 4: Top Center, 5: Right Center, 6: Bottom Center, 7: Left Center
  /// Returns -1 if none.
  static int hitTestRectHandle(Offset point, Rect rect) {
    final handles = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
      Offset(rect.center.dx, rect.top),      // 4: Top Center
      Offset(rect.right, rect.center.dy),    // 5: Right Center
      Offset(rect.center.dx, rect.bottom),   // 6: Bottom Center
      Offset(rect.left, rect.center.dy),     // 7: Left Center
    ];
    for (int i = 0; i < handles.length; i++) {
      if ((handles[i] - point).distance <= hitTolerance) {
        return i;
      }
    }
    return -1;
  }

  /// Returns true if [point] is within [hitTolerance] of any vertex in [points].
  /// Returns the index of the vertex, or -1 if none.
  static int hitTestPolygonHandle(Offset point, List<Offset> points) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - point).distance <= hitTolerance) {
        return i;
      }
    }
    return -1;
  }

  /// Returns true if [point] is within [hitTolerance] of any line segment formed by [points].
  /// If [isClosed] is true, also checks the segment between the last and first point.
  static bool hitTestPath(Offset point, List<Offset> points, {bool isClosed = false}) {
    if (points.isEmpty) return false;
    if (points.length == 1) {
      return (points[0] - point).distance <= hitTolerance;
    }

    final int count = isClosed ? points.length : points.length - 1;
    for (int i = 0; i < count; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      if (_distanceToSegment(point, p1, p2) <= hitTolerance) {
        return true;
      }
    }
    return false;
  }

  /// Checks if [point] is inside a closed polygon using ray-casting algorithm.
  /// Also returns true if the point is on the border (via hitTestPath).
  /// Note (Sprint 4B Policy): Self-intersecting polygons are intentionally accepted.
  /// Validation of self-intersection is deferred to a future sprint. No runtime validation is required.
  static bool hitTestPolygon(Offset point, List<Offset> points) {
    if (hitTestPath(point, points, isClosed: true)) return true;
    
    bool inside = false;
    for (int i = 0, j = points.length - 1; i < points.length; j = i++) {
      final xi = points[i].dx, yi = points[i].dy;
      final xj = points[j].dx, yj = points[j].dy;

      final intersect = ((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }

  /// Helper to calculate shortest distance from point to line segment [v, w].
  static double _distanceToSegment(Offset p, Offset v, Offset w) {
    final l2 = (w.dx - v.dx) * (w.dx - v.dx) + (w.dy - v.dy) * (w.dy - v.dy);
    if (l2 == 0) return (p - v).distance;

    double t = ((p.dx - v.dx) * (w.dx - v.dx) + (p.dy - v.dy) * (w.dy - v.dy)) / l2;
    t = math.max(0, math.min(1, t));

    final projection = Offset(v.dx + t * (w.dx - v.dx), v.dy + t * (w.dy - v.dy));
    return (p - projection).distance;
  }

  /// Returns true if the bounding box of [geometry] intersects [marquee].
  /// Supports Rect for Rectangle, and List<Offset> for Polygon/Brush.
  static bool hitTestMarquee(Rect marquee, dynamic geometry) {
    if (geometry == null) return false;
    
    Rect bounds;
    if (geometry is Rect) {
      bounds = geometry;
    } else if (geometry is List<Offset>) {
      if (geometry.isEmpty) return false;
      double minX = geometry[0].dx;
      double minY = geometry[0].dy;
      double maxX = geometry[0].dx;
      double maxY = geometry[0].dy;
      
      for (final p in geometry) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
      bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
    } else {
      return false;
    }

    return marquee.overlaps(bounds);
  }
}
