import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/training_session_notifier.dart';

import 'package:url_launcher/url_launcher.dart';

class TrainingSessionConfigurationPage extends ConsumerStatefulWidget {
  final String packId;

  const TrainingSessionConfigurationPage({super.key, required this.packId});

  @override
  ConsumerState<TrainingSessionConfigurationPage> createState() => _TrainingSessionConfigurationPageState();
}

class _TrainingSessionConfigurationPageState extends ConsumerState<TrainingSessionConfigurationPage> {
  final _timeLimitController = TextEditingController();
  bool _randomQuestionOrder = false;
  bool _allowRetry = false;
  bool _showImmediateFeedback = true;
  bool _leaderboardEnabled = false;
  bool _autoAdvance = false;
  bool _autoJoinStudent = false;
  final _studentNicknameController = TextEditingController();

  @override
  void dispose() {
    _timeLimitController.dispose();
    _studentNicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TrainingSessionState>(
      trainingSessionNotifierProvider,
      (previous, next) {
        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
          );
        } else if (next.currentSession != null && 
                   next.loadingState == SessionLoadingState.idle && 
                   previous?.loadingState == SessionLoadingState.submitting) {
          
          if (_autoJoinStudent && _studentNicknameController.text.isNotEmpty) {
            final origin = Uri.base.origin;
            final urlString = '$origin/#/student/join?code=${next.currentSession!.joinCode}&nickname=${_studentNicknameController.text}';
            launchUrl(Uri.parse(urlString), webOnlyWindowName: '_blank');
          }
          
          context.go('/training/sessions/${next.currentSession!.id}/monitor');
        }
      },
    );

    final state = ref.watch(trainingSessionNotifierProvider);
    final notifier = ref.read(trainingSessionNotifierProvider.notifier);

    // Development mode check
    const isDev = bool.fromEnvironment('dart.vm.product') == false;

    return Scaffold(
      appBar: AppBar(title: const Text('Oturumu Yapılandır')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _timeLimitController,
            decoration: const InputDecoration(labelText: 'Süre Sınırı (Dakika, İsteğe Bağlı)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Rastgele Soru Sırası'),
            value: _randomQuestionOrder,
            onChanged: (v) => setState(() => _randomQuestionOrder = v),
          ),
          SwitchListTile(
            title: const Text('Yeniden Denemeye İzin Ver'),
            value: _allowRetry,
            onChanged: (v) => setState(() => _allowRetry = v),
          ),
          SwitchListTile(
            title: const Text('Anında Geri Bildirim Göster'),
            value: _showImmediateFeedback,
            onChanged: (v) => setState(() => _showImmediateFeedback = v),
          ),
          SwitchListTile(
            title: const Text('Liderlik Tablosunu Etkinleştir'),
            value: _leaderboardEnabled,
            onChanged: (v) => setState(() => _leaderboardEnabled = v),
          ),
          SwitchListTile(
            title: const Text('Otomatik İlerle (Auto Advance)'),
            value: _autoAdvance,
            onChanged: (v) => setState(() => _autoAdvance = v),
          ),
          if (isDev) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Geliştirici Araçları', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ),
            SwitchListTile(
              title: const Text('Öğrenci Sekmesini Otomatik Aç (Auto-Join)'),
              value: _autoJoinStudent,
              onChanged: (v) => setState(() => _autoJoinStudent = v),
              activeColor: Colors.deepPurple,
            ),
            if (_autoJoinStudent)
              TextField(
                controller: _studentNicknameController,
                decoration: const InputDecoration(
                  labelText: 'Öğrenci Nickname (Development)',
                  hintText: 'student1',
                  border: OutlineInputBorder(),
                ),
              ),
            const Divider(),
          ],
          const SizedBox(height: 32),
          if (state.error != null)
            Text(state.error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: state.loadingState == SessionLoadingState.submitting
                ? null
                : () {
                    notifier.createSession(
                      packId: widget.packId,
                      timeLimitMinutes: int.tryParse(_timeLimitController.text),
                      randomQuestionOrder: _randomQuestionOrder,
                      allowRetry: _allowRetry,
                      showImmediateFeedback: _showImmediateFeedback,
                      leaderboardEnabled: _leaderboardEnabled,
                      autoAdvance: _autoAdvance,
                      devStudentNickname: isDev && _autoJoinStudent ? _studentNicknameController.text : null,
                    );
                  },
            child: state.loadingState == SessionLoadingState.submitting
                ? const CircularProgressIndicator()
                : const Text('Oturum Oluştur'),
          ),
        ],
      ),
    );
  }
}
