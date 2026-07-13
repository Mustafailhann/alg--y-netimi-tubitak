import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/annotation_providers.dart';
import 'canvas_command.dart';

class ModifyGeometryCommand implements CanvasCommand {
  @override
  final String groundTruthId;
  final String annotationId;
  final String type;
  final Map<String, dynamic> oldGeometry;
  final Map<String, dynamic> newGeometry;

  ModifyGeometryCommand({
    required this.groundTruthId,
    required this.annotationId,
    required this.type,
    required this.oldGeometry,
    required this.newGeometry,
  });

  @override
  Future<void> execute(Ref ref) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.updateAnnotation(
      id: annotationId,
      type: type,
      geometry: newGeometry,
    );
  }

  @override
  Future<void> undo(Ref ref) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.updateAnnotation(
      id: annotationId,
      type: type,
      geometry: oldGeometry,
    );
  }
}
