import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/language_select_screen.dart';
import '../../features/onboarding/screens/goal_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/scenarios/screens/scenario_select_screen.dart';
import '../../features/scenarios/screens/flashcard_screen.dart';
import '../../features/scenarios/screens/scenario_complete_screen.dart';
import '../../features/lessons/screens/lesson_screen.dart';
import '../../features/lessons/screens/lesson_complete_screen.dart';
import '../../features/ai_chat/screens/conversation_screen.dart';
import '../../features/vocabulary/screens/vocabulary_review_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../shared/models/scenario.dart';

// Routes that do NOT require authentication
const _publicRoutes = ['/', '/auth', '/language-select', '/goal'];

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final path = state.matchedLocation;

      // Logged-in user hitting the welcome or auth screen → send home
      if (isLoggedIn && (path == '/' || path == '/auth')) {
        return '/home';
      }
      // Not logged-in user hitting a protected route → welcome screen
      if (!isLoggedIn && !_publicRoutes.contains(path)) {
        return '/';
      }
      return null;
    },
    routes: [
      // ── Auth ──────────────────────────────────────────────────────
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) {
          final signIn = state.uri.queryParameters['mode'] == 'signin';
          return AuthScreen(startInSignIn: signIn);
        },
      ),

      // ── Onboarding ────────────────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/language-select',
        name: 'language-select',
        builder: (context, state) => const LanguageSelectScreen(),
      ),
      GoRoute(
        path: '/goal',
        name: 'goal',
        builder: (context, state) => const GoalScreen(),
      ),

      // ── Main app ──────────────────────────────────────────────────
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // ── Scenarios ─────────────────────────────────────────────────
      GoRoute(
        path: '/scenarios',
        name: 'scenarios',
        builder: (context, state) => const ScenarioSelectScreen(),
      ),
      GoRoute(
        path: '/scenarios/flashcards',
        name: 'flashcards',
        builder: (context, state) {
          final scenario = state.extra as Scenario;
          return FlashcardScreen(scenario: scenario);
        },
      ),
      GoRoute(
        path: '/scenarios/complete',
        name: 'scenario-complete',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ScenarioCompleteScreen(
            scenario: args['scenario'] as Scenario,
            score: args['score'] as int,
            timeTaken: args['timeTaken'] as Duration,
          );
        },
      ),

      // ── Lessons ───────────────────────────────────────────────────
      GoRoute(
        path: '/lesson/:lessonId',
        name: 'lesson',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          return LessonScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/lesson-complete',
        name: 'lesson-complete',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return LessonCompleteScreen(
            lessonTitle: args['lessonTitle'] as String,
            xpEarned: args['xpEarned'] as int,
            score: args['score'] as int,
            wordsLearned: (args['wordsLearned'] as List).cast<String>(),
          );
        },
      ),

      // ── AI Conversation ───────────────────────────────────────────
      GoRoute(
        path: '/conversation/:scenario',
        name: 'conversation',
        builder: (context, state) {
          final scenarioId = state.pathParameters['scenario']!;
          return ConversationScreen(scenarioId: scenarioId);
        },
      ),

      // ── Vocabulary Review ─────────────────────────────────────────
      GoRoute(
        path: '/vocabulary-review',
        name: 'vocabulary-review',
        builder: (context, state) => const VocabularyReviewScreen(),
      ),

      // ── Profile ───────────────────────────────────────────────────
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
