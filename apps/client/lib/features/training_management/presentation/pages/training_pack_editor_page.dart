import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/training_pack_editor_notifier.dart';
import '../providers/training_pack_items_notifier.dart';
import '../providers/training_library_notifier.dart';
import '../../domain/models/training_pack.dart';

class TrainingPackEditorPage extends ConsumerStatefulWidget {
  final String? packId; // null means new

  const TrainingPackEditorPage({super.key, this.packId});

  @override
  ConsumerState<TrainingPackEditorPage> createState() => _TrainingPackEditorPageState();
}

class _TrainingPackEditorPageState extends ConsumerState<TrainingPackEditorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.packId != null) {
      Future.microtask(() {
        ref.read(trainingPackEditorNotifierProvider.notifier).loadPack(widget.packId!);
        ref.read(trainingPackItemsNotifierProvider.notifier).loadItems(widget.packId!);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TrainingPackEditorState>(
      trainingPackEditorNotifierProvider,
      (previous, next) {
        if (next.isSaved && previous?.isSaved == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kayıt başarılı!')),
          );
          // Navigate back to the list page to see the new/updated pack
          context.go('/training/packs');
        }
        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
          );
        }
      },
    );

    ref.listen<TrainingPackItemsState>(
      trainingPackItemsNotifierProvider,
      (previous, next) {
        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
          );
        }
      },
    );

    final state = ref.watch(trainingPackEditorNotifierProvider);
    final notifier = ref.read(trainingPackEditorNotifierProvider.notifier);

    // Sync controllers if data loaded
    if (state.pack != null && _titleController.text.isEmpty) {
      _titleController.text = state.pack!.title;
      _durationController.text = state.pack!.estimatedDuration?.toString() ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packId == null ? 'Eğitim Paketi Oluştur' : 'Eğitim Paketini Düzenle'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ayarlar'),
            Tab(text: 'İçerikler'),
            Tab(text: 'Önizleme'),
          ],
        ),
        actions: [
          if (widget.packId != null && state.pack != null && state.pack!.status == TrainingPackStatus.published)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Canlı Oturum Başlat',
              onPressed: () {
                context.go('/training/packs/${widget.packId}/sessions/new');
              },
            ),
          if (widget.packId != null && state.pack != null && state.pack!.status != TrainingPackStatus.published)
            IconButton(
              icon: const Icon(Icons.publish),
              tooltip: 'Yayınla',
              onPressed: () {
                notifier.publishPack();
              },
            ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Kaydet',
            onPressed: () {
              notifier.savePack(
                _titleController.text,
                int.tryParse(_durationController.text),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSettingsTab(state),
          _buildItemsTab(state),
          _buildPreviewTab(state),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(TrainingPackEditorState state) {
    if (state.loadingState == EditorLoadingState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Başlık'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Tahmini Süre (dk)'),
            keyboardType: TextInputType.number,
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsTab(TrainingPackEditorState state) {
    if (widget.packId == null) {
      return const Center(child: Text('İçerik eklemek için önce paketi kaydedin.'));
    }
    final itemsState = ref.watch(trainingPackItemsNotifierProvider);
    if (itemsState.loadingState == ItemsLoadingState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: itemsState.items.isEmpty
              ? const Center(child: Text('Henüz içerik eklenmedi.'))
              : ListView.builder(
                  itemCount: itemsState.items.length,
                  itemBuilder: (context, index) {
                    final item = itemsState.items[index];
                    return ListTile(
                      title: Text(item.libraryItemTitle),
                      subtitle: Text(item.libraryItemMediaType),
                      trailing: (state.pack?.status == TrainingPackStatus.draft) ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ref.read(trainingPackItemsNotifierProvider.notifier).removeItem(widget.packId!, item.id, state.pack!.version);
                          ref.read(trainingPackEditorNotifierProvider.notifier).loadPack(widget.packId!);
                        },
                      ) : null,
                    );
                  },
                ),
        ),
        if (state.pack?.status == TrainingPackStatus.draft) Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Kütüphaneden İçerik Ekle'),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => _LibraryPickerBottomSheet(
                  packId: widget.packId!,
                  packVersion: state.pack!.version,
                ),
              );
            },
          ),
        ) else Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text('Yayınlanmış paketlere içerik eklenemez veya çıkarılamaz.', style: TextStyle(fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }

  Widget _buildPreviewTab(TrainingPackEditorState state) {
    if (state.pack == null) {
      return const Center(child: Text('Henüz önizlenecek bir şey yok.'));
    }
    final itemsState = ref.watch(trainingPackItemsNotifierProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(state.pack!.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Durum: ${state.pack!.status.name.toUpperCase()}'),
        const SizedBox(height: 8),
        Text('Süre: ${state.pack!.estimatedDuration ?? 0} dk'),
        const SizedBox(height: 24),
        Text('İçerikler (${itemsState.items.length})', style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        ...itemsState.items.map((item) => ListTile(
          leading: CircleAvatar(child: Text('${item.orderIndex + 1}')),
          title: Text(item.libraryItemTitle),
          subtitle: Text(item.libraryItemMediaType),
        )).toList(),
      ],
    );
  }
}

class _LibraryPickerBottomSheet extends ConsumerWidget {
  final String packId;
  final String packVersion;

  const _LibraryPickerBottomSheet({required this.packId, required this.packVersion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingLibraryNotifierProvider);
    final notifier = ref.read(trainingLibraryNotifierProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('İçerik Seç', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          if (state.loadingState == LibraryLoadingState.initial)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.items.isEmpty)
            const Expanded(child: Center(child: Text('Kütüphanede içerik bulunamadı.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.video_library),
                      title: Text(item.title),
                      subtitle: Text('Tür: ${item.mediaType}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () async {
                          await ref.read(trainingPackItemsNotifierProvider.notifier).addItem(packId, item.id, packVersion);
                          ref.read(trainingPackEditorNotifierProvider.notifier).loadPack(packId);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
