# Database Schema & Data Model
**Project:** LinguAI
**Database:** PostgreSQL via Supabase
**Date:** 2026-03-09

---

## Entity Relationship Diagram

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│    users     │────<│  enrollments     │>────│  languages   │
└──────────────┘     └──────────────────┘     └──────────────┘
       │                                              │
       │                                              │
       │             ┌──────────────────┐             │
       │             │     courses      │>────────────┘
       │             └──────────────────┘
       │                      │
       │                      │
       │             ┌──────────────────┐
       │             │      units       │
       │             └──────────────────┘
       │                      │
       │                      │
       │             ┌──────────────────┐
       │             │     lessons      │
       │             └──────────────────┘
       │                      │
       │             ┌────────┴─────────┐
       │             │                  │
       │     ┌───────────────┐  ┌────────────────┐
       │     │   exercises   │  │   vocabulary   │
       │     └───────────────┘  └────────────────┘
       │                                │
       ├────────────────────────────────┤
       │                                │
       ▼                                ▼
┌──────────────────┐       ┌────────────────────────┐
│  user_progress   │       │  vocabulary_progress   │
└──────────────────┘       └────────────────────────┘
       │
       ├──> ┌────────────────────┐
       │    │  ai_conversations  │
       │    └────────────────────┘
       │
       └──> ┌────────────────────┐
            │  community_posts   │
            └────────────────────┘
```

---

## Full Schema

### Table: `users`
Extends Supabase Auth `auth.users`. Stores app-specific profile data.

```sql
CREATE TABLE public.users (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username        TEXT UNIQUE NOT NULL,
  display_name    TEXT,
  avatar_url      TEXT,
  native_language TEXT NOT NULL DEFAULT 'en',  -- ISO 639-1 code
  timezone        TEXT NOT NULL DEFAULT 'UTC',
  streak_count    INTEGER NOT NULL DEFAULT 0,
  longest_streak  INTEGER NOT NULL DEFAULT 0,
  last_active_at  TIMESTAMPTZ,
  total_xp        INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users_read_own" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "users_update_own" ON public.users FOR UPDATE USING (auth.uid() = id);
```

---

### Table: `languages`
All supported languages in the app.

```sql
CREATE TABLE public.languages (
  id           TEXT PRIMARY KEY,  -- ISO 639-1 e.g. 'es', 'ja', 'fr'
  name         TEXT NOT NULL,     -- English name e.g. 'Spanish'
  native_name  TEXT NOT NULL,     -- Native name e.g. 'Español'
  flag_emoji   TEXT NOT NULL,
  script       TEXT NOT NULL,     -- 'latin', 'cyrillic', 'cjk', 'arabic', 'devanagari'
  is_rtl       BOOLEAN NOT NULL DEFAULT FALSE,
  is_tonal     BOOLEAN NOT NULL DEFAULT FALSE,  -- Mandarin, Vietnamese, Thai
  difficulty   INTEGER NOT NULL DEFAULT 2,      -- 1 (easy) to 5 (hardest) for native English speakers
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- No RLS needed — public read-only data
CREATE POLICY "languages_public_read" ON public.languages FOR SELECT USING (TRUE);
```

---

### Table: `courses`
A course is a specific language pair (e.g., Spanish for English speakers).

```sql
CREATE TABLE public.courses (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  target_language  TEXT NOT NULL REFERENCES public.languages(id),
  source_language  TEXT NOT NULL REFERENCES public.languages(id),
  title            TEXT NOT NULL,
  description      TEXT,
  cefr_max_level   TEXT NOT NULL DEFAULT 'B2',  -- A1, A2, B1, B2, C1, C2
  total_units      INTEGER NOT NULL DEFAULT 0,
  total_vocabulary INTEGER NOT NULL DEFAULT 0,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  version          INTEGER NOT NULL DEFAULT 1,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(target_language, source_language)
);

CREATE POLICY "courses_public_read" ON public.courses FOR SELECT USING (is_active = TRUE);
```

---

### Table: `enrollments`
Tracks which users are learning which language.

```sql
CREATE TABLE public.enrollments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id     UUID NOT NULL REFERENCES public.courses(id),
  cefr_level    TEXT NOT NULL DEFAULT 'A1',
  daily_goal_xp INTEGER NOT NULL DEFAULT 10,  -- 5 / 10 / 15 / 20
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  started_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_studied_at TIMESTAMPTZ,
  UNIQUE(user_id, course_id)
);

ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "enrollments_own" ON public.enrollments FOR ALL USING (auth.uid() = user_id);
```

---

### Table: `units`
Thematic groups of lessons (e.g., "Greetings", "Food & Drink", "Travel").

```sql
CREATE TABLE public.units (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id     UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  order_index   INTEGER NOT NULL,
  title         TEXT NOT NULL,
  description   TEXT,
  cefr_level    TEXT NOT NULL DEFAULT 'A1',
  icon_name     TEXT,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(course_id, order_index)
);

CREATE POLICY "units_public_read" ON public.units FOR SELECT USING (is_active = TRUE);
```

---

### Table: `lessons`
Individual lesson within a unit.

```sql
CREATE TABLE public.lessons (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_id         UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  order_index     INTEGER NOT NULL,
  title           TEXT NOT NULL,
  lesson_type     TEXT NOT NULL CHECK (lesson_type IN (
                    'vocabulary',   -- New words introduction
                    'grammar',      -- Grammar concept focus
                    'conversation', -- AI dialogue practice
                    'listening',    -- Audio comprehension
                    'reading',      -- Real-world text comprehension
                    'review'        -- Mixed review
                  )),
  estimated_minutes INTEGER NOT NULL DEFAULT 5,
  xp_reward       INTEGER NOT NULL DEFAULT 10,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(unit_id, order_index)
);

CREATE POLICY "lessons_public_read" ON public.lessons FOR SELECT USING (is_active = TRUE);
```

---

### Table: `exercises`
Individual exercise items within a lesson.

```sql
CREATE TABLE public.exercises (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id       UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  order_index     INTEGER NOT NULL,
  exercise_type   TEXT NOT NULL CHECK (exercise_type IN (
                    'translate_to_target',    -- Translate native → target language
                    'translate_to_native',    -- Translate target → native language
                    'word_bank_arrange',      -- Arrange word tiles into sentence
                    'multiple_choice',        -- Pick correct answer from 4 options
                    'fill_in_blank',          -- Complete a sentence
                    'listen_and_type',        -- Hear audio, type what you hear
                    'speak_and_match',        -- Speak phrase, match against expected
                    'match_pairs',            -- Match vocabulary pairs
                    'ai_conversation'         -- Free AI conversation turn
                  )),
  prompt          JSONB NOT NULL,   -- Structured prompt data (see below)
  answer          JSONB NOT NULL,   -- Expected answer(s)
  hints           JSONB,            -- Optional hints
  grammar_note    TEXT,             -- Grammar explanation to show on error
  audio_url       TEXT,             -- TTS audio URL
  difficulty      INTEGER NOT NULL DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- prompt JSONB example for translate_to_target:
-- { "source_text": "I want a coffee", "source_lang": "en" }

-- answer JSONB example:
-- { "accepted": ["Quiero un café", "Yo quiero un café"], "primary": "Quiero un café" }

CREATE POLICY "exercises_public_read" ON public.exercises FOR SELECT USING (TRUE);
```

---

### Table: `vocabulary`
Vocabulary items associated with a course.

```sql
CREATE TABLE public.vocabulary (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id       UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  word            TEXT NOT NULL,
  translation     TEXT NOT NULL,
  pronunciation   TEXT,             -- IPA phonetic representation
  audio_url       TEXT,             -- TTS audio URL
  example_sentence TEXT,
  example_translation TEXT,
  part_of_speech  TEXT,             -- noun, verb, adjective, etc.
  cefr_level      TEXT NOT NULL DEFAULT 'A1',
  tags            TEXT[] DEFAULT '{}',
  image_url       TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vocabulary_course ON vocabulary(course_id);
CREATE POLICY "vocabulary_public_read" ON vocabulary FOR SELECT USING (TRUE);
```

---

### Table: `user_progress`
Tracks lesson completion and XP per user.

```sql
CREATE TABLE public.user_progress (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  lesson_id       UUID NOT NULL REFERENCES public.lessons(id),
  completed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  score_percent   INTEGER NOT NULL CHECK (score_percent BETWEEN 0 AND 100),
  xp_earned       INTEGER NOT NULL DEFAULT 0,
  time_spent_secs INTEGER NOT NULL DEFAULT 0,
  mistakes_count  INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, lesson_id, completed_at)  -- Allow multiple attempts
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "progress_own" ON public.user_progress FOR ALL USING (auth.uid() = user_id);

CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_lesson ON user_progress(lesson_id);
```

---

### Table: `vocabulary_progress`
Per-word SRS tracking. This is the heart of the spaced repetition system.

```sql
CREATE TABLE public.vocabulary_progress (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  vocabulary_id   UUID NOT NULL REFERENCES public.vocabulary(id),
  half_life_days  FLOAT NOT NULL DEFAULT 1.0,   -- SRS half-life in days
  last_reviewed   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  next_review     TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '1 day',
  total_reviews   INTEGER NOT NULL DEFAULT 0,
  correct_count   INTEGER NOT NULL DEFAULT 0,
  incorrect_count INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, vocabulary_id)
);

ALTER TABLE public.vocabulary_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "vocab_progress_own" ON vocabulary_progress FOR ALL USING (auth.uid() = user_id);

CREATE INDEX idx_vocab_progress_user ON vocabulary_progress(user_id);
CREATE INDEX idx_vocab_progress_next_review ON vocabulary_progress(user_id, next_review);
```

---

### Table: `ai_conversations`
Stores AI conversation practice sessions.

```sql
CREATE TABLE public.ai_conversations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  enrollment_id   UUID NOT NULL REFERENCES public.enrollments(id),
  scenario        TEXT NOT NULL,    -- e.g. "ordering_coffee", "job_interview"
  messages        JSONB NOT NULL DEFAULT '[]',  -- Array of {role, content, timestamp}
  feedback        JSONB,            -- AI-generated session summary & tips
  turns_count     INTEGER NOT NULL DEFAULT 0,
  grammar_errors  JSONB DEFAULT '[]',  -- Errors identified during session
  started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at        TIMESTAMPTZ
);

ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_conv_own" ON ai_conversations FOR ALL USING (auth.uid() = user_id);

CREATE INDEX idx_ai_conv_user ON ai_conversations(user_id);
```

---

### Table: `community_posts`
In-app grammar questions and language discussions.

```sql
CREATE TABLE public.community_posts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id       UUID REFERENCES public.courses(id),
  lesson_id       UUID REFERENCES public.lessons(id),
  post_type       TEXT NOT NULL CHECK (post_type IN ('question', 'tip', 'discussion')),
  title           TEXT NOT NULL,
  body            TEXT NOT NULL,
  language_target TEXT REFERENCES public.languages(id),
  upvotes         INTEGER NOT NULL DEFAULT 0,
  is_answered     BOOLEAN NOT NULL DEFAULT FALSE,
  is_moderated    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "posts_read_all" ON community_posts FOR SELECT USING (is_moderated = FALSE);
CREATE POLICY "posts_create_auth" ON community_posts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "posts_update_own" ON community_posts FOR UPDATE USING (auth.uid() = user_id);
```

---

### Table: `daily_streaks`
Tracks daily activity for streak calculation.

```sql
CREATE TABLE public.daily_streaks (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date       DATE NOT NULL,
  xp_earned  INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, date)
);

ALTER TABLE public.daily_streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks_own" ON daily_streaks FOR ALL USING (auth.uid() = user_id);

CREATE INDEX idx_streaks_user_date ON daily_streaks(user_id, date DESC);
```

---

## Indexing Strategy

| Table | Index | Reason |
|-------|-------|--------|
| `user_progress` | `(user_id)` | Most queries filter by user |
| `vocabulary_progress` | `(user_id, next_review)` | SRS due-item queries sort by next_review |
| `ai_conversations` | `(user_id)` | User's conversation history lookup |
| `daily_streaks` | `(user_id, date DESC)` | Streak calculation reads recent dates |
| `exercises` | `(lesson_id, order_index)` | Lesson loading retrieves exercises in order |
| `units` | `(course_id, order_index)` | Course tree rendering |
| `vocabulary` | `(course_id)` | Vocabulary lookup by course |
| `community_posts` | `(course_id, created_at DESC)` | Community feed by course |

---

## Supabase Auth Integration

Users sign in via Supabase Auth. On first sign-in, a trigger creates the `public.users` row:

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, username, display_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || substr(NEW.id::text, 1, 8)),
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

**Supported auth methods:**
- Email + password
- Google OAuth
- Apple Sign In (required for iOS App Store)
- Anonymous (guest mode — convert to full account after first lesson)

---

*Data Model v1.0 — 2026-03-09*
