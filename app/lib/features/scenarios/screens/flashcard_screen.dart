import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/scenario.dart';

class FlashcardScreen extends StatefulWidget {
  final Scenario scenario;
  const FlashcardScreen({super.key, required this.scenario});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isDragging = false;
  double _dragOffset = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _nextCard() {
    if (_currentIndex < widget.scenario.phrases.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
        _dragOffset = 0;
      });
      _flipController.reset();
    } else {
      // All cards done — go to quiz
      context.pushReplacement(
        '/scenarios/complete',
        extra: {
          'scenario': widget.scenario,
          'score': 100,
          'timeTaken': const Duration(minutes: 4, seconds: 32),
        },
      );
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
        _dragOffset = 0;
      });
      _flipController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final phrase = widget.scenario.phrases[_currentIndex];
    final size = MediaQuery.of(context).size;
    final progress = (_currentIndex + 1) / widget.scenario.phrases.length;

    return Scaffold(
      body: Stack(
        children: [
          // ── Scenario background tint ──────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.scenario.accentColor.withOpacity(0.15),
                  AppColors.background,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      // Progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.scenario.emoji}  ${widget.scenario.title}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.scenario.accentColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_currentIndex + 1}/${widget.scenario.phrases.length}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Tap card to reveal translation',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),

                // ── Flashcard ─────────────────────────────────────
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _flipCard,
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _isDragging = true;
                          _dragOffset += details.delta.dx;
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        if (_dragOffset < -80) {
                          _nextCard();
                        } else if (_dragOffset > 80) {
                          _previousCard();
                        }
                        setState(() {
                          _isDragging = false;
                          _dragOffset = 0;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(_isDragging ? _dragOffset * 0.3 : 0, 0),
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final isShowingBack = _flipAnimation.value > 0.5;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(
                                  _flipAnimation.value * math.pi,
                                ),
                              child: isShowingBack
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(math.pi),
                                      child: _CardBack(
                                        phrase: phrase,
                                        accentColor: widget.scenario.accentColor,
                                        size: size,
                                      ),
                                    )
                                  : _CardFront(
                                      phrase: phrase,
                                      accentColor: widget.scenario.accentColor,
                                      size: size,
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Navigation ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Row(
                    children: [
                      // Back button
                      if (_currentIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousCard,
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
                            child: const Text('← Back'),
                          ),
                        ),

                      if (_currentIndex > 0) const SizedBox(width: 12),

                      // Next / Finish button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.scenario.accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _currentIndex == widget.scenario.phrases.length - 1
                                ? 'Finish Flashcards →'
                                : 'Next →',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card Front (Target Language) ──────────────────────────────────────────────
class _CardFront extends StatelessWidget {
  final ScenarioPhrase phrase;
  final Color accentColor;
  final Size size;

  const _CardFront({
    required this.phrase,
    required this.accentColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.88,
      height: size.height * 0.45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceVariant,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Language badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SPANISH', // TODO: dynamic
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Main phrase
            Text(
              phrase.targetText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            // Pronunciation guide
            Text(
              '[${phrase.pronunciation}]',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
            ),

            const Spacer(),

            // Tap hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app, color: accentColor.withOpacity(0.5), size: 16),
                const SizedBox(width: 6),
                Text(
                  'Tap to see translation',
                  style: TextStyle(
                    color: accentColor.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card Back (Native Language + Cultural Note) ───────────────────────────────
class _CardBack extends StatelessWidget {
  final ScenarioPhrase phrase;
  final Color accentColor;
  final Size size;

  const _CardBack({
    required this.phrase,
    required this.accentColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.88,
      height: size.height * 0.45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.25),
            accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accentColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Translation label
            Text(
              'TRANSLATION',
              style: TextStyle(
                color: accentColor.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            // Native translation
            Text(
              phrase.nativeText,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),

            // Cultural note (if available)
            if (phrase.culturalNote != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        phrase.culturalNote!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
