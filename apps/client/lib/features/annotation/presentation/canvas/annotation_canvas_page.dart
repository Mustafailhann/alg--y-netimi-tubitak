import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/canvas_state_provider.dart';
import 'interactive_canvas_widget.dart';
import '../widgets/canvas_toolbar.dart';
import '../../../admin/models/assessment_model.dart';
import '../../../admin/providers/admin_providers.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/config/environment_config.dart';
import '../../../admin/models/media_model.dart';

class AnnotationCanvasPage extends ConsumerStatefulWidget {
  final String groundTruthId;
  final GroundTruthModel? groundTruth;

  const AnnotationCanvasPage({
    super.key,
    required this.groundTruthId,
    this.groundTruth,
  });

  @override
  ConsumerState<AnnotationCanvasPage> createState() => _AnnotationCanvasPageState();
}

class _AnnotationCanvasPageState extends ConsumerState<AnnotationCanvasPage> {
  late Future<AssessmentDetailModel> _assessmentFuture;
  late Future<List<MediaModel>> _mediaFuture;
  late Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    if (widget.groundTruth != null) {
      _assessmentFuture = ref.read(adminRepositoryProvider).getAssessmentById(widget.groundTruth!.assessmentId);
      _mediaFuture = ref.read(adminRepositoryProvider).getMedia();
      _tokenFuture = ref.read(secureStorageServiceProvider).getAccessToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateModel = ref.watch(canvasStateProvider);
    final isSaving = stateModel.currentState == CanvasState.saving;

    if (widget.groundTruth == null) {
      return const Scaffold(body: Center(child: Text('Referans veri eksik.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşaretleme Ekranı'),
      ),
      body: FutureBuilder(
        future: _assessmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Değerlendirme yüklenirken hata: ${snapshot.error}'));
          }

          final assessment = snapshot.data as AssessmentDetailModel;
          
          return FutureBuilder(
            future: _mediaFuture,
            builder: (context, mediaSnapshot) {
              if (mediaSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (mediaSnapshot.hasError) {
                return Center(child: Text('Medya listesi yüklenirken hata: ${mediaSnapshot.error}'));
              }
              
              final allMedia = mediaSnapshot.data ?? [];
              final mediaList = allMedia.where((m) => m.id == assessment.mediaId).toList();
              if (mediaList.isEmpty) {
                 return const Center(child: Text('Medya bulunamadı'));
              }
              final media = mediaList.first;

              return FutureBuilder<String?>(
                future: _tokenFuture,
                builder: (context, tokenSnapshot) {
                  if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final token = tokenSnapshot.data ?? '';
                  final baseUrl = EnvironmentConfig.baseUrl;
                  final imageUrl = '$baseUrl/media/${media.id}/thumbnail';
                  
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: CanvasToolbar(groundTruthId: widget.groundTruthId),
                            ),
                            Expanded(
                              child: InteractiveCanvasWidget(
                                groundTruthId: widget.groundTruthId,
                                imageUrl: imageUrl,
                                mediaWidth: media.width?.toDouble() ?? 800.0,
                                mediaHeight: media.height?.toDouble() ?? 600.0,
                                headers: {'Authorization': 'Bearer $token'},
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
              );
            }
          );
        },
      ),
    );
  }
}
