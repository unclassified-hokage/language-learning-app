# API Overview & Specifications
**Project:** LinguAI
**Backend:** Supabase (PostgREST + Edge Functions)
**Date:** 2026-03-09

---

## Base URLs

| Environment | Base URL |
|-------------|---------|
| DEV | `https://[dev-project-ref].supabase.co` |
| UAT | `https://[uat-project-ref].supabase.co` |
| PROD | `https://[prod-project-ref].supabase.co` |

---

## Authentication

All requests (except public content) require a JWT in the Authorization header:

```
Authorization: Bearer <supabase_jwt_token>
```

JWTs are obtained via Supabase Auth:
- `POST /auth/v1/signup` — Email/password registration
- `POST /auth/v1/token?grant_type=password` — Email/password login
- `POST /auth/v1/token?grant_type=refresh_token` — Refresh expired token
- OAuth redirects for Google (`/auth/v1/authorize?provider=google`) and Apple (`/auth/v1/authorize?provider=apple`)

---

## Auto-Generated REST API (Supabase PostgREST)

Supabase auto-generates REST endpoints for all tables. Base path: `/rest/v1/`

### Courses

**GET /rest/v1/courses** — List active courses
```http
GET /rest/v1/courses?is_active=eq.true&select=id,title,target_language,source_language,total_units,total_vocabulary
Authorization: Bearer <jwt>
```
Response:
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Spanish for English Speakers",
    "target_language": "es",
    "source_language": "en",
    "total_units": 12,
    "total_vocabulary": 1850
  }
]
```

---

**GET /rest/v1/courses?target_language=eq.{lang}** — Get course for language pair
```http
GET /rest/v1/courses?target_language=eq.es&source_language=eq.en&is_active=eq.true
Authorization: Bearer <jwt>
```

---

### Units

**GET /rest/v1/units** — List units for a course
```http
GET /rest/v1/units?course_id=eq.{course_id}&order=order_index.asc&select=id,title,description,cefr_level,order_index,icon_name
Authorization: Bearer <jwt>
```
Response:
```json
[
  {
    "id": "660e8400-e29b-41d4-a716-446655440001",
    "title": "Greetings & Introductions",
    "description": "Learn to say hello, introduce yourself, and ask how someone is doing.",
    "cefr_level": "A1",
    "order_index": 1,
    "icon_name": "wave"
  }
]
```

---

### Lessons

**GET /rest/v1/lessons** — List lessons for a unit
```http
GET /rest/v1/lessons?unit_id=eq.{unit_id}&order=order_index.asc
Authorization: Bearer <jwt>
```

**GET /rest/v1/lessons?id=eq.{lesson_id}&select=*,exercises(*)** — Get lesson with exercises
```http
GET /rest/v1/lessons?id=eq.{lesson_id}&select=id,title,lesson_type,xp_reward,exercises(id,exercise_type,prompt,answer,hints,grammar_note,audio_url,difficulty)
Authorization: Bearer <jwt>
```
Response:
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "title": "Say Hello",
  "lesson_type": "vocabulary",
  "xp_reward": 10,
  "exercises": [
    {
      "id": "880e8400-e29b-41d4-a716-446655440003",
      "exercise_type": "translate_to_target",
      "prompt": {
        "source_text": "Hello",
        "source_lang": "en"
      },
      "answer": {
        "primary": "Hola",
        "accepted": ["Hola", "¡Hola!"]
      },
      "hints": null,
      "grammar_note": null,
      "audio_url": "https://cdn.linguai.app/audio/es/hola.mp3",
      "difficulty": 1
    }
  ]
}
```

---

### User Progress

**POST /rest/v1/user_progress** — Record lesson completion
```http
POST /rest/v1/user_progress
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "lesson_id": "770e8400-e29b-41d4-a716-446655440002",
  "score_percent": 90,
  "xp_earned": 10,
  "time_spent_secs": 252,
  "mistakes_count": 1
}
```

**GET /rest/v1/user_progress?user_id=eq.{uid}&select=lesson_id,score_percent,completed_at** — Get user's completed lessons
```http
GET /rest/v1/user_progress?user_id=eq.{uid}&order=completed_at.desc&limit=50
Authorization: Bearer <jwt>
```

---

### Vocabulary Progress (SRS)

**GET /rest/v1/vocabulary_progress?user_id=eq.{uid}&next_review=lte.now()** — Get due items
```http
GET /rest/v1/vocabulary_progress?user_id=eq.{uid}&next_review=lte.now()&order=next_review.asc&limit=20&select=*,vocabulary(word,translation,audio_url,example_sentence)
Authorization: Bearer <jwt>
```

**PATCH /rest/v1/vocabulary_progress?id=eq.{id}** — Update SRS after review
```http
PATCH /rest/v1/vocabulary_progress?id=eq.{vp_id}
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "half_life_days": 2.0,
  "last_reviewed": "2026-03-09T10:00:00Z",
  "next_review": "2026-03-11T10:00:00Z",
  "total_reviews": 3,
  "correct_count": 2
}
```

---

## Custom Edge Functions

These are serverless functions that handle AI and complex logic.

### POST /functions/v1/ai-conversation

Start or continue an AI conversation practice session.

**Request:**
```http
POST /functions/v1/ai-conversation
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "session_id": "optional-existing-session-uuid",
  "enrollment_id": "uuid",
  "scenario": "ordering_food",
  "user_message": "Quiero un café, por favor.",
  "history": [
    { "role": "assistant", "content": "¡Buenos días! ¿Qué le pongo?" },
    { "role": "user", "content": "Quiero un café, por favor." }
  ]
}
```

**Response (streaming SSE):**
```
data: {"type": "token", "content": "¡"}
data: {"type": "token", "content": "Perfecto"}
data: {"type": "token", "content": "!"}
...
data: {"type": "correction", "wrong": "quiero un café", "correct": "Quiero un café", "reason": "Sentences start with capital letters"}
...
data: {"type": "done", "session_id": "uuid", "turns_used_today": 3, "turns_remaining": 17}
```

**Error responses:**
```json
{ "error": "rate_limit_exceeded", "message": "20 conversation turns per day. Resets at midnight.", "reset_at": "2026-03-10T00:00:00Z" }
{ "error": "unauthorized", "message": "Invalid or expired JWT" }
```

---

### POST /functions/v1/explain-grammar

Get an AI explanation for a wrong answer.

**Request:**
```http
POST /functions/v1/explain-grammar
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "wrong_answer": "Yo soy hambre",
  "correct_answer": "Yo tengo hambre",
  "target_language": "es",
  "native_language": "en",
  "cefr_level": "A2"
}
```

**Response:**
```json
{
  "explanation": "✗ 'soy' (I am) doesn't work here.\n✓ Spanish uses TENER (to have) for physical states.\n\n\"Yo tengo hambre\" = literally \"I have hunger\"\n\nSame pattern: tengo frío (I'm cold), tengo miedo (I'm scared).",
  "cache_hit": false
}
```

---

### POST /functions/v1/pronunciation-check

Evaluate user's pronunciation of a phrase.

**Request:**
```http
POST /functions/v1/pronunciation-check
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "audio_base64": "UklGRi...",
  "expected_text": "Buenos días",
  "target_language": "es"
}
```

**Response:**
```json
{
  "transcription": "buenas dias",
  "score": 78,
  "feedback": "Almost! 'Buenos' ends in -os, not -as. Make the 'o' sound rounder. Listen to the example.",
  "phoneme_errors": [
    { "expected": "o", "heard": "a", "position": "buenos → final vowel" }
  ],
  "native_audio_url": "https://cdn.linguai.app/audio/es/buenos-dias.mp3"
}
```

---

### GET /functions/v1/srs-due

Get vocabulary items due for review (alternative to PostgREST for complex SRS logic).

**Request:**
```http
GET /functions/v1/srs-due?limit=20
Authorization: Bearer <jwt>
```

**Response:**
```json
{
  "items": [
    {
      "vocabulary_progress_id": "uuid",
      "word": "hambre",
      "translation": "hunger / to be hungry",
      "pronunciation": "ˈam.bɾe",
      "audio_url": "https://cdn.linguai.app/audio/es/hambre.mp3",
      "example_sentence": "Tengo mucha hambre después del ejercicio.",
      "half_life_days": 1.0,
      "days_overdue": 2.3
    }
  ],
  "total_due": 8,
  "next_due_at": "2026-03-10T08:00:00Z"
}
```

---

### POST /functions/v1/srs-update

Update SRS after a vocabulary review.

**Request:**
```http
POST /functions/v1/srs-update
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "reviews": [
    {
      "vocabulary_progress_id": "uuid",
      "correct": true,
      "response_time_ms": 2300
    },
    {
      "vocabulary_progress_id": "uuid2",
      "correct": false,
      "response_time_ms": 5000
    }
  ]
}
```

**Response:**
```json
{
  "updated": 2,
  "next_review_times": [
    { "id": "uuid", "next_review": "2026-03-11T10:00:00Z", "new_half_life": 2.0 },
    { "id": "uuid2", "next_review": "2026-03-09T22:00:00Z", "new_half_life": 0.5 }
  ]
}
```

---

### GET /functions/v1/user-stats

Get comprehensive user statistics for the profile screen.

**Response:**
```json
{
  "streak": {
    "current": 7,
    "longest": 23
  },
  "xp": {
    "total": 450,
    "this_week": 80,
    "today": 20
  },
  "languages": [
    {
      "language": "es",
      "cefr_level": "A2",
      "lessons_completed": 24,
      "vocabulary_learned": 312,
      "minutes_practiced": 187
    }
  ],
  "vocabulary_due_today": 12
}
```

---

## Rate Limits

| Endpoint | Limit | Reset |
|---------|-------|-------|
| `/functions/v1/ai-conversation` | 20 turns/day (free) | Midnight UTC |
| `/functions/v1/explain-grammar` | 50 requests/day | Midnight UTC |
| `/functions/v1/pronunciation-check` | 30 checks/day | Midnight UTC |
| All PostgREST endpoints | 1000 req/min | Rolling |
| Auth endpoints | 100 req/hour | Rolling |

---

## Error Response Schema

All errors follow this structure:
```json
{
  "error": "error_code",
  "message": "Human-readable description",
  "details": {}
}
```

Common error codes:
| Code | HTTP Status | Meaning |
|------|------------|---------|
| `unauthorized` | 401 | Missing or invalid JWT |
| `forbidden` | 403 | Valid JWT but insufficient permissions |
| `not_found` | 404 | Resource doesn't exist |
| `rate_limit_exceeded` | 429 | Too many requests |
| `ai_service_unavailable` | 503 | Claude API temporarily down — fallback to Ollama if configured |
| `validation_error` | 422 | Invalid request body |

---

*API Specs v1.0 — 2026-03-09*
