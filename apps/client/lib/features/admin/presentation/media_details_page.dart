import 'package:flutter/material.dart';
import '../models/media_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/config/environment_config.dart';
import '../data/admin_data_source.dart';

class MediaDetailsPage extends ConsumerStatefulWidget {
  final MediaModel initialMedia;

  const MediaDetailsPage({super.key, required this.initialMedia});

  @override
  ConsumerState<MediaDetailsPage> createState() => _MediaDetailsPageState();
}

class _MediaDetailsPageState extends ConsumerState<MediaDetailsPage> {
  late MediaModel media;
  bool _isReprocessing = false;
  late AdminDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    media = widget.initialMedia;
    
    // Quick DI setup for MVP (in production use Riverpod/GetIt)
    final dio = Dio(BaseOptions(baseUrl: EnvironmentConfig.baseUrl));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(secureStorageServiceProvider).getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    _dataSource = AdminDataSource(dio);
  }

  Future<void> _reprocess() async {
    setState(() {
      _isReprocessing = true;
    });
    try {
      final updatedMedia = await _dataSource.reprocessMedia(media.id);
      setState(() {
        media = updatedMedia;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yeniden işleme başarıyla başlatıldı')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yeniden işlenemedi: $e')));
      }
    } finally {
      setState(() {
        _isReprocessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medya Detayları')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.thumbnailPath != null) ...[
              FutureBuilder<String?>(
                future: ref.read(secureStorageServiceProvider).getAccessToken(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return Image.network(
                    '${EnvironmentConfig.baseUrl}/media/${media.id}/thumbnail',
                    headers: {'Authorization': 'Bearer ${snapshot.data}'},
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 100),
                  );
                }
              ),
              const SizedBox(height: 16),
            ],
            Text('ID: ${media.id}', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 16),
            _buildDetailRow('Original File Name', media.originalFileName),
            _buildDetailRow('MIME Type', media.mimeType),
            _buildDetailRow('Extension', media.extension),
            _buildDetailRow('File Size', '${(media.fileSize / 1024 / 1024).toStringAsFixed(2)} MB'),
            _buildDetailRow('Storage Path', media.storagePath),
            _buildDetailRow('SHA-256 Checksum', media.checksum),
            _buildDetailRow('Uploaded At', media.uploadedAt.toLocal().toString()),
            _buildDetailRow('Uploaded By (User ID)', media.uploadedByUserId),
            _buildDetailRow('Status', media.status),
            
            if (media.width != null) _buildDetailRow('Width', media.width.toString()),
            if (media.height != null) _buildDetailRow('Height', media.height.toString()),
            if (media.duration != null) _buildDetailRow('Duration', '${media.duration!.toStringAsFixed(2)} sec'),
            if (media.processingError != null) _buildDetailRow('Processing Error', media.processingError!),

            if (media.status == 'Failed') ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isReprocessing ? null : _reprocess,
                icon: _isReprocessing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh),
                label: const Text('İşlemi Yeniden Dene'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              )
            ],
            
            if (media.status == 'Processed' || media.status == 'Ready') ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final String? question = await showDialog<String>(
                    context: context,
                    builder: (ctx) {
                      final controller = TextEditingController(text: 'Is this media real or manipulated?');
                      return AlertDialog(
                        title: const Text('Değerlendirme Oluştur'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(labelText: 'Soru'),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('İptal')),
                          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Oluştur')),
                        ],
                      );
                    },
                  );
                  if (question != null && question.isNotEmpty && mounted) {
                    try {
                      await _dataSource.createAssessment(media.id, question);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Değerlendirme oluşturuldu! Değerlendirmeler menüsüne gidin.')));
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Başarısız: $e')));
                      }
                    }
                  }
                },
                icon: const Icon(Icons.assessment),
                label: const Text('Değerlendirme Oluştur'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
