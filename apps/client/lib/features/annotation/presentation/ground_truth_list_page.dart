import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../admin/models/assessment_model.dart';
import '../../admin/providers/admin_providers.dart';

final groundTruthListProvider = FutureProvider.autoDispose<List<GroundTruthModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final assessments = await repo.getAssessments();
  List<GroundTruthModel> truths = [];
  for (var a in assessments.take(20)) { // limit to avoid excessive API calls
    try {
      final detail = await repo.getAssessmentById(a.id);
      if (detail.groundTruth != null) {
        truths.add(detail.groundTruth!);
      }
    } catch (_) {
      // Ignore single failures
    }
  }
  return truths;
});

class GroundTruthListPage extends ConsumerWidget {
  const GroundTruthListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groundTruthListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Referans Veri Listesi')),
      body: state.when(
        data: (truths) {
          if (truths.isEmpty) {
            return const Center(child: Text('Referans veri bulunamadı.'));
          }
          return ListView.builder(
            itemCount: truths.length,
            itemBuilder: (context, index) {
              final gt = truths[index];
              String judgmentTr = gt.judgment == 'Manipulated' ? 'Müdahaleli' : (gt.judgment == 'Real' ? 'Gerçek' : gt.judgment);
              String reasonTr = gt.reason == 'Initial evaluation' ? 'İlk değerlendirme' : gt.reason;
              return ListTile(
                leading: const Icon(Icons.fact_check),
                title: Text('Referans Veri: ${gt.id}'),
                subtitle: Text('Karar: $judgmentTr | Neden: $reasonTr'),
                onTap: () {
                  context.push('/groundtruth/${gt.id}', extra: gt);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
