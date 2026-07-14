import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class DevelopmentRoleSelector extends ConsumerStatefulWidget {
  const DevelopmentRoleSelector({super.key});

  @override
  ConsumerState<DevelopmentRoleSelector> createState() => _DevelopmentRoleSelectorState();
}

class _DevelopmentRoleSelectorState extends ConsumerState<DevelopmentRoleSelector> {
  bool _isLoading = false;

  Future<void> _devLogin(String role) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).devLogin(role);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('DevLogin Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.developer_mode, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Development Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            ElevatedButton.icon(
              onPressed: () => _devLogin('Administrator'),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Login as Administrator'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _devLogin('Teacher'),
              icon: const Icon(Icons.school),
              label: const Text('Login as Teacher'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _devLogin('Student'),
              icon: const Icon(Icons.person),
              label: const Text('Login as Participant (Student)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
