# User Onboarding Flow
**Project:** LinguAI
**Date:** 2026-03-09

---

## Design Principles

1. **Value before friction** — User experiences the app before creating an account (copied from Duolingo's best decision)
2. **No hearts on first day** — Never punish a new user. Hearts (if added later) are opt-in
3. **Placement test is smart** — Don't make intermediate learners do A1 basics
4. **Goal is realistic** — We tell users how long fluency actually takes (no deceptive "fluent in 3 weeks" claims)
5. **Guest mode works fully** — Progress is saved locally until they sign up

---

## Full Onboarding Flow (12 Steps)

### Step 1: Welcome / App Opens

```
┌─────────────────────────────┐
│                             │
│    🌍  LinguAI              │
│                             │
│  "Makes you fluent,         │
│   not just addicted."       │
│                             │
│  ┌─────────────────────┐    │
│  │  Start Learning     │    │
│  └─────────────────────┘    │
│                             │
│  Already have an account?   │
│  [Sign in]                  │
└─────────────────────────────┘
```

- **No sign-up prompt here.** Just "Start Learning."
- Animated globe or language symbols background

---

### Step 2: Choose Language to Learn

```
┌─────────────────────────────┐
│  ← Back                     │
│                             │
│  What do you want           │
│  to learn?                  │
│                             │
│  🔍 Search languages...     │
│  ─────────────────────────  │
│  🇪🇸  Spanish      47M users │
│  🇫🇷  French       32M users │
│  🇯🇵  Japanese     28M users │
│  🇰🇷  Korean       21M users │
│  🇩🇪  German       18M users │
│  🇮🇹  Italian      15M users │
│  🇵🇹  Portuguese   14M users │
│  🇨🇳  Mandarin     12M users │
│  ...                        │
│  See all 40+ languages →    │
└─────────────────────────────┘
```

- Sorted by popularity (social proof)
- Search for any language
- User count shown to build trust

---

### Step 3: Choose Your Reason (Personalization)

```
┌─────────────────────────────┐
│                             │
│  Why are you learning       │
│  Spanish?                   │
│                             │
│  ┌─────────────────────┐    │
│  │ 🌍 Travel           │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ 💼 Career / Work    │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ 👨‍👩‍👧  Family / Friends │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ 🎓 School / Study   │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ 🧠 Brain Training   │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │ ✨ Just for fun     │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- Answer personalizes notification copy and scenario suggestions
- Not used to gate content

---

### Step 4: Daily Commitment

```
┌─────────────────────────────┐
│                             │
│  How much time can you      │
│  practice each day?         │
│                             │
│  ◯ 5 min  — Casual          │
│    "Fits in your commute"   │
│                             │
│  ● 10 min — Regular ✓       │
│    "Recommended for most"   │
│                             │
│  ◯ 20 min — Serious         │
│    "Progress 2× faster"     │
│                             │
│  ◯ 30 min — Intensive       │
│    "For fast results"       │
│                             │
│  ┌─────────────────────┐    │
│  │     Continue        │    │
│  └─────────────────────┘    │
│                             │
│  (You can change this       │
│  any time in settings)      │
└─────────────────────────────┘
```

- Default: 10 min (not too low to demotivate, not too high to intimidate)
- Honest framing — no "fluent in 3 weeks" promises

---

### Step 5: Placement Test Offer

```
┌─────────────────────────────┐
│                             │
│  Have you studied           │
│  Spanish before?            │
│                             │
│  ┌─────────────────────┐    │
│  │ 🌱 I'm a beginner   │    │
│  │    Start from zero  │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ 📚 I know some      │    │
│  │    Take a quick     │    │
│  │    placement test   │    │
│  │    (2 min)          │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- Beginners skip straight to Step 7 (first lesson)
- "I know some" → Placement test (Step 6)

---

### Step 6: Placement Test (if not beginner)

```
┌─────────────────────────────┐
│  Quick placement test       │
│  ████████░░░░  Question 6/10│
│                             │
│  What does "tengo hambre"   │
│  mean?                      │
│                             │
│  ┌─────────────────────┐    │
│  │  A) I am tired      │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  B) I am hungry  ✓  │    │  ← tapped
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  C) I have time     │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │  D) I am cold       │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- 10 questions, adaptive (gets harder if correct, easier if wrong)
- No timer pressure
- No "wrong" — just tapping informs the algorithm
- Result: placed at A1, A2, B1, or B2

---

### Step 7: First Lesson (No Account Yet)

```
┌─────────────────────────────┐
│  ← Unit 1: Greetings        │
│  Lesson 1: Say hello        │
│                             │
│  ████████████░░  Exercise 7 │
│                             │
│  Translate to Spanish:      │
│                             │
│  "Hello, my name is Ana."   │
│                             │
│  ┌──────┐ ┌──────┐ ┌──────┐ │
│  │ me   │ │llamo │ │Hola  │ │
│  └──────┘ └──────┘ └──────┘ │
│  ┌──────┐ ┌──────┐          │
│  │  ,   │ │  Ana │          │
│  └──────┘ └──────┘          │
│                             │
│  [_ _ _ _ _ _ _ _ _ _ _ _] │
│                             │
│  ┌─────────────────────┐    │
│  │       Check         │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- Full real lesson, no limitations, no upsell
- Progress saved locally (anonymous user ID)
- If user makes a mistake: show grammar explanation card (never lose hearts)

---

### Step 8: Lesson Complete — Save Progress Prompt

```
┌─────────────────────────────┐
│                             │
│      🎉 Lesson Complete!    │
│                             │
│   Score: 90%  |  XP: +10   │
│   Time: 3:42               │
│                             │
│  ─────────────────────────  │
│                             │
│  Save your progress!        │
│  You've learned 12 words.   │
│  Don't lose them.           │
│                             │
│  ┌─────────────────────┐    │
│  │  Create Free Account│    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │  Continue as Guest  │    │
│  └─────────────────────┘    │
│                             │
│  (Guest progress is saved   │
│  on this device only)       │
└─────────────────────────────┘
```

- Sunk cost framing: "You've learned 12 words. Don't lose them."
- "Continue as Guest" available — no pressure, just clear consequence
- This is the highest-converting moment for sign-ups (after investment is made)

---

### Step 9: Sign Up (if they choose to)

```
┌─────────────────────────────┐
│  ← Back                     │
│                             │
│  Create your free account   │
│                             │
│  ┌─────────────────────┐    │
│  │  Continue with      │    │
│  │  🍎  Apple          │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │  Continue with      │    │
│  │  G  Google          │    │
│  └─────────────────────┘    │
│                             │
│  ── or ──────────────────── │
│                             │
│  Email: [____________]      │
│  Password: [____________]   │
│                             │
│  ┌─────────────────────┐    │
│  │  Create Account     │    │
│  └─────────────────────┘    │
│                             │
│  By continuing you agree    │
│  to our Terms & Privacy     │
└─────────────────────────────┘
```

- Apple Sign In first (required on iOS, users expect it)
- Google second
- Email option always available
- Anonymous session progress migrated to new account automatically

---

### Step 10: Set Username

```
┌─────────────────────────────┐
│                             │
│  Choose a username          │
│                             │
│  [linguai_vivek___________] │
│                             │
│  ✓ linguai_vivek is free!   │
│                             │
│  ┌─────────────────────┐    │
│  │     Continue        │    │
│  └─────────────────────┘    │
│                             │
│  Your username is visible   │
│  in community discussions.  │
└─────────────────────────────┘
```

---

### Step 11: Set Notification Preference

```
┌─────────────────────────────┐
│                             │
│  When do you want to        │
│  practice?                  │
│                             │
│  ○ Morning  7:00 AM         │
│  ● Evening  7:00 PM    ✓    │
│  ○ Custom   [Pick time]     │
│                             │
│  ─────────────────────────  │
│                             │
│  Notification style:        │
│                             │
│  ○ Motivating ("You got     │
│    this! Time to practice") │
│                             │
│  ● Gentle ("Daily reminder: │  ✓
│    5 min of Spanish?")      │
│                             │
│  ○ Off (I'll open the app   │
│    myself)                  │
│                             │
│  ┌─────────────────────┐    │
│  │     Continue        │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

- **Key differentiator:** Let users choose notification tone. No aggressive guilt-tripping by default.
- "Gentle" is default (unlike Duolingo's aggressive default)

---

### Step 12: Home Screen

```
┌─────────────────────────────┐
│  🌍 LinguAI   Vivek  🔔     │
│  ─────────────────────────  │
│                             │
│  Day 1 streak 🔥  10 XP     │
│                             │
│  Continue Learning →        │
│  ┌─────────────────────┐    │
│  │ Unit 1 · Lesson 2   │    │
│  │ Basic Greetings     │    │
│  │ [Start →]           │    │
│  └─────────────────────┘    │
│                             │
│  Today's Goal: ░░░░░ 0/10xp │
│                             │
│  ─────────────────────────  │
│  [🏠 Home] [🗣️ Chat] [📖 Vocab] [👥 Community] [👤 Profile]
└─────────────────────────────┘
```

---

## Key UX Decisions

| Decision | Rationale |
|---------|-----------|
| Lesson before sign-up | Reduces drop-off by 40%+ (industry standard for app onboarding) |
| No hearts on day 1 | First impressions matter — punishment alienates new users |
| Gentle notifications default | Reduces uninstall rate; users who feel respected stay longer |
| Placement test optional | Respects intermediate users' time; beginners aren't overwhelmed |
| Guest mode available | Removes barrier; users who invest time are more likely to convert |
| Username not email for community | Privacy protection — email not visible to other users |

---

*Onboarding Flow v1.0 — 2026-03-09*
