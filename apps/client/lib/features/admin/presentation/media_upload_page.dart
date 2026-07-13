import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../data/admin_data_source.dart';
import '../../../core/network/api_client.dart';

class MediaUploadPage extends ConsumerStatefulWidget {
  const MediaUploadPage({super.key});

  @override
  ConsumerState<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends ConsumerState<MediaUploadPage> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String _progressText = '';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'mp4'],
      withData: kIsWeb,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.single;
        _progressText = '';
      });
    }
  }

  Future<void> _upload() async {
    if (_selectedFile == null) return;

    setState(() { 
      _isUploading = true; 
      _progressText = '0%';
    });

    try {
      final dio = ref.read(dioProvider);
      final adminApi = AdminDataSource(dio);
      
      await adminApi.uploadMedia(
        kIsWeb ? '' : (_selectedFile!.path ?? ''), 
        bytes: _selectedFile!.bytes,
        filename: _selectedFile!.name,
        onSendProgress: (count, total) {
          if (total != -1) {
            final percentage = ((count / total) * 100).toInt();
            setState(() {
              _progressText = '$percentage%';
            });
          }
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yükleme başarılı!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yükleme başarısız: $e')),
      );
    } finally {
      if (mounted) {
        setState(() { _isUploading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medya Yükle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedFile != null)
              Text('Seçilen: ${_selectedFile!.name}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _pickFile,
              child: const Text('Dosya Seç'),
            ),
            const SizedBox(height: 20),
            if (_isUploading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(_progressText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
            if (!_isUploading && _selectedFile != null)
              ElevatedButton(
                onPressed: _upload,
                child: const Text('Yükle'),
              ),
          ],
        ),
      ),
    );
  }
}
