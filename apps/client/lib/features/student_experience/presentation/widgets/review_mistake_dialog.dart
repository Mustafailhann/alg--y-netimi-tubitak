import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/student_dto.dart';
import '../../data/providers.dart';
import '../../../annotation/models/annotation_model.dart';
import '../../../annotation/utils/geometry_mapper.dart';
import '../../../../core/config/environment_config.dart';

class ReviewAnnotationPainter extends CustomPainter {
  final List<AnnotationModel> teacherAnnotations;
  final List<AnnotationModel> studentAnnotations;
  final double mediaWidth;
  final double mediaHeight;

  ReviewAnnotationPainter({
    required this.teacherAnnotations,
    required this.studentAnnotations,
    required this.mediaWidth,
    required this.mediaHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // We assume the canvas size matches the media size or is scaled proportionally.

    final teacherPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    
    final teacherBorderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final studentPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final studentBorderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw Teacher annotations
    for (final ann in teacherAnnotations) {
      if (['Polygon', 'Rectangle', 'Brush', 'Çokgen', 'Dikdörtgen', 'Fırça'].contains(ann.type)) {
        final path = GeometryMapper.createPathFromGeometry(ann.geometry);
        if (path != null) {
          if (ann.type == 'Brush' || ann.type == 'Fırça') {
            canvas.drawPath(path, teacherBorderPaint);
          } else {
            canvas.drawPath(path, teacherPaint);
            canvas.drawPath(path, teacherBorderPaint);
          }

          final textSpan = const TextSpan(
            text: 'Manipüle Edilmiş Alan',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black45,
            ),
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          final bounds = path.getBounds();
          double dy = bounds.top - textPainter.height - 4;
          if (dy < 0) dy = bounds.top + 4; 
          textPainter.paint(canvas, Offset(bounds.left, dy));
        }
      }
    }

    // Draw Student annotations
    for (final ann in studentAnnotations) {
      if (['Polygon', 'Rectangle', 'Brush', 'Çokgen', 'Dikdörtgen', 'Fırça'].contains(ann.type)) {
        final path = GeometryMapper.createPathFromGeometry(ann.geometry);
        if (path != null) {
          if (ann.type == 'Brush' || ann.type == 'Fırça') {
            canvas.drawPath(path, studentBorderPaint);
          } else {
            canvas.drawPath(path, studentPaint);
            canvas.drawPath(path, studentBorderPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ReviewAnnotationPainter oldDelegate) {
    return teacherAnnotations != oldDelegate.teacherAnnotations ||
           studentAnnotations != oldDelegate.studentAnnotations;
  }
}

class ReviewMistakeDialog extends ConsumerWidget {
  final QuestionHistoryDto history;
  final String sessionId;

  const ReviewMistakeDialog({
    super.key,
    required this.history,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(studentSessionRepositoryProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Soru ${history.questionNumber} İncelemesi', style: Theme.of(context).textTheme.titleLarge),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder<QuestionReviewDto>(
                future: repository.getQuestionReview(sessionId, history.trainingItemId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Yüklenirken hata oluştu: ${snapshot.error}'));
                  }

                  final reviewData = snapshot.data!;
                  final teacherAnns = reviewData.teacherAnnotations.map((e) => AnnotationModel.fromJson(e as Map<String, dynamic>)).toList();
                  final studentAnns = reviewData.studentAnnotations.map((e) => AnnotationModel.fromJson(e as Map<String, dynamic>)).toList();
                  String url = history.mediaUrl;
                  if (!url.startsWith('http')) {
                    final baseUrl = EnvironmentConfig.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
                    var cleanFileUrl = url.replaceAll('\\', '/');
                    if (cleanFileUrl.startsWith('/api')) {
                      cleanFileUrl = cleanFileUrl.replaceFirst('/api', '');
                    }
                    if (!cleanFileUrl.startsWith('/')) {
                      cleanFileUrl = '/$cleanFileUrl';
                    }
                    url = '$baseUrl$cleanFileUrl';
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRect(
                          child: InteractiveViewer(
                            minScale: 0.1,
                            maxScale: 10,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: reviewData.mediaWidth,
                                  height: reviewData.mediaHeight,
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        url,
                                        width: reviewData.mediaWidth,
                                        height: reviewData.mediaHeight,
                                        fit: BoxFit.fill,
                                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 50)),
                                      ),
                                      Positioned.fill(
                                        child: CustomPaint(
                                          size: Size(reviewData.mediaWidth, reviewData.mediaHeight),
                                          painter: ReviewAnnotationPainter(
                                            teacherAnnotations: teacherAnns,
                                            studentAnnotations: studentAnns,
                                            mediaWidth: reviewData.mediaWidth,
                                            mediaHeight: reviewData.mediaHeight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildClassificationFeedback(context),
                              const SizedBox(height: 24),
                              if (history.correctJudgment == 'Manipulated')
                                _buildLocalizationFeedback(context),
                              if (history.manipulationCategoryName != null) ...[
                                const SizedBox(height: 24),
                                Text('Manipülasyon Türü', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
                                const SizedBox(height: 4),
                                Text(history.manipulationCategoryName!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                              if (history.reason != null && history.reason!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text('Açıklama', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
                                const SizedBox(height: 4),
                                Text(history.reason!, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                              const SizedBox(height: 24),
                              _buildLegend(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationFeedback(BuildContext context) {
    final bool isCorrect = history.isCorrect == true;
    final color = isCorrect ? Colors.green : Colors.red;
    final icon = isCorrect ? Icons.check_circle : Icons.cancel;
    
    String submittedText = history.submittedJudgment == 'Manipulated' ? 'Manipüle' : 'Gerçek';
    String correctText = history.correctJudgment == 'Manipulated' ? 'Manipüle' : 'Gerçek';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sınıflandırma', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text('Sen "$submittedText" dedin.', style: TextStyle(fontSize: 16, color: color.withOpacity(0.8))),
          const SizedBox(height: 4),
          Text('Doğru cevap: $correctText', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLocalizationFeedback(BuildContext context) {
    // Only show if the ground truth is Manipulated
    if (history.correctJudgment != 'Manipulated') return const SizedBox.shrink();

    final bool passed = history.passedLocalization == true;
    final color = passed ? Colors.green : Colors.orange;
    
    final scoreValue = history.localizationScore != null ? (history.localizationScore!).round() : 0;
    final thresholdValue = history.localizationThreshold != null ? (history.localizationThreshold!).round() : 50;

    String problemText = '';
    if (!passed) {
      if (scoreValue == 0) {
        problemText = 'İşaretlediğin alan tamamen yanlış yerde.';
      } else {
        problemText = 'İşaretlediğin alan manipülasyonun yalnızca küçük bir kısmını kapsıyor.';
      }
    } else {
      problemText = 'Tebrikler! Sorunlu alanı çok iyi yakaladın.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('İşaretleme (IoU)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('%$scoreValue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Beklenen: %$thresholdValue+', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            passed ? 'Başarılı: $problemText' : 'Sorun: $problemText',
            style: TextStyle(fontSize: 14, color: color.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('İşaretleme Renkleri', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(width: 16, height: 16, color: Colors.green.withValues(alpha: 0.5)),
            const SizedBox(width: 8),
            const Text('Manipüle Edilmiş Alan (Doğru)'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(width: 16, height: 16, color: Colors.red.withValues(alpha: 0.4)),
            const SizedBox(width: 8),
            const Text('Senin İşaretlemen'),
          ],
        ),
      ],
    );
  }
}
