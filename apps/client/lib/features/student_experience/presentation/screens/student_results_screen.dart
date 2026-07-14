import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifiers/student_session_notifier.dart';
import '../../data/models/student_dto.dart';
import '../widgets/review_mistake_dialog.dart';

class StudentResultsScreen extends ConsumerWidget {
  const StudentResultsScreen({super.key});

  Widget _buildScoreRing(BuildContext context, String title, int percentage, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percentage / 100.0,
                strokeWidth: 12,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildRewardBadge(BuildContext context, String badgeName, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(badgeName, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(studentSessionNotifierProvider);
    final results = state.results;
    final history = state.history;

    if (state.isLoading || results == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Filter mistakes (wrong judgment or localization failed)
    final mistakes = history?.where((q) {
      final isJudgmentWrong = q.isCorrect == false && q.passedLocalization != false; // wrong class
      final isLocWrong = q.passedLocalization == false;
      return isJudgmentWrong || isLocWrong;
    }).toList() ?? [];

    // Calculate averages
    int avgClassification = 0;
    int avgLocalization = 0;

    if (history != null && history.isNotEmpty) {
      double sumClass = 0;
      double sumLoc = 0;
      int countLoc = 0;
      for (var q in history) {
        sumClass += q.classificationScore ?? 0;
        if (q.localizationScore != null) {
          sumLoc += q.localizationScore!;
          countLoc++;
        }
      }
      avgClassification = (sumClass / history.length).round();
      avgLocalization = countLoc > 0 ? (sumLoc / countLoc).round() : 0;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Görev Tamamlandı!',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tebrikler Dedektif! İşte sonuçların:',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildScoreRing(context, 'Toplam Puan', results.score, theme.colorScheme.secondary),
                        _buildScoreRing(context, 'Sınıflandırma', avgClassification, Colors.green),
                        if (avgLocalization > 0 || mistakes.any((m) => m.passedLocalization == false))
                          _buildScoreRing(context, 'İşaretleme (IoU)', avgLocalization, Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text('Ödüller', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRewardBadge(context, '+${results.score} XP', Icons.star, Colors.amber),
                              if (results.progressPercentage >= 80) ...[
                                const SizedBox(width: 16),
                                _buildRewardBadge(context, 'Keskin Göz', Icons.remove_red_eye, theme.colorScheme.secondary),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    if (mistakes.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hatalarını İncele',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mistakes.length,
                        itemBuilder: (context, index) {
                          final mistake = mistakes[index];
                          final locFailed = mistake.passedLocalization == false;
                          final title = 'Soru ${mistake.questionNumber}';
                          final subtitle = locFailed ? 'Yanlış işaretleme yaptın.' : 'Yanlış karar verdin (${mistake.submittedJudgment}).';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: Icon(Icons.error_outline, color: Colors.red),
                              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(subtitle),
                              trailing: const Text('İncele', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ReviewMistakeDialog(
                                    history: mistake,
                                    sessionId: state.sessionData!.sessionId,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                    ],
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(studentSessionNotifierProvider.notifier).leaveSession();
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          ),
                          child: const Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
