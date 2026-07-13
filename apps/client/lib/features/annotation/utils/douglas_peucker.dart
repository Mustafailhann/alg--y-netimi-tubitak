import 'package:flutter/material.dart';

class DouglasPeucker {
  /// Simplifies a path of points using the Ramer-Douglas-Peucker algorithm.
  /// [epsilon] represents the maximum distance a point can be from the simplified line segment.
  static List<Offset> simplify(List<Offset> points, double epsilon) {
    if (points.length < 3) return points;

    double maxDistance = 0;
    int index = 0;
    final int end = points.length - 1;

    for (int i = 1; i < end; i++) {
      final double distance = _perpendicularDistance(points[i], points[0], points[end]);
      if (distance > maxDistance) {
        maxDistance = distance;
        index = i;
      }
    }

    if (maxDistance > epsilon) {
      final List<Offset> left = simplify(points.sublist(0, index + 1), epsilon);
      final List<Offset> right = simplify(points.sublist(index, end + 1), epsilon);
      return [...left.sublist(0, left.length - 1), ...right];
    } else {
      return [points[0], points[end]];
    }
  }

  /// Calculates the perpendicular distance of a [point] from a line defined by [lineStart] and [lineEnd].
  static double _perpendicularDistance(Offset point, Offset lineStart, Offset lineEnd) {
    final double area = (0.5 *
            (lineStart.dx * lineEnd.dy +
                lineEnd.dx * point.dy +
                point.dx * lineStart.dy -
                lineEnd.dx * lineStart.dy -
                point.dx * lineEnd.dy -
                lineStart.dx * point.dy))
        .abs();
    final double bottom = (lineStart - lineEnd).distance;
    return bottom == 0 ? (lineStart - point).distance : area / bottom * 2.0;
  }
}
