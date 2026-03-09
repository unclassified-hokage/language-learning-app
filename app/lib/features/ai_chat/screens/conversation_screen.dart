import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key, required this.scenarioId});
  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConversationScreen'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ConversationScreen', style: Theme.of(context).textTheme.headlineMedium),
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
