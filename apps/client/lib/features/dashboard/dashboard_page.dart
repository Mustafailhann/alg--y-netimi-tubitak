import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700])),
              ],
            ),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Son Aktiviteler', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary),
                    ),
                    title: Text('Öğrenci #${100 + index} "Deepfake Tespiti" görevini tamamladı'),
                    subtitle: Text('${index * 10} dakika önce'),
                    trailing: Text('Puan: %${95 - index}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmen Analiz Paneli')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Genel Bakış', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'Aktif Oturumlar', '3', Icons.play_circle_fill, Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'Toplam Öğrenci', '124', Icons.people, Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'Ortalama Puan', '82%', Icons.bar_chart, Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'En Zor Değerlendirme', 'Audio Deepfake #2', Icons.warning, Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildActivityList(context)),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hızlı İşlemler', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.add),
                              title: const Text('Eğitim Paketi Oluştur'),
                              onTap: () => context.go('/training/packs/new'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.assessment),
                              title: const Text('Değerlendirmeleri İncele'),
                              onTap: () => context.go('/assessments'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
