import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/training_library_notifier.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/search_toolbar.dart';

class TrainingLibraryPage extends ConsumerWidget {
  const TrainingLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingLibraryNotifierProvider);
    final notifier = ref.read(trainingLibraryNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitim Kütüphanesi'),
      ),
      body: Column(
        children: [
          SearchToolbar(
            initialKeyword: state.keyword,
            onSearch: (kw) => notifier.updateFilters(keyword: kw),
            onFilterTap: () {
              // Show filter dialog or bottom sheet
            },
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: _buildBody(state, notifier),
          ),
          if (state.loadingState != LibraryLoadingState.initial)
            PaginationBar(
              currentPage: state.currentPage,
              hasReachedMax: state.hasReachedMax,
              isLoading: state.loadingState == LibraryLoadingState.paginating || state.loadingState == LibraryLoadingState.refreshing,
              onNext: notifier.loadNextPage,
              onRefresh: notifier.refresh,
            ),
        ],
      ),
    );
  }

  Widget _buildBody(TrainingLibraryState state, TrainingLibraryNotifier notifier) {
    if (state.loadingState == LibraryLoadingState.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.items.isEmpty) {
      return const Center(child: Text('Kütüphanede hiçbir içerik bulunamadı.'));
    }

    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(item.title),
            subtitle: Text('Tür: ${item.mediaType} • Yayınlanma Tarihi: ${item.publishedAt.toLocal().toString().split(' ')[0]}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to details
            },
          ),
        );
      },
    );
  }
}


