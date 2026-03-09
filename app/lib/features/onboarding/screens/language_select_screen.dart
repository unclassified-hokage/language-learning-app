import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  static const _languages = [
    {'code': 'es', 'name': 'Spanish', 'native': 'Español', 'flag': '🇪🇸', 'users': '47M'},
    {'code': 'fr', 'name': 'French', 'native': 'Français', 'flag': '🇫🇷', 'users': '32M'},
    {'code': 'ja', 'name': 'Japanese', 'native': '日本語', 'flag': '🇯🇵', 'users': '28M'},
    {'code': 'ko', 'name': 'Korean', 'native': '한국어', 'flag': '🇰🇷', 'users': '21M'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch', 'flag': '🇩🇪', 'users': '18M'},
    {'code': 'it', 'name': 'Italian', 'native': 'Italiano', 'flag': '🇮🇹', 'users': '15M'},
    {'code': 'pt', 'name': 'Portuguese', 'native': 'Português', 'flag': '🇵🇹', 'users': '14M'},
    {'code': 'zh', 'name': 'Mandarin', 'native': '普通话', 'flag': '🇨🇳', 'users': '12M'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(color: AppColors.textSecondary),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Text('What do you want\nto learn?',
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final lang = _languages[i];
                  return ListTile(
                    onTap: () => context.go('/goal'),
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
                    title: Text(lang['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(lang['native']!,
                        style: const TextStyle(color: AppColors.textMuted)),
                    trailing: Text('${lang['users']} users',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
