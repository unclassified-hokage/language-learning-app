-- ─────────────────────────────────────────────────────────────────────────────
-- LinguAI — Full Database Schema
-- Run this in Supabase SQL Editor to set up your database.
-- ─────────────────────────────────────────────────────────────────────────────

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ── Table: users ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.users (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username        TEXT UNIQUE NOT NULL,
  display_name    TEXT,
  avatar_url      TEXT,
  native_language TEXT NOT NULL DEFAULT 'en',
  timezone        TEXT NOT NULL DEFAULT 'UTC',
  streak_count    INTEGER NOT NULL DEFAULT 0,
  longest_streak  INTEGER NOT NULL DEFAULT 0,
  last_active_at  TIMESTAMPTZ,
  total_xp        INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users_read_own" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "users_update_own" ON public.users FOR UPDATE USING (auth.uid() = id);

-- ── Table: languages ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.languages (
  id           TEXT PRIMARY KEY,
  name         TEXT NOT NULL,
  native_name  TEXT NOT NULL,
  flag_emoji   TEXT NOT NULL,
  script       TEXT NOT NULL DEFAULT 'latin',
  is_rtl       BOOLEAN NOT NULL DEFAULT FALSE,
  is_tonal     BOOLEAN NOT NULL DEFAULT FALSE,
  difficulty   INTEGER NOT NULL DEFAULT 2 CHECK (difficulty BETWEEN 1 AND 5),
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.languages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "languages_public_read" ON public.languages FOR SELECT USING (TRUE);

-- Seed initial languages
INSERT INTO public.languages (id, name, native_name, flag_emoji, script, is_tonal, difficulty) VALUES
  ('es', 'Spanish',    'Español',   '🇪🇸', 'latin',      FALSE, 1),
  ('fr', 'French',     'Français',  '🇫🇷', 'latin',      FALSE, 2),
  ('ja', 'Japanese',   '日本語',    '🇯🇵', 'cjk',        FALSE, 4),
  ('ko', 'Korean',     '한국어',    '🇰🇷', 'hangul',     FALSE, 4),
  ('de', 'German',     'Deutsch',   '🇩🇪', 'latin',      FALSE, 3),
  ('it', 'Italian',    'Italiano',  '🇮🇹', 'latin',      FALSE, 1),
  ('pt', 'Portuguese', 'Português', '🇵🇹', 'latin',      FALSE, 1),
  ('zh', 'Mandarin',   '普通话',    '🇨🇳', 'cjk',        TRUE,  5),
  ('ar', 'Arabic',     'العربية',   '🇸🇦', 'arabic',     FALSE, 5),
  ('ru', 'Russian',    'Русский',   '🇷🇺', 'cyrillic',   FALSE, 3),
  ('hi', 'Hindi',      'हिन्दी',    '🇮🇳', 'devanagari', FALSE, 3),
  ('tr', 'Turkish',    'Türkçe',    '🇹🇷', 'latin',      FALSE, 3)
ON CONFLICT (id) DO NOTHING;

-- ── Table: courses ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.courses (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  target_language  TEXT NOT NULL REFERENCES public.languages(id),
  source_language  TEXT NOT NULL REFERENCES public.languages(id),
  title            TEXT NOT NULL,
  description      TEXT,
  cefr_max_level   TEXT NOT NULL DEFAULT 'B2',
  total_units      INTEGER NOT NULL DEFAULT 0,
  total_vocabulary INTEGER NOT NULL DEFAULT 0,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  version          INTEGER NOT NULL DEFAULT 1,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(target_language, source_language)
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "courses_public_read" ON public.courses FOR SELECT USING (is_active = TRUE);

-- Seed Spanish course
INSERT INTO public.courses (target_language, source_language, title, description, cefr_max_level)
VALUES ('es', 'en', 'Spanish for English Speakers', 'Learn Spanish from complete beginner to confident speaker.', 'B2')
ON CONFLICT DO NOTHING;

-- ── Table: enrollments ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.enrollments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id       UUID NOT NULL REFERENCES public.courses(id),
  cefr_level      TEXT NOT NULL DEFAULT 'A1',
  daily_goal_xp   INTEGER NOT NULL DEFAULT 10,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_studied_at TIMESTAMPTZ,
  UNIQUE(user_id, course_id)
);

ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "enrollments_own" ON public.enrollments FOR ALL USING (auth.uid() = user_id);

-- ── Table: units ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.units (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id   UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  title       TEXT NOT NULL,
  description TEXT,
  cefr_level  TEXT NOT NULL DEFAULT 'A1',
  icon_name   TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(course_id, order_index)
);

ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
CREATE POLICY "units_public_read" ON public.units FOR SELECT USING (is_active = TRUE);

-- ── Table: lessons ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.lessons (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_id           UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  order_index       INTEGER NOT NULL,
  title             TEXT NOT NULL,
  lesson_type       TEXT NOT NULL CHECK (lesson_type IN ('vocabulary','grammar','conversation','listening','reading','review')),
  estimated_minutes INTEGER NOT NULL DEFAULT 5,
  xp_reward         INTEGER NOT NULL DEFAULT 10,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(unit_id, order_index)
);

ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lessons_public_read" ON public.lessons FOR SELECT USING (is_active = TRUE);

-- ── Table: exercises ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.exercises (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id     UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  order_index   INTEGER NOT NULL,
  exercise_type TEXT NOT NULL CHECK (exercise_type IN (
    'translate_to_target','translate_to_native','word_bank_arrange',
    'multiple_choice','fill_in_blank','listen_and_type',
    'speak_and_match','match_pairs','ai_conversation'
  )),
  prompt        JSONB NOT NULL,
  answer        JSONB NOT NULL,
  hints         JSONB,
  grammar_note  TEXT,
  audio_url     TEXT,
  difficulty    INTEGER NOT NULL DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "exercises_public_read" ON public.exercises FOR SELECT USING (TRUE);

-- ── Table: vocabulary ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.vocabulary (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id            UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  word                 TEXT NOT NULL,
  translation          TEXT NOT NULL,
  pronunciation        TEXT,
  audio_url            TEXT,
  example_sentence     TEXT,
  example_translation  TEXT,
  part_of_speech       TEXT,
  cefr_level           TEXT NOT NULL DEFAULT 'A1',
  tags                 TEXT[] DEFAULT '{}',
  image_url            TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.vocabulary ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_vocabulary_course ON vocabulary(course_id);
CREATE POLICY "vocabulary_public_read" ON vocabulary FOR SELECT USING (TRUE);

-- ── Table: user_progress ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.user_progress (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  lesson_id       UUID NOT NULL REFERENCES public.lessons(id),
  completed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  score_percent   INTEGER NOT NULL CHECK (score_percent BETWEEN 0 AND 100),
  xp_earned       INTEGER NOT NULL DEFAULT 0,
  time_spent_secs INTEGER NOT NULL DEFAULT 0,
  mistakes_count  INTEGER NOT NULL DEFAULT 0
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "progress_own" ON public.user_progress FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user ON user_progress(user_id);

-- ── Table: vocabulary_progress (SRS) ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.vocabulary_progress (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  vocabulary_id   UUID NOT NULL REFERENCES public.vocabulary(id),
  half_life_days  FLOAT NOT NULL DEFAULT 1.0,
  last_reviewed   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  next_review     TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '1 day',
  total_reviews   INTEGER NOT NULL DEFAULT 0,
  correct_count   INTEGER NOT NULL DEFAULT 0,
  incorrect_count INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, vocabulary_id)
);

ALTER TABLE public.vocabulary_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "vocab_progress_own" ON vocabulary_progress FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_vocab_progress_user ON vocabulary_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_vocab_progress_next_review ON vocabulary_progress(user_id, next_review);

-- ── Table: ai_conversations ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ai_conversations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  enrollment_id UUID NOT NULL REFERENCES public.enrollments(id),
  scenario      TEXT NOT NULL,
  messages      JSONB NOT NULL DEFAULT '[]',
  feedback      JSONB,
  turns_count   INTEGER NOT NULL DEFAULT 0,
  grammar_errors JSONB DEFAULT '[]',
  started_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at      TIMESTAMPTZ
);

ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_conv_own" ON ai_conversations FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_ai_conv_user ON ai_conversations(user_id);

-- ── Table: community_posts ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_posts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id       UUID REFERENCES public.courses(id),
  lesson_id       UUID REFERENCES public.lessons(id),
  post_type       TEXT NOT NULL CHECK (post_type IN ('question','tip','discussion')),
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

-- ── Table: daily_streaks ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.daily_streaks (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id   UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date      DATE NOT NULL,
  xp_earned INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, date)
);

ALTER TABLE public.daily_streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks_own" ON daily_streaks FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_streaks_user_date ON daily_streaks(user_id, date DESC);

-- ── Trigger: auto-create user profile on sign-up ──────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, username, display_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'username',
      'user_' || substr(replace(NEW.id::text, '-', ''), 1, 8)
    ),
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'avatar_url'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
