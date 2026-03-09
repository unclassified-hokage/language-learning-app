import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/scenario.dart';

class ScenarioSelectScreen extends StatelessWidget {
  const ScenarioSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const BackButton(color: AppColors.textSecondary),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$greeting! ☀️',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 8),
                      Text(
                        'What are you\ndoing today?',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                      ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideX(
                            begin: -0.1,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 12),
                      Text(
                        'Pick one — we\'ll prep you in 5 minutes',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Scenario grid ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scenario = ScenarioData.all[index];
                  return _ScenarioCard(
                    scenario: scenario,
                    index: index,
                    onTap: () => context.push(
                      '/scenarios/flashcards',
                      extra: scenario,
                    ),
                  );
                },
                childCount: ScenarioData.all.length,
              ),
            ),
          ),

          // ── "Nothing special" option ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(
                    color: AppColors.textMuted.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Nothing special today'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final Scenario scenario;
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scenario.accentColor.withOpacity(0.25),
                scenario.accentColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: scenario.accentColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Emoji + CEFR badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      scenario.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: scenario.accentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        scenario.cefrLevel,
                        style: TextStyle(
                          color: scenario.accentColor.withRed(255),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                // Title + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scenario.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }
}
