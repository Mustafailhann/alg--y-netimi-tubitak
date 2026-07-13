import 'package:flutter/material.dart';

class SearchToolbar extends StatefulWidget {
  final String? initialKeyword;
  final ValueChanged<String> onSearch;
  final VoidCallback onFilterTap;

  const SearchToolbar({
    super.key,
    this.initialKeyword,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  State<SearchToolbar> createState() => _SearchToolbarState();
}

class _SearchToolbarState extends State<SearchToolbar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKeyword);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    widget.onSearch(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _submitSearch();
                  },
                ),
              ),
              onSubmitted: (_) => _submitSearch(),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: widget.onFilterTap,
            tooltip: 'Filtrele',
          ),
        ],
      ),
    );
  }
}
