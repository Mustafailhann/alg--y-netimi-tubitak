import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/training_pack_list_notifier.dart';
import '../../domain/models/training_pack.dart';
import '../widgets/status_chip.dart';
import '../widgets/pagination_bar.dart';

class TrainingPackListPage extends ConsumerWidget {
  const TrainingPackListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingPackListNotifierProvider);
    final notifier = ref.read(trainingPackListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitim Paketlerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/training/packs/new');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: _buildBody(state, notifier),
          ),
          if (state.loadingState != ListLoadingState.initial)
            PaginationBar(
              currentPage: state.currentPage,
              hasReachedMax: state.hasReachedMax,
              isLoading: state.loadingState == ListLoadingState.paginating || state.loadingState == ListLoadingState.refreshing,
              onNext: notifier.loadNextPage,
              onRefresh: notifier.refresh,
            ),
        ],
      ),
    );
  }

  Widget _buildBody(TrainingPackListState state, TrainingPackListNotifier notifier) {
    if (state.loadingState == ListLoadingState.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.packs.isEmpty) {
      return const Center(child: Text('Henüz bir eğitim paketi bulunmuyor. Yeni bir tane oluşturun!'));
    }

    return ListView.builder(
      itemCount: state.packs.length,
      itemBuilder: (context, index) {
        final pack = state.packs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(pack.title),
            subtitle: Text('${pack.itemCount} İçerik • ${pack.estimatedDuration ?? 0} dk'),
            trailing: _buildStatusChip(pack.status),
            onTap: () {
              context.go('/training/packs/${pack.id}/edit');
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(TrainingPackStatus status) {
    switch (status) {
      case TrainingPackStatus.draft:
        return const StatusChip(label: 'Taslak', color: Colors.orange);
      case TrainingPackStatus.published:
        return const StatusChip(label: 'Yayında', color: Colors.green);
      case TrainingPackStatus.archived:
        return const StatusChip(label: 'Arşivlendi', color: Colors.grey);
    }
  }
}


