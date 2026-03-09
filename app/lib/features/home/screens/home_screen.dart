import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();

  static const _scenarios = [
    _Scenario('☕', 'Café', 'Order your morning coffee', 'café'),
    _Scenario('🍽️', 'Restaurant', 'Book a table, order food', 'restaurant'),
    _Scenario('💼', 'Work', 'Meetings, emails, small talk', 'work'),
    _Scenario('✈️', 'Travel', 'Airports, hotels, directions', 'travel'),
    _Scenario('🛒', 'Shopping', 'Find items, pay, returns', 'shopping'),
    _Scenario('💪', 'Gym', 'Equipment, classes, trainers', 'gym'),
    _Scenario('🏥', 'Doctor', 'Symptoms, appointments', 'doctor'),
    _Scenario('🎓', 'Class', 'Lectures, study groups', 'class'),
    _Scenario('💕', 'Date', 'Small talk, compliments', 'date'),
    _Scenario('🗺️', 'Directions', 'Ask for & give directions', 'directions'),
  ];

  String _getUserName() {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String?;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName.split(' ').first;
    }
    return 'there';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),

          // ── Decorative accent circle ──────────────────────────────
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting()}, ${_getUserName()} 👋',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'LinguAI',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // XP badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.xpGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.xpGold.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⚡', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '0 XP',
                              style: TextStyle(
                                color: AppColors.xpGold,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Sign out
                      GestureDetector(
                        onTap: _signOut,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGlass,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 28),

                // ── Daily prompt ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What are you doing today?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pick a scenario and practise real conversations',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ).animate(delay: 150.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: 20),

                // ── Scenario grid ────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: _scenarios.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (context, i) {
                        final s = _scenarios[i];
                        return _ScenarioCard(
                          scenario: s,
                          index: i,
                          onTap: () {
                            // TODO: navigate to flashcard/conversation
                            // context.go('/scenarios/flashcards', extra: ...)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${s.emoji} ${s.title} coming soon!'),
                                backgroundColor: AppColors.surfaceVariant,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // ── Daily goal bar ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily goal',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '0 / 5 min',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: 0,
                            minHeight: 6,
                            backgroundColor:
                                AppColors.surface.withOpacity(0.8),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Complete a scenario to hit your goal 🎯',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 400.ms).fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Scenario {
  final String emoji;
  final String title;
  final String subtitle;
  final String id;
  const _Scenario(this.emoji, this.title, this.subtitle, this.id);
}

// ── Scenario card widget ──────────────────────────────────────────────────────

class _ScenarioCard extends StatelessWidget {
  final _Scenario scenario;
  final int index;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.scenario,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scenario.emoji, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Text(
                scenario.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                scenario.subtitle,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      )
          .animate(delay: (index * 60).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
    );
  }
}
