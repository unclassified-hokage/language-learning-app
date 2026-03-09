import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class LessonCompleteScreen extends StatelessWidget {
  const LessonCompleteScreen({super.key, required this.lessonTitle, required this.xpEarned, required this.score, required this.wordsLearned});
  final String lessonTitle;
  final int xpEarned;
  final int score;
  final List<String> wordsLearned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LessonCompleteScreen'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LessonCompleteScreen', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
