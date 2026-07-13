import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/annotation_providers.dart';
import 'canvas_command.dart';

class CreateAnnotationCommand implements CanvasCommand {
  @override
  final String groundTruthId;
  final String type;
  final Map<String, dynamic> geometry;
  final bool isStudentMode;
  
  // Stored so we can delete it on undo. Since we don't know the ID until after creation, 
  // we must capture it after execute().
  String? _createdId;

  CreateAnnotationCommand({
    required this.groundTruthId,
    required this.type,
    required this.geometry,
    this.isStudentMode = false,
  });

  @override
  Future<void> execute(Ref ref) async {
    final repo = ref.read(annotationRepositoryProvider);
    final newAnnotation = await repo.createAnnotation(
      groundTruthId: groundTruthId,
      type: type,
      geometry: geometry,
    );
    _createdId = newAnnotation.id;
  }

  @override
  Future<void> undo(Ref ref) async {
    if (_createdId != null) {
      final repo = ref.read(annotationRepositoryProvider);
      await repo.deleteAnnotation(_createdId!);
    }
  }
}
