import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifiers/student_session_notifier.dart';
import '../notifiers/student_session_state.dart';
import '../widgets/student_canvas_widget.dart';
import '../../../annotation/providers/annotation_providers.dart';
import '../../../../core/config/environment_config.dart';
import 'student_results_screen.dart';

class StudentSessionScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const StudentSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<StudentSessionScreen> createState() => _StudentSessionScreenState();
}

class _StudentSessionScreenState extends ConsumerState<StudentSessionScreen> {
  DateTime? _questionStartTime;

  Future<bool> _onWillPop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oturumdan Ayrıl?'),
        content: const Text('Bu oturumdan ayrılmak istediğinize emin misiniz? Mevcut ilerlemenizi kaybedeceksiniz.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('İptal')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Ayrıl')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(studentSessionNotifierProvider.notifier).leaveSession();
      if (context.mounted) context.go('/');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentSessionNotifierProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.sessionData?.joinCode ?? 'Training Session'),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(StudentSessionState state) {
    if (state.error != null && state.phase != StudentSessionPhase.finished) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      );
    }

    switch (state.phase) {
      case StudentSessionPhase.idle:
      case StudentSessionPhase.joining:
        return const Center(child: CircularProgressIndicator());
      case StudentSessionPhase.waiting:
        return _buildLobby(state);
      case StudentSessionPhase.question:
        // Set the timer start for response time calculation
        _questionStartTime ??= DateTime.now();
        return _buildQuestion(state);
      case StudentSessionPhase.drawing:
        return _buildDrawing(state);
      case StudentSessionPhase.submitted:
      case StudentSessionPhase.waitingNext:
        _questionStartTime = null; // reset
        return _buildFeedback(state);
      case StudentSessionPhase.finished:
        return _buildResults(state);
    }
  }

  Widget _buildLobby(StudentSessionState state) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text(
            'Öğretmenin seansı başlatması bekleniyor...',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(StudentSessionState state) {
    final q = state.currentQuestion;
    if (q == null) return const Center(child: CircularProgressIndicator());

    final isImage = q.mediaType == 'Image';
    final baseUrl = EnvironmentConfig.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    var cleanFileUrl = q.fileUrl.replaceAll('\\', '/');
    if (cleanFileUrl.startsWith('/api')) {
      cleanFileUrl = cleanFileUrl.replaceFirst('/api', '');
    }
    if (!cleanFileUrl.startsWith('/')) {
      cleanFileUrl = '/$cleanFileUrl';
    }
    final url = '$baseUrl$cleanFileUrl';

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isImage
                ? Image.network(url, fit: BoxFit.contain)
                : const Center(child: Text('Video oynatıcı henüz eklenmedi')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(q.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      ),
                      onPressed: () {
                        final ms = DateTime.now().difference(_questionStartTime ?? DateTime.now()).inMilliseconds;
                        ref.read(studentSessionNotifierProvider.notifier).submitAnswer('Real', ms);
                      },
                      child: const Text('Gerçek', style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      ),
                      onPressed: () {
                        ref.read(studentSessionNotifierProvider.notifier).selectManipulated();
                      },
                      child: const Text('Müdahale Edilmiş', style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawing(StudentSessionState state) {
    final q = state.currentQuestion;
    if (q == null) return const Center(child: CircularProgressIndicator());

    final baseUrl = EnvironmentConfig.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    var cleanFileUrl = q.fileUrl.replaceAll('\\', '/');
    if (cleanFileUrl.startsWith('/api')) {
      cleanFileUrl = cleanFileUrl.replaceFirst('/api', '');
    }
    if (!cleanFileUrl.startsWith('/')) {
      cleanFileUrl = '/$cleanFileUrl';
    }
    final url = '$baseUrl$cleanFileUrl';

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Müdahaleli alanları işaretleyin ve ardından Gönder butonuna basın.', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: StudentCanvasWidget(
            groundTruthId: q.groundTruthId,
            imageUrl: url,
            mediaWidth: 800, // Ideally retrieved from media
            mediaHeight: 600,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  final ms = DateTime.now().difference(_questionStartTime ?? DateTime.now()).inMilliseconds;
                  final annotations = ref.read(participantAnnotationProvider(widget.sessionId)).valueOrNull ?? [];
                  final annotationId = annotations.isNotEmpty ? annotations.last.id : null;
                  
                  ref.read(studentSessionNotifierProvider.notifier).submitAnswer('Manipulated', ms, annotationId: annotationId);
                },
                child: const Text('Cevabı Gönder', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFeedback(StudentSessionState state) {
    if (state.currentReview != null) {
      final review = state.currentReview!;
      final isCorrect = review.submittedJudgment == review.correctJudgment;
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red, size: 64),
            const SizedBox(height: 24),
            Text(isCorrect ? 'Tebrikler, Doğru Cevap!' : 'Maalesef Yanlış Cevap.', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Sizin Cevabınız: ${review.submittedJudgment == 'Real' ? 'Gerçek' : 'Müdahale Edilmiş'}', style: const TextStyle(fontSize: 18)),
            Text('Doğru Cevap: ${review.correctJudgment == 'Real' ? 'Gerçek' : 'Müdahale Edilmiş'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            Text(state.sessionData?.autoAdvance == true ? 'Sıradaki soruya geçiliyor...' : 'Öğretmenin sonraki soruya geçmesi bekleniyor...', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 24),
          const Text('Cevap Gönderildi!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(state.sessionData?.autoAdvance == true ? 'Sıradaki soruya geçiliyor...' : 'Öğretmenin sonraki soruya geçmesi bekleniyor...', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildResults(StudentSessionState state) {
    return const StudentResultsScreen();
  }
}
