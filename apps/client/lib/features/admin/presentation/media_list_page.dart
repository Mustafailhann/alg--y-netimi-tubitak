import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/environment_config.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../providers/admin_providers.dart';

class MediaListPage extends ConsumerWidget {
  const MediaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Medya')),
      body: state.when(
        data: (media) => ListView.builder(
          itemCount: media.length,
          itemBuilder: (context, index) {
            final m = media[index];
            return ListTile(
              leading: m.thumbnailPath != null ? FutureBuilder<String?>(
                future: ref.read(secureStorageServiceProvider).getAccessToken(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox(width: 50, height: 50, child: CircularProgressIndicator());
                  return Image.network(
                    '${EnvironmentConfig.baseUrl}/media/${m.id}/thumbnail',
                    headers: {'Authorization': 'Bearer ${snapshot.data}'},
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50),
                  );
                }
              ) : const Icon(Icons.insert_drive_file, size: 50),
              title: Text(m.originalFileName),
              subtitle: Text('${m.mimeType} • ${(m.fileSize / 1024 / 1024).toStringAsFixed(2)} MB • Durum: ${m.status}'),
              trailing: Text(m.uploadedAt.toLocal().toString().split(' ')[0]),
              onTap: () {
                context.push('/media/${m.id}', extra: m);
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/media/upload');
          ref.invalidate(mediaProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
