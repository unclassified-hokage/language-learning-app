import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ScenarioCompleteScreen extends StatelessWidget {
  const ScenarioCompleteScreen({super.key, required this.scenario, required this.score, required this.timeTaken});
  final dynamic scenario;
  final int score;
  final Duration timeTaken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScenarioCompleteScreen'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ScenarioCompleteScreen', style: Theme.of(context).textTheme.headlineMedium),
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
