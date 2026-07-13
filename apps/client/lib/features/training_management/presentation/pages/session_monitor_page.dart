import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_monitor_notifier.dart';
import '../../domain/models/training_session.dart';

class SessionMonitorPage extends ConsumerStatefulWidget {
  final String sessionId;

  const SessionMonitorPage({super.key, required this.sessionId});

  @override
  ConsumerState<SessionMonitorPage> createState() => _SessionMonitorPageState();
}

class _SessionMonitorPageState extends ConsumerState<SessionMonitorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sessionMonitorNotifierProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionMonitorNotifierProvider);
    final notifier = ref.read(sessionMonitorNotifierProvider.notifier);

    if (state.loadingState == MonitorLoadingState.initial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null && state.session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Oturum Yöneticisi')),
        body: Center(child: Text(state.error!, style: const TextStyle(color: Colors.red))),
      );
    }

    final session = state.session!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oturum Yöneticisi'),
        actions: [
          if (session.status == TrainingSessionStatus.created)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: notifier.startSession,
              tooltip: 'Oturumu Başlat',
            ),
          if (session.status == TrainingSessionStatus.active) ...[
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () async {
                await notifier.nextQuestion();
              },
              tooltip: 'Sonraki Soru',
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: notifier.completeSession,
              tooltip: 'Oturumu Bitir',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn('Katılım Kodu', session.joinCode),
                _StatColumn('Status', session.status.name.toUpperCase()),
                _StatColumn('Participants', '${session.participantCount}'),
              ],
            ),
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: state.participants.length,
              itemBuilder: (context, index) {
                final participant = state.participants[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(participant.studentIdentifier),
                  subtitle: Text('Puan: ${participant.score} • İlerleme: %${participant.progressPercentage}'),
                  trailing: Icon(
                    Icons.circle,
                    color: participant.connectionStatus.name == 'connected' ? Colors.green : Colors.red,
                    size: 12,
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

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
