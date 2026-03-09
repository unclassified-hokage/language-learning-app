import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ───────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
            ),
          ),

          // ── Decorative circles ────────────────────────────────────
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant.withOpacity(0.4),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.12),

                  // Globe icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Text('🌍', style: TextStyle(fontSize: 36)),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.3, curve: Curves.easeOutCubic),

                  const SizedBox(height: 32),

                  // App name
                  Text(
                    'LinguAI',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, curve: Curves.easeOutCubic),

                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    'Makes you fluent,\nnot just addicted.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, curve: Curves.easeOutCubic),

                  const SizedBox(height: 48),

                  // Feature pills
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _FeaturePill('🤖 AI conversation'),
                      _FeaturePill('📖 Grammar explained'),
                      _FeaturePill('🆓 Free forever'),
                      _FeaturePill('✨ No hearts'),
                    ],
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms),

                  const Spacer(),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/language-select'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text(
                        'Start Learning — It\'s Free',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, curve: Curves.easeOutCubic),

                  const SizedBox(height: 16),

                  // Sign in link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: navigate to sign in
                      },
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                      .animate(delay: 900.ms)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;
  const _FeaturePill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
