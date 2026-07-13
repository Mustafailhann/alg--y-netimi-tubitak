import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../../lib/features/student_experience/presentation/notifiers/student_session_notifier.dart';
import '../../../../lib/features/student_experience/presentation/notifiers/student_session_state.dart';
import '../../../../lib/features/student_experience/data/student_session_repository.dart';
import '../../../../lib/features/student_experience/data/providers.dart';
import '../../../../lib/features/student_experience/domain/participant_token.dart';
import '../../../../lib/core/storage/secure_storage_service.dart';

// Since we mock the repository and storage, we define a simple setup.
class MockStudentSessionRepository extends Mock implements StudentSessionRepository {}
class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late ProviderContainer container;
  late MockStudentSessionRepository mockRepo;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockRepo = MockStudentSessionRepository();
    mockStorage = MockSecureStorageService();
    container = ProviderContainer(
      overrides: [
        studentSessionRepositoryProvider.overrideWithValue(mockRepo),
        secureStorageServiceProvider.overrideWithValue(mockStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Initial state is idle', () {
    final notifier = container.read(studentSessionNotifierProvider.notifier);
    final state = container.read(studentSessionNotifierProvider);
    expect(state.phase, StudentSessionPhase.idle);
  });
}
