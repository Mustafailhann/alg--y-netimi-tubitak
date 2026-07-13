import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentMissionHubScreen extends StatelessWidget {
  const StudentMissionHubScreen({super.key});

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.secondary,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dedektif Alex', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Seviye 5 Araştırmacı', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildStatBadge(context, Icons.local_fire_department, '5 Days', Colors.orange),
              const SizedBox(width: 12),
              _buildStatBadge(context, Icons.star, '1,250 XP', Colors.amber),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDailyMissions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Günlük Görevler', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildMissionCard(context, 'Identify 3 Deepfakes', 3, 3, true),
        const SizedBox(height: 12),
        _buildMissionCard(context, 'Score 90% Accuracy', 1, 0, false),
      ],
    );
  }

  Widget _buildMissionCard(BuildContext context, String title, int current, int total, bool isCompleted) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: isCompleted ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Row(
        children: [
          Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: isCompleted ? Colors.green : Colors.grey, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: current / total,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? Colors.green : theme.colorScheme.secondary),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text('$current / $total', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildJoinSessionAction(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00A896), Color(0xFF028090)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_scanner, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text('Canlı Eğitime Katıl', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Başlamak için öğretmeninizden aldığınız kodu girin', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/student/join'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF00A896),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Kodu Gir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildTopBar(context),
                const SizedBox(height: 32),
                _buildJoinSessionAction(context),
                const SizedBox(height: 48),
                _buildDailyMissions(context),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.go('/student/results/mock'),
                  child: const Text('Örnek Sonuç Ekranını Gör'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
