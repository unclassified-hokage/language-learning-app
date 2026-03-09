import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HomeScreen', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/scenarios'),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
