import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/annotation_providers.dart';
import 'canvas_command.dart';

class DeleteAnnotationCommand implements CanvasCommand {
  @override
  final String groundTruthId;
  String annotationId; // The ID of the annotation to delete (can change if this is redone after an undo)
  final String type;
  final Map<String, dynamic> geometry;

  DeleteAnnotationCommand({
    required this.groundTruthId,
    required this.annotationId,
    required this.type,
    required this.geometry,
  });

  @override
  Future<void> execute(Ref ref) async {
    final repo = ref.read(annotationRepositoryProvider);
    await repo.deleteAnnotation(annotationId);
  }

  @override
  Future<void> undo(Ref ref) async {
    // Recreate the annotation since backend doesn't support soft delete/restore
    final repo = ref.read(annotationRepositoryProvider);
    final restored = await repo.createAnnotation(
      groundTruthId: groundTruthId,
      type: type,
      geometry: geometry,
    );
    // Update the ID so a subsequent Redo (execute) deletes the correct new ID
    annotationId = restored.id;
  }
}
