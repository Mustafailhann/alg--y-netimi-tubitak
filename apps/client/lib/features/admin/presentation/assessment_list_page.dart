import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_providers.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/config/environment_config.dart';

class AssessmentListPage extends ConsumerWidget {
  const AssessmentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Değerlendirmeler')),
      body: state.when(
        data: (assessments) {
          if (assessments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Değerlendirme bulunamadı.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/media'),
                    child: const Text('Değerlendirme Oluşturmak İçin Medyaya Git'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final a = assessments[index];
              return ListTile(
                title: Text(a.question),
                subtitle: Text('Durum: ${a.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (a.status == 'Draft')
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.orange),
                        tooltip: 'Hazır Olarak İşaretle',
                        onPressed: () async {
                          try {
                            await ref.read(adminRepositoryProvider).markAssessmentReady(a.id);
                            ref.invalidate(assessmentsProvider);
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
                    if (a.status == 'Ready')
                      IconButton(
                        icon: const Icon(Icons.publish, color: Colors.green),
                        tooltip: 'Yayınla',
                        onPressed: () async {
                          try {
                            await ref.read(adminRepositoryProvider).publishAssessment(a.id);
                            ref.invalidate(assessmentsProvider);
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
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () async {
                  try {
                    final details = await ref.read(adminRepositoryProvider).getAssessmentById(a.id);
                    if (!context.mounted) return;
                    
                    if (details.groundTruth != null) {
                      context.push('/groundtruth/${details.groundTruth!.id}', extra: details.groundTruth);
                    } else {
                      final token = await ref.read(secureStorageServiceProvider).getAccessToken();
                      final baseUrl = EnvironmentConfig.baseUrl;
                      final imageUrl = '$baseUrl/media/${a.mediaId}/thumbnail';
                      
                      if (!context.mounted) return;
                      final int? judgment = await showDialog<int>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Referans Veri Oluştur'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                imageUrl,
                                height: 200,
                                headers: {'Authorization': 'Bearer $token'},
                                errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50),
                              ),
                              const SizedBox(height: 16),
                              const Text('Bu medya Gerçek mi yoksa Müdahaleli mi?'),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, 0), child: const Text('Gerçek')),
                            TextButton(onPressed: () => Navigator.pop(ctx, 1), child: const Text('Müdahaleli')),
                          ],
                        ),
                      );
                      if (judgment != null && context.mounted) {
                        String? categoryId;
                        
                        // If Manipulated, we MUST provide a category according to backend validation
                        if (judgment == 1) {
                          try {
                            final categories = await ref.read(adminRepositoryProvider).getCategories();
                            if (!context.mounted) return;
                            
                            categoryId = await showDialog<String>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Kategori Seç'),
                                children: categories.map((c) => SimpleDialogOption(
                                  onPressed: () => Navigator.pop(ctx, c.id),
                                  child: Text(c.name),
                                )).toList(),
                              ),
                            );
                            
                            // User cancelled the category selection dialog
                            if (categoryId == null) return; 
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
                            );
                            return;
                          }
                        }

                        if (!context.mounted) return;
                        final gt = await ref.read(adminRepositoryProvider).createGroundTruth(
                          a.id, judgment, categoryId, 'İlk değerlendirme'
                        );
                        if (context.mounted) {
                          context.push('/groundtruth/${gt.id}/canvas', extra: gt);
                        }
                      }
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Değerlendirme detayları yüklenemedi: $e')),
                    );
                  }
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
