# System Architecture
**Project:** LinguAI — Open Source AI Language Learning App
**Date:** 2026-03-09
**Status:** Draft v1.0

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER DEVICES                             │
│   ┌──────────────────┐        ┌──────────────────┐             │
│   │   Flutter iOS    │        │  Flutter Android  │             │
│   └────────┬─────────┘        └────────┬──────────┘            │
└────────────┼──────────────────────────┼─────────────────────────┘
             │                          │
             ▼                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CLOUDFLARE CDN / WAF                         │
│           (Static assets, DDoS protection, HTTPS)               │
└──────────────────────────┬──────────────────────────────────────┘
                           │
             ┌─────────────┴──────────────┐
             ▼                            ▼
┌────────────────────┐       ┌────────────────────────────────────┐
│  SUPABASE BACKEND  │       │         AI SERVICES LAYER          │
│                    │       │                                    │
│  ┌──────────────┐  │       │  ┌─────────────┐  ┌────────────┐  │
│  │ PostgreSQL   │  │       │  │ Claude API  │  │  Whisper   │  │
│  │ (PostgREST)  │  │       │  │ (Anthropic) │  │  (Speech)  │  │
│  └──────────────┘  │       │  └─────────────┘  └────────────┘  │
│  ┌──────────────┐  │       │  ┌─────────────────────────────┐  │
│  │  Supabase    │  │       │  │  Ollama (self-host fallback) │  │
│  │    Auth      │  │       │  │  Mistral / Llama3            │  │
│  └──────────────┘  │       │  └─────────────────────────────┘  │
│  ┌──────────────┐  │       └────────────────────────────────────┘
│  │  Realtime    │  │
│  │  (WebSocket) │  │       ┌────────────────────────────────────┐
│  └──────────────┘  │       │         CONTENT DELIVERY           │
│  ┌──────────────┐  │       │  ┌────────────┐  ┌─────────────┐  │
│  │   Storage    │  │       │  │  Supabase  │  │ Cloudflare  │  │
│  │  (Audio/img) │  │       │  │  Storage   │  │    R2       │  │
│  └──────────────┘  │       │  │ (audio TTS)│  │  (media)    │  │
│  ┌──────────────┐  │       │  └────────────┘  └─────────────┘  │
│  │    Edge      │  │       └────────────────────────────────────┘
│  │  Functions   │  │
│  └──────────────┘  │
└────────────────────┘
```

---

## Component Breakdown

### Flutter Mobile App

**Architecture Pattern:** Feature-first BLoC (Business Logic Component)

```
app/
├── lib/
│   ├── core/
│   │   ├── auth/           # Auth state management
│   │   ├── router/         # Go Router navigation
│   │   ├── theme/          # App theme, colors, typography
│   │   ├── localization/   # i18n strings
│   │   └── utils/          # Helpers, extensions
│   ├── features/
│   │   ├── onboarding/     # Language select, goals, placement test
│   │   ├── home/           # Dashboard, progress overview
│   │   ├── lessons/        # Lesson engine, exercise types
│   │   ├── ai_chat/        # AI conversation practice
│   │   ├── vocabulary/     # SRS vocabulary review
│   │   ├── pronunciation/  # Phonetics coaching
│   │   ├── community/      # Q&A, grammar discussions
│   │   └── profile/        # User stats, settings, streaks
│   ├── shared/
│   │   ├── widgets/        # Reusable UI components
│   │   ├── models/         # Dart data classes
│   │   └── repositories/   # Data access layer
│   └── main.dart
```

**Key Flutter Packages:**
| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `go_router` | Navigation |
| `supabase_flutter` | Backend client |
| `just_audio` | Audio playback for lessons |
| `record` | Microphone recording for speaking exercises |
| `flutter_tts` | Text-to-speech for pronunciation |
| `lottie` | Animations (lesson completion, rewards) |
| `flutter_animate` | Micro-animations |
| `hive` | Local storage (offline caching) |
| `connectivity_plus` | Offline detection |
| `dio` | HTTP client for AI API calls |

---

### Supabase Backend

**Why Supabase (not Firebase):**
- Open source — matches project ethos
- PostgreSQL (not NoSQL) — relational data model is better for course content
- Row Level Security (RLS) built in
- Auto-generated REST API from schema
- Edge Functions for custom AI proxy logic
- Self-hostable if needed

**Services Used:**
| Service | Use |
|---------|-----|
| PostgreSQL + PostgREST | All app data, auto REST API |
| Supabase Auth | JWT auth, Google/Apple/email login |
| Realtime | Leaderboards, community Q&A live updates |
| Storage | Audio files (TTS), user profile photos |
| Edge Functions (Deno) | AI proxy, SRS calculation, content generation |

---

### AI Services Layer

**Primary: Claude API (Anthropic)**
- `claude-haiku-4-5` for grammar explanations (fast, cheap)
- `claude-sonnet-4-6` for full conversation practice (higher quality)
- Proxied through Supabase Edge Function (keeps API key off client)

**Speech Processing: OpenAI Whisper (open source)**
- Self-hosted for pronunciation evaluation
- Transcribes user speech → compare against expected phonemes

**Fallback: Ollama (self-hosted)**
- For users/deployments that want fully offline or self-hosted AI
- Mistral 7B or Llama 3 8B
- Configurable via app settings

---

## Environments

| | DEV | UAT | PROD |
|--|-----|-----|------|
| **Supabase Project** | `linguai-dev` | `linguai-uat` | `linguai-prod` |
| **Flutter flavor** | `dev` | `uat` | `prod` |
| **API base URL** | `*.supabase.co (dev project)` | `*.supabase.co (uat project)` | `*.supabase.co (prod project)` |
| **Claude model** | haiku (cheap) | haiku | sonnet-4-6 |
| **RLS** | Disabled (easier dev) | Enabled | Enabled (strict) |
| **App bundle ID** | `com.linguai.dev` | `com.linguai.uat` | `com.linguai.app` |
| **App name** | `LinguAI Dev` | `LinguAI UAT` | `LinguAI` |
| **Push notifications** | Test APNS | Test APNS | Prod APNS |
| **Analytics** | Off | Enabled | Enabled |

**CI/CD Pipeline:**
```
Developer pushes to branch
         │
         ▼
   GitHub Actions
         │
   ┌─────┴─────┐
   │           │
   ▼           ▼
Flutter test  Flutter build
(unit+widget) (Android + iOS)
   │           │
   └─────┬─────┘
         │ Passing
         ▼
   Merge to main
         │
         ▼
   Deploy to UAT
   (TestFlight + Play Store Internal)
         │
         ▼ (manual approval by Vivek)
   Deploy to PROD
   (App Store + Play Store)
```

---

## Data Flows

### Flow 1: User Starts a Lesson

```
User taps lesson
      │
      ▼
Flutter app reads from Hive cache
      │
      ├── Cache hit → render lesson immediately (offline-first)
      │
      └── Cache miss
            │
            ▼
      GET /rest/v1/lessons?id=eq.{lesson_id}
      (Supabase PostgREST, with JWT auth header)
            │
            ▼
      PostgreSQL (RLS verifies user owns enrollment)
            │
            ▼
      Return lesson JSON (exercises, vocabulary, audio URLs)
            │
            ▼
      Store in Hive cache (TTL: 24h)
            │
            ▼
      Render lesson in Flutter
```

### Flow 2: AI Conversation Practice

```
User starts conversation session
      │
      ▼
Flutter → POST /functions/v1/ai-conversation
  Body: { language, level, scenario, history[] }
  Auth: Bearer JWT
      │
      ▼
Supabase Edge Function (Deno)
  1. Validate JWT
  2. Check rate limit (5 sessions/day free tier)
  3. Retrieve user's language level from DB
  4. Build system prompt
      │
      ▼
POST https://api.anthropic.com/v1/messages
  Model: claude-haiku-4-5 or claude-sonnet-4-6
  System: [language tutor prompt]
  Messages: [conversation history]
      │
      ▼
Edge Function streams response back to Flutter
      │
      ▼
Flutter renders AI message with typing animation
      │
      ▼
Grammar errors detected → trigger inline explanation
      │
      ▼
Session saved to ai_conversations table
```

### Flow 3: Spaced Repetition Review

```
App opens (or user taps Practice)
      │
      ▼
Flutter → GET /functions/v1/srs-due
  Auth: Bearer JWT
      │
      ▼
Edge Function runs half-life regression:
  due_items = vocabulary where:
    (now - last_reviewed) > half_life * ln(retention_threshold) / ln(0.5)
      │
      ▼
Return up to 20 due items (prioritized by urgency)
      │
      ▼
Flutter renders review session
      │
      ▼
User answers each item
      │
      ▼
POST /functions/v1/srs-update
  Body: { item_id, correct: true/false, response_time_ms }
      │
      ▼
Edge Function updates half_life:
  if correct:  half_life = half_life * 2^delta (strengthen)
  if wrong:    half_life = half_life * 0.5 (weaken)
      │
      ▼
Update vocabulary_progress table
```

---

## Security

### Row Level Security (RLS) Examples

```sql
-- Users can only read their own progress
CREATE POLICY "user_progress_self_only"
ON user_progress FOR ALL
USING (auth.uid() = user_id);

-- Course content is readable by all authenticated users
CREATE POLICY "lessons_readable_by_auth"
ON lessons FOR SELECT
USING (auth.role() = 'authenticated');

-- AI conversations are private to the user
CREATE POLICY "ai_conversations_private"
ON ai_conversations FOR ALL
USING (auth.uid() = user_id);
```

### API Key Security
- Claude API key stored only in Supabase Edge Function environment variables
- Never sent to client app
- All AI calls proxied through Edge Functions
- Rate limiting per user enforced in Edge Function

### Content Moderation
- AI system prompt includes strict language-teaching-only constraints
- User-generated community content passes through moderation Edge Function
- Profanity filter on community posts before storage

---

## Scalability

### Database
- Supabase Pro handles ~500 concurrent connections
- PgBouncer connection pooling for burst traffic
- Read replicas for analytics queries (separate from transactional DB)
- Partitioning on `user_progress` table by `user_id` hash (largest table)

### AI Cost Management
- **Caching:** Identical grammar explanations cached in Redis (Upstash) with 7-day TTL
- **Model tiering:** Simple exercises use haiku ($0.25/1M tokens), conversation uses sonnet ($3/1M tokens)
- **Session limits:** 20 AI conversation turns per day on free tier (self-hosted Ollama removes limit)
- **Prompt compression:** Conversation history summarized after 10 turns to reduce context window

### CDN
- Audio files (TTS, lesson audio) served from Cloudflare R2 (cheap object storage)
- Flutter app static assets cached at edge
- 99.9% uptime target

---

*Architecture v1.0 — 2026-03-09*
