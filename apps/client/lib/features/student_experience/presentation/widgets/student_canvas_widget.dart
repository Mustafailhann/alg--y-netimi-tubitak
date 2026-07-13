import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../annotation/presentation/canvas/interactive_canvas_widget.dart';
import '../../../annotation/presentation/widgets/canvas_toolbar.dart';
import '../../../annotation/providers/canvas_state_provider.dart';
import '../../../annotation/providers/annotation_providers.dart';
import '../../../annotation/providers/history_provider.dart';
import '../../../annotation/data/annotation_data_source.dart';
import '../../../annotation/data/annotation_repository.dart';
import '../../data/providers.dart';

class StudentCanvasWidget extends ConsumerStatefulWidget {
  final String groundTruthId;
  final String imageUrl;
  final double mediaWidth;
  final double mediaHeight;
  final bool isReadOnly;

  const StudentCanvasWidget({
    super.key,
    required this.groundTruthId,
    required this.imageUrl,
    required this.mediaWidth,
    required this.mediaHeight,
    this.isReadOnly = false,
  });

  @override
  ConsumerState<StudentCanvasWidget> createState() => _StudentCanvasWidgetState();
}

class _StudentCanvasWidgetState extends ConsumerState<StudentCanvasWidget> {
  late final List<Override> _overrides;

  @override
  void initState() {
    super.initState();
    _overrides = [
      dioProvider.overrideWith((ref) => ref.watch(studentDioProvider)),
      annotationDataSourceProvider.overrideWith((ref) => AnnotationDataSource(ref.watch(dioProvider))),
      annotationRepositoryProvider.overrideWith((ref) => AnnotationRepository(ref.watch(annotationDataSourceProvider))),
      participantAnnotationProvider.overrideWith((ref, arg) {
        return ref.watch(annotationRepositoryProvider).getBySessionParticipant(arg);
      }),
      annotationsByGroundTruthProvider.overrideWith((ref, arg) {
        return ref.watch(participantAnnotationProvider(arg).future);
      }),
      historyProvider.overrideWith((ref) => HistoryNotifier(ref)),
      canvasStateProvider.overrideWith((ref) => CanvasStateNotifier()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(currentParticipantTokenProvider)?.token;

    return ProviderScope(
      overrides: _overrides,
      child: _StudentCanvasContent(
        groundTruthId: widget.groundTruthId,
        imageUrl: widget.imageUrl,
        mediaWidth: widget.mediaWidth,
        mediaHeight: widget.mediaHeight,
        token: token,
        isReadOnly: widget.isReadOnly,
      ),
    );
  }
}

class _StudentCanvasContent extends ConsumerWidget {
  final String groundTruthId;
  final String imageUrl;
  final double mediaWidth;
  final double mediaHeight;
  final String? token;
  final bool isReadOnly;

  const _StudentCanvasContent({
    required this.groundTruthId,
    required this.imageUrl,
    required this.mediaWidth,
    required this.mediaHeight,
    this.token,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateModel = ref.watch(canvasStateProvider);
    final isSaving = stateModel.currentState == CanvasState.saving;

    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isReadOnly)
                Align(
                  alignment: Alignment.topCenter,
                  child: CanvasToolbar(groundTruthId: groundTruthId),
                ),
              Expanded(
                child: IgnorePointer(
                  ignoring: isReadOnly,
                  child: InteractiveCanvasWidget(
                    groundTruthId: groundTruthId,
                    imageUrl: imageUrl,
                    mediaWidth: mediaWidth,
                    mediaHeight: mediaHeight,
                    isStudentMode: true,
                    headers: token != null ? {'Authorization': 'Bearer $token'} : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isSaving)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
