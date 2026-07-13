import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../admin/models/assessment_model.dart';
import '../models/annotation_model.dart';
import '../providers/annotation_providers.dart';

import '../../admin/providers/admin_providers.dart';

class GroundTruthDetailPage extends ConsumerWidget {
  final GroundTruthModel groundTruth;

  const GroundTruthDetailPage({super.key, required this.groundTruth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annotationsAsync =
        ref.watch(annotationsByGroundTruthProvider(groundTruth.id));
    final assessmentAsync = ref.watch(assessmentDetailProvider(groundTruth.assessmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referans Veri Detayı'),
        actions: [
            assessmentAsync.when(
              data: (assessment) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (assessment.status == 'Draft')
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: Colors.orange),
                      tooltip: 'Hazır Olarak İşaretle',
                      onPressed: () async {
                        try {
                          await ref.read(adminRepositoryProvider).markAssessmentReady(assessment.id);
                          ref.invalidate(assessmentsProvider);
                          ref.invalidate(assessmentDetailProvider(assessment.id));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hazır Olarak İşaretlendi')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hazır olarak işaretlenemedi: $e')));
                          }
                        }
                      },
                    ),
                  if (assessment.status == 'Ready')
                    IconButton(
                      icon: const Icon(Icons.publish, color: Colors.green),
                      tooltip: 'Yayınla',
                      onPressed: () async {
                        try {
                          await ref.read(adminRepositoryProvider).publishAssessment(assessment.id);
                          ref.invalidate(assessmentsProvider);
                          ref.invalidate(assessmentDetailProvider(assessment.id));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Başarıyla yayınlandı')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yayınlanamadı: $e')));
                          }
                        }
                      },
                    ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            IconButton(
              icon: const Icon(Icons.edit_document),
              tooltip: 'Çizim Ekranını Aç',
              onPressed: () => context.push('/groundtruth/${groundTruth.id}/canvas', extra: groundTruth),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader('Ground Truth Metadata'),
            _DetailRow('ID', groundTruth.id),
            _DetailRow('Assessment ID', groundTruth.assessmentId),
            _DetailRow('Judgment', groundTruth.judgment),
            _DetailRow('Status', groundTruth.status),
            _DetailRow('Reason', groundTruth.reason),
            if (groundTruth.manipulationCategoryId != null)
              _DetailRow('Category ID', groundTruth.manipulationCategoryId!),
            const SizedBox(height: 24),
            const _SectionHeader('Annotations'),
            const SizedBox(height: 8),
            annotationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(
                'İşaretlemeler yüklenemedi: $error',
                style: const TextStyle(color: Colors.red),
              ),
              data: (annotations) => annotations.isEmpty
                  ? const Text('Henüz işaretleme yok.')
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: annotations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) =>
                          _AnnotationCard(annotation: annotations[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

}

class _AnnotationCard extends StatelessWidget {
  final AnnotationModel annotation;

  const _AnnotationCard({required this.annotation});

  @override
  Widget build(BuildContext context) {
    // Produce a brief geometry summary without exposing coordinate arrays verbosely
    final geometrySummary = _buildGeometrySummary(annotation);
    String typeTr = annotation.type == 'Rectangle' ? 'Dikdörtgen' : (annotation.type == 'Polygon' ? 'Çokgen' : (annotation.type == 'Brush' ? 'Fırça' : annotation.type));

    return Card(
      child: ListTile(
        leading: Icon(
          _iconForType(annotation.type),
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(typeTr),
        subtitle: Text(geometrySummary),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/annotations/${annotation.id}'),
      ),
    );
  }

  static IconData _iconForType(String type) {
    switch (type) {
      case 'Brush':
        return Icons.brush;
      case 'Rectangle':
        return Icons.crop_square;
      case 'Polygon':
        return Icons.pentagon;
      default:
        return Icons.category;
    }
  }

  static String _buildGeometrySummary(AnnotationModel annotation) {
    final g = annotation.geometry;
    switch (annotation.type) {
      case 'Rectangle':
        final x = g['x'];
        final y = g['y'];
        final w = g['width'];
        final h = g['height'];
        return 'x:$x  y:$y  $w×$h';
      case 'Polygon':
      case 'Brush':
        final points = g['points'];
        if (points is List) {
          return '${points.length} points';
        }
        return 'Points: —';
      default:
        return 'ID: ${annotation.id}';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
