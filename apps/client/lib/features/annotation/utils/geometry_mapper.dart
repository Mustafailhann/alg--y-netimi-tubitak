import 'dart:ui';

class GeometryMapper {
  /// Converts a Flutter Rect into the Annotation JSON schema for Rectangle.
  static Map<String, dynamic> rectToJson(Rect rect) {
    return {
      'x': rect.left,
      'y': rect.top,
      'width': rect.width,
      'height': rect.height,
    };
  }

  /// Converts a list of Flutter Offsets into the Annotation JSON schema for Polygon/Brush.
  static Map<String, dynamic> pointsToJson(List<Offset> points) {
    return {
      'points': points.map((p) => [p.dx, p.dy]).toList(),
    };
  }

  /// Parses Annotation JSON schema into a Flutter Rect.
  /// Expects 'x', 'y', 'width', 'height'.
  static Rect jsonToRect(Map<String, dynamic> json) {
    final x = (json['x'] as num?)?.toDouble() ?? 0.0;
    final y = (json['y'] as num?)?.toDouble() ?? 0.0;
    final width = (json['width'] as num?)?.toDouble() ?? 0.0;
    final height = (json['height'] as num?)?.toDouble() ?? 0.0;
    return Rect.fromLTWH(x, y, width, height);
  }

  /// Parses Annotation JSON schema into a list of Flutter Offsets.
  /// Expects 'points' array of [x, y].
  static List<Offset> jsonToPoints(Map<String, dynamic> json) {
    final pointsRaw = json['points'];
    if (pointsRaw is! List) return [];

    final points = <Offset>[];
    for (final pt in pointsRaw) {
      if (pt is List && pt.length >= 2) {
        points.add(Offset(
          (pt[0] as num).toDouble(),
          (pt[1] as num).toDouble(),
        ));
      }
    }
    return points;
  }

  /// Creates a Flutter Path from an Annotation JSON schema geometry map.
  static Path? createPathFromGeometry(Map<String, dynamic> geometry) {
    if (geometry.containsKey('points')) {
      final points = jsonToPoints(geometry);
      if (points.isEmpty) return null;
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      return path;
    } else if (geometry.containsKey('x') && geometry.containsKey('y') && geometry.containsKey('width') && geometry.containsKey('height')) {
      final rect = jsonToRect(geometry);
      return Path()..addRect(rect);
    }
    return null;
  }
}
