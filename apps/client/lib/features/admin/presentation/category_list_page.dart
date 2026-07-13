import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_providers.dart';

class CategoryListPage extends ConsumerWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kategoriler')),
      body: state.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final c = categories[index];
            String nameTr = c.name == 'FaceSwap' ? 'Yüz Değiştirme (FaceSwap)' : c.name;
            String descTr = c.description == 'Replacing one person\'s face with another (deepfake)' 
                ? 'Bir kişinin yüzünü başka bir yüzle değiştirme (deepfake)' : c.description;
            return ListTile(
              title: Text(nameTr),
              subtitle: Text(descTr),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
