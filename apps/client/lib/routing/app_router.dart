import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../features/splash/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/home_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/annotation/presentation/annotation_detail_page.dart';
import '../features/annotation/presentation/ground_truth_detail_page.dart';
import '../features/admin/models/assessment_model.dart';
import '../features/annotation/presentation/canvas/annotation_canvas_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/admin/models/media_model.dart';
import '../features/admin/presentation/media_list_page.dart';
import '../features/admin/presentation/media_upload_page.dart';
import '../features/admin/presentation/media_details_page.dart';
import '../features/admin/presentation/assessment_list_page.dart';
import '../features/admin/presentation/category_list_page.dart';
import '../features/annotation/presentation/ground_truth_list_page.dart';
import '../features/training_management/presentation/pages/training_library_page.dart';
import '../features/training_management/presentation/pages/training_pack_list_page.dart';
import '../features/training_management/presentation/pages/training_pack_editor_page.dart';
import '../features/training_management/presentation/pages/training_session_configuration_page.dart';
import '../features/training_management/presentation/pages/session_monitor_page.dart';
import '../features/student_experience/presentation/screens/join_session_screen.dart';
import '../features/student_experience/presentation/screens/student_session_screen.dart';
import '../features/student_experience/presentation/screens/student_mission_hub_screen.dart';
import '../features/student_experience/presentation/screens/student_results_screen.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // --- Student Routes (Bypasses Admin Shell & Auth) ---
      GoRoute(
        path: '/student/hub',
        builder: (context, state) => const StudentMissionHubScreen(),
      ),
      GoRoute(
        path: '/student/join',
        builder: (context, state) => const JoinSessionScreen(),
      ),
      GoRoute(
        path: '/student/results/mock',
        builder: (context, state) => const StudentResultsScreen(),
      ),
      GoRoute(
        path: '/student/session/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StudentSessionScreen(sessionId: id);
        },
      ),
      // --- Admin Shell ---
      ShellRoute(
        builder: (context, state, child) => Theme(
          data: AppTheme.adminTheme(),
          child: HomePage(child: child),
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/media',
            builder: (context, state) => const MediaListPage(),
          ),
          GoRoute(
            path: '/media/upload',
            builder: (context, state) => const MediaUploadPage(),
          ),
          GoRoute(
            path: '/media/:id',
            builder: (context, state) {
              final media = state.extra as MediaModel;
              return MediaDetailsPage(initialMedia: media);
            },
          ),
          GoRoute(
            path: '/assessments',
            builder: (context, state) => const AssessmentListPage(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoryListPage(),
          ),
          GoRoute(
            path: '/groundtruth',
            builder: (context, state) => const GroundTruthListPage(),
          ),
          GoRoute(
            path: '/groundtruth/:id',
            builder: (context, state) {
              final groundTruth = state.extra as GroundTruthModel;
              return GroundTruthDetailPage(groundTruth: groundTruth);
            },
          ),
          GoRoute(
            path: '/groundtruth/:id/canvas',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final groundTruth = state.extra as GroundTruthModel?;
              return Theme(
                data: AppTheme.forensicsTheme(),
                child: AnnotationCanvasPage(groundTruthId: id, groundTruth: groundTruth),
              );
            },
          ),
          GoRoute(
            path: '/annotations/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AnnotationDetailPage(annotationId: id);
            },
          ),
          GoRoute(
            path: '/training/library',
            builder: (context, state) => const TrainingLibraryPage(),
          ),
          GoRoute(
            path: '/training/packs',
            builder: (context, state) => const TrainingPackListPage(),
          ),
          GoRoute(
            path: '/training/packs/new',
            builder: (context, state) => const TrainingPackEditorPage(),
          ),
          GoRoute(
            path: '/training/packs/:id/edit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TrainingPackEditorPage(packId: id);
            },
          ),
          GoRoute(
            path: '/training/packs/:id/sessions/new',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TrainingSessionConfigurationPage(packId: id);
            },
          ),
          GoRoute(
            path: '/training/sessions/:id/monitor',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SessionMonitorPage(sessionId: id);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isStudentRoute = state.uri.path.startsWith('/student');
      if (isStudentRoute) {
        return null; // Bypasses admin auth
      }

      final authState = ref.read(authProvider);
      
      final isSplash = state.uri.path == '/splash';
      final isLoggingIn = state.uri.path == '/login';

      switch (authState) {
        case AuthState.initial:
          return isSplash ? null : '/splash';
        case AuthState.unauthenticated:
          return isLoggingIn ? null : '/login';
        case AuthState.authenticated:
          return isLoggingIn || isSplash ? '/dashboard' : null;
      }
    },
  );
});
