import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/annotation_model.dart';
import '../providers/annotation_providers.dart';

class AnnotationDetailPage extends ConsumerWidget {
  final String annotationId;

  const AnnotationDetailPage({super.key, required this.annotationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annotationAsync = ref.watch(annotationDetailProvider(annotationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşaretleme Detayı'),
      ),
      body: annotationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Hata: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (annotation) => _AnnotationDetailBody(annotation: annotation),
      ),
    );
  }
}

class _AnnotationDetailBody extends StatelessWidget {
  final AnnotationModel annotation;

  const _AnnotationDetailBody({required this.annotation});

  @override
  Widget build(BuildContext context) {
    // Pretty-print geometry JSON for display
    final geometryJson = const JsonEncoder.withIndent('  ')
        .convert(annotation.geometry);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader('Annotation Metadata'),
          _DetailRow('ID', annotation.id),
          _DetailRow('Type', annotation.type),
          if (annotation.groundTruthId != null)
            _DetailRow('Ground Truth ID', annotation.groundTruthId!),
          if (annotation.answerId != null)
            _DetailRow('Answer ID', annotation.answerId!),
          if (annotation.startSeconds != null)
            _DetailRow('Start (s)', annotation.startSeconds!.toStringAsFixed(3)),
          if (annotation.endSeconds != null)
            _DetailRow('End (s)', annotation.endSeconds!.toStringAsFixed(3)),
          _DetailRow('Created At', annotation.createdAt.toLocal().toString()),
          _DetailRow('Updated At', annotation.updatedAt.toLocal().toString()),
          const SizedBox(height: 16),
          const _SectionHeader('Geometry Data'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              geometryJson,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
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
