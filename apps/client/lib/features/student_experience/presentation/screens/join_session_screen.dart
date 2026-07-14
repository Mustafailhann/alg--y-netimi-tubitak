import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifiers/student_session_notifier.dart';
import '../notifiers/student_session_state.dart';

class JoinSessionScreen extends ConsumerStatefulWidget {
  final String? initialCode;
  final String? initialNickname;

  const JoinSessionScreen({super.key, this.initialCode, this.initialNickname});

  @override
  ConsumerState<JoinSessionScreen> createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends ConsumerState<JoinSessionScreen> {
  late final TextEditingController _joinCodeController;
  late final TextEditingController _nicknameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _joinCodeController = TextEditingController(text: widget.initialCode);
    _nicknameController = TextEditingController(text: widget.initialNickname);

    // Check if there is an active session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentSessionNotifierProvider.notifier).restoreSession();

      if (widget.initialCode != null && widget.initialCode!.isNotEmpty &&
          widget.initialNickname != null && widget.initialNickname!.isNotEmpty) {
        ref.read(studentSessionNotifierProvider.notifier).joinSession(
          widget.initialCode!.trim(),
          widget.initialNickname!.trim(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentSessionNotifierProvider);

    ref.listen<StudentSessionState>(studentSessionNotifierProvider, (previous, next) {
      if (next.error != null && (previous == null || previous.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      }
      
      if (next.sessionData != null && 
          next.phase != StudentSessionPhase.idle && 
          next.phase != StudentSessionPhase.joining) {
        context.go('/student/session/${next.sessionData!.sessionId}');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Eğitim Oturumuna Katıl')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Öğrenci Portalı', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _joinCodeController,
                      decoration: const InputDecoration(labelText: 'Katılım Kodu', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(labelText: 'Kullanıcı Adı', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(studentSessionNotifierProvider.notifier).joinSession(
                                    _joinCodeController.text.trim(),
                                    _nicknameController.text.trim(),
                                  );
                                }
                              },
                        child: state.isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
                            : const Text('Katıl'),
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
