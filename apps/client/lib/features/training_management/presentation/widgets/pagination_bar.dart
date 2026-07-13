import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback onRefresh;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.hasReachedMax,
    required this.isLoading,
    required this.onNext,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : onRefresh,
          ),
          Text('Sayfa $currentPage'),
          ElevatedButton(
            onPressed: (isLoading || hasReachedMax) ? null : onNext,
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Daha Fazla Yükle'),
          ),
        ],
      ),
    );
  }
}
