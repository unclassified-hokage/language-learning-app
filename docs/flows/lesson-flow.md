# Lesson Session Flow
**Project:** LinguAI
**Date:** 2026-03-09

---

## Lesson Session State Machine

```
     User taps "Start Lesson"
              │
              ▼
     ┌─────────────────┐
     │  LOADING        │ ← Fetch exercises from cache/API
     └────────┬────────┘
              │
              ▼
     ┌─────────────────┐
     │  INTRO SCREEN   │ ← Lesson title, estimated time, XP reward
     └────────┬────────┘
              │ Tap "Start"
              ▼
     ┌─────────────────┐
     │  EXERCISE N     │ ← Active exercise (see types below)
     └────────┬────────┘
              │
      ┌───────┴────────┐
      │                │
      ▼                ▼
  User submits      User skips
  answer            (costs 0 — no punishment)
      │                │
      ▼                ▼
  ┌────────┐       ┌────────────────────┐
  │Correct?│       │ Show answer + note  │
  └───┬────┘       │ Mark as "skipped"   │
      │            └─────────┬──────────┘
  ┌───┴────┐                 │
  │        │                 │
  ▼        ▼                 │
CORRECT  WRONG               │
  │        │                 │
  ▼        ▼                 │
✅ Confetti ❌ Error Card    │
  +XP        Show:           │
  │          - What was right│
  │          - Why (grammar) │
  │          - "Got it" btn  │
  │          │               │
  └──────────┴───────────────┘
              │
              ▼
       More exercises?
              │
      ┌───────┴────────┐
      │                │
      ▼                ▼
  NEXT EXERCISE    LESSON COMPLETE
                       │
                       ▼
              ┌─────────────────┐
              │  SUMMARY SCREEN │
              └─────────────────┘
```

---

## Exercise Types

### Type 1: Translate to Target Language (Word Bank)

```
┌─────────────────────────────┐
│  Translate to Spanish:      │
│                             │
│  "The cat drinks milk."     │
│                             │
│  ┌─────────────────────┐    │
│  │ El gato bebe leche  │    │  ← Answer area (tiles dropped here)
│  └─────────────────────┘    │
│                             │
│  Word bank:                 │
│  ┌──────┐ ┌──────┐ ┌──────┐ │
│  │ gato │ │bebe  │ │leche │ │
│  └──────┘ └──────┘ └──────┘ │
│  ┌──────┐ ┌──────┐ ┌──────┐ │
│  │  El  │ │ agua │ │perro │ │  ← Distractors included
│  └──────┘ └──────┘ └──────┘ │
│                             │
│  ┌─────────────────────┐    │
│  │       Check         │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

**Validation:** Accept alternate correct answers (e.g., "El gato se bebe la leche" also correct)
**On wrong:** Highlight incorrect tiles in red, show correct sentence

---

### Type 2: Translate (Free Type)

Used at higher levels (B1+) where word bank would be too easy.

```
┌─────────────────────────────┐
│  Translate to Spanish:      │
│                             │
│  "I've been waiting for     │
│   two hours."               │
│                             │
│  ┌─────────────────────┐    │
│  │ Llevo dos horas     │    │
│  │ esperando._         │    │
│  └─────────────────────┘    │
│                             │
│  💡 Hint available          │
│                             │
│  ┌─────────────────────┐    │
│  │       Check         │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

**Validation:** Fuzzy matching (accepts minor typos), multiple accepted translations
**On wrong:** Show all accepted translations + grammar note

---

### Type 3: Listen and Type

```
┌─────────────────────────────┐
│  Type what you hear:        │
│                             │
│  ┌─────────────────────┐    │
│  │    🔊  Play audio   │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │    🐢  Slow audio   │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ ___________________  │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │       Check         │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- "Slow audio" button always available (no penalty)
- Fuzzy text matching for accented characters (café = cafe = accepted)

---

### Type 4: Multiple Choice

```
┌─────────────────────────────┐
│  What does "madrugada"      │
│  mean?                      │
│                             │
│  ┌─────────────────────┐    │
│  │  A) Afternoon       │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  B) Evening         │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  C) Early morning ✓ │    │ ← tapped
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  D) Midnight        │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- 4 options always
- Distractors are semantically related (not random)
- No "all of the above" / no trick questions

---

### Type 5: Speaking Exercise

```
┌─────────────────────────────┐
│  Say in Spanish:            │
│                             │
│  "Good morning! How are     │
│   you today?"               │
│                             │
│  🔊 Listen first:           │
│  [Buenos días! ¿Cómo        │
│   estás hoy?]               │
│                             │
│  ┌─────────────────────┐    │
│  │  🎙️  Tap to speak   │    │
│  └─────────────────────┘    │
│                             │
│  ────── or ─────────────    │
│                             │
│  [Skip speaking 👁️]         │ ← Privacy/accessibility option
│                             │
└─────────────────────────────┘
```

**After recording:**
```
┌─────────────────────────────┐
│  You said:                  │
│  "Buenos días, como         │
│   estás hoy"                │
│                             │
│  ✅ Great pronunciation!    │
│     — or —                  │
│  ⚠️  Almost! "¿Cómo" needs  │
│     the accent mark.        │
│     Listen: [🔊]            │
│                             │
│  ┌─────────────────────┐    │
│  │  Try Again          │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  Continue  →        │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- Mic permission handled gracefully — skip option always present
- Never block progress on speaking (accessibility)

---

### Type 6: AI Conversation Turn

Used in "Conversation Lessons" — a full lesson dedicated to AI dialogue.

```
┌─────────────────────────────┐
│  🤖 AI Barista              │
│  ─────────────────────────  │
│  "¡Buenos días! ¿Qué le     │
│   pongo?" (What can I get   │
│   you?)                     │
│                             │
│  💬 Your response:          │
│  ┌─────────────────────┐    │
│  │ Quiero un café con  │    │
│  │ leche, por favor._  │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │  🎙️  Speak instead  │    │
│  └─────────────────────┘    │
│                             │
│  💡 Stuck? [Get hint]       │
│                             │
│  ┌─────────────────────┐    │
│  │       Send  →       │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

**After sending:**
```
┌─────────────────────────────┐
│  ✅ Good sentence!          │
│                             │
│  🤖 AI Barista:             │
│  "¡Perfecto! ¿Lo quiere     │
│   grande o pequeño?"        │
│  (Large or small?)          │
│                             │
│  [Grammar note collapsed ▼] │
│  "con leche = with milk     │
│   (Tip: In Spain, this is   │
│   called a 'café con leche' │
│   everywhere!)"             │
│                             │
│  [Continue conversation]    │
└─────────────────────────────┘
```

---

## Error Handling (No Hearts — Explanation Cards)

When a user gets an answer wrong:

```
┌─────────────────────────────┐
│  ❌ Not quite.              │
│                             │
│  You wrote:                 │
│  "Yo soy hambre"            │
│                             │
│  Correct answer:            │
│  "Yo tengo hambre"          │
│                             │
│  ──────────────────────     │
│  📖 Why?                    │
│                             │
│  In Spanish, physical       │
│  states use TENER (to have),│
│  not SER (to be).           │
│                             │
│  ✗ "I am hungry"            │
│    = Yo SOY hambre          │
│  ✓ "I have hunger"          │
│    = Yo TENGO hambre        │
│                             │
│  More examples:             │
│  Tengo frío = I'm cold      │
│  Tengo miedo = I'm scared   │
│                             │
│  ┌─────────────────────┐    │
│  │     Got it! →       │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

**Key rules:**
- Never show "You lost a heart" — that's gone
- Always explain WHY (grammar note or vocabulary tip)
- Exercise is added back to the session (re-tested once before session ends)
- XP is not deducted — partial XP earned even with mistakes

---

## Lesson Complete Screen

```
┌─────────────────────────────┐
│                             │
│        🎉                   │
│   Lesson Complete!          │
│                             │
│  ┌──────────────────────┐   │
│  │  Score    │  Time    │   │
│  │   88%     │  4:12    │   │
│  ├──────────────────────┤   │
│  │  XP Earned │ Mistakes│   │
│  │   +10      │   2     │   │
│  └──────────────────────┘   │
│                             │
│  Words learned today:       │
│  hambre  tengo  café        │
│  leche   buenos  días       │
│                             │
│  🔥 Day 1 streak!           │
│                             │
│  ┌─────────────────────┐    │
│  │   Next Lesson →     │    │
│  └─────────────────────┘    │
│                             │
│  [Share result] [Home]      │
└─────────────────────────────┘
```

---

## SRS Scheduling After Lesson

After each lesson completes, new vocabulary items are added to the user's SRS queue:

```
For each vocabulary item in the lesson:
  If item doesn't exist in user's vocabulary_progress:
    INSERT with half_life = 1.0 day, next_review = NOW() + 1 day
  Else:
    // Item was already known (from placement test or prior lesson)
    // Don't reset progress — just mark as seen
```

Items encountered in the lesson but answered correctly on first try get a longer initial half-life (1.5 days vs 1.0).

---

## Offline Support

| Action | Offline Behaviour |
|--------|------------------|
| Start lesson | ✅ Uses cached lesson content (cached for 24h) |
| Complete exercise | ✅ Progress queued locally in Hive |
| AI conversation | ❌ Requires connection (shows "AI chat needs internet") |
| Vocabulary review | ✅ Uses locally cached vocabulary |
| Sync progress | Auto-syncs when connection restored |

---

*Lesson Flow v1.0 — 2026-03-09*
