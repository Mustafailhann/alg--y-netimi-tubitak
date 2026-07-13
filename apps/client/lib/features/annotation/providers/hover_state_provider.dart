import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the ID of the currently hovered annotation for the UX glow effect.
final hoveredAnnotationProvider = StateProvider<String?>((ref) => null);
