// App-wide configuration constants.
//
// KEY SECURITY MODEL:
// ─────────────────────────────────────────────────────────────────────────────
// • Supabase URL + anon key: intentionally public — designed for client-side
//   use and protected by Row Level Security on the backend. Safe to commit.
//
// • Groq + Gemini keys: injected at BUILD TIME via --dart-define so they
//   are never written in source code or committed to GitHub.
//   Local dev: flutter run --dart-define=GROQ_API_KEY=... --dart-define=GEMINI_API_KEY=...
//   Production: keys live in Supabase Edge Functions (server-side calls only).
// ─────────────────────────────────────────────────────────────────────────────

class AppConfig {
  // ── Supabase (public / safe to commit) ────────────────────────────────────
  static const String supabaseUrl = 'https://hetpxnnpfitrewsybtoo.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhldHB4bm5wZml0cmV3c3lidG9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwNDQ5OTYsImV4cCI6MjA4ODYyMDk5Nn0'
      '.bq9kkchpOS4clAyAt3z3BOqKJqpYPwYT2q6IENacvc0';

  // ── AI keys (injected at build time — never hard-coded) ────────────────────
  // Usage: flutter run --dart-define=GROQ_API_KEY=gsk_xxx --dart-define=GEMINI_API_KEY=AIzaSy...
  static const String groqApiKey =
      String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqModel = 'llama3-70b-8192';

  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  // App settings
  static const bool debugMode = false;
}
