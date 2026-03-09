# UI/UX Design Direction
**Project:** LinguAI
**Date:** 2026-03-09

---

## Design Philosophy

**Not Duolingo's** childish, clinical, flat UI.
**Not Rosetta Stone's** stiff, corporate look.

LinguAI should feel like a premium travel magazine came to life as a language app. Immersive, culturally rich, beautiful — and still fast and intuitive.

---

## Visual Identity

### Color System

**Primary palette:**
- `#1A1A2E` — Deep navy (backgrounds, dark mode primary)
- `#16213E` — Midnight blue (card backgrounds)
- `#0F3460` — Ocean blue (secondary surfaces)
- `#E94560` — Coral red (primary CTA, highlights)
- `#FFFFFF` — Pure white (text on dark)
- `#F5F5F0` — Warm off-white (light mode backgrounds)

**Language accent colors** (each language gets a unique accent):
| Language | Accent | Inspired By |
|---------|--------|------------|
| Spanish | `#C60B1E` | Spanish flag red |
| French | `#0055A4` | French flag blue |
| Japanese | `#BC002D` | Japanese flag red |
| Korean | `#003478` | Taegukgi blue |
| German | `#FFCE00` | German flag gold |
| Italian | `#009246` | Italian flag green |
| Portuguese | `#006600` | Portuguese flag green |
| Mandarin | `#DE2910` | Chinese flag red |

### Typography

- **Display / Hero:** `Playfair Display` — Elegant serif, used for lesson titles, scenario names
- **Body / UI:** `Inter` — Clean, highly readable sans-serif for all functional text
- **Monospace / IPA:** `Fira Code` — Pronunciation guides, IPA notation

### Visual Style

- **Dark mode first** — Default. Light mode available in settings.
- **Glassmorphism cards** — Semi-transparent frosted glass effect on lesson cards
- **Full-bleed scene backgrounds** — When in a scenario, the background IS that place (illustrated, not photo)
- **Fluid motion** — All transitions use spring physics (not linear easing)
- **Cultural photography** — Real illustrated scenes: Parisian café, Tokyo street, Madrid plaza

---

## Screen-by-Screen Design Direction

### Home Screen

```
┌──────────────────────────────────────┐
│ [Dark navy background]               │
│                                      │
│  🌍 LinguAI        [🔔] [👤]        │
│                                      │
│ ┌────────────────────────────────┐   │
│ │ [Glassmorphism card]           │   │
│ │ Illustration: Tokyo street     │   │
│ │                                │   │
│ │  🔥 7-day streak               │   │
│ │                                │   │
│ │  Japanese  A2                  │   │
│ │  ████████░░░░  Today: 30xp     │   │
│ │                                │   │
│ │  [Continue Unit 3 →]           │   │
│ └────────────────────────────────┘   │
│                                      │
│ ┌────────────────────────────────┐   │
│ │ ✨ What are you doing today?   │   │
│ │ [☕] [🍽️] [❤️] [🚇] [more...]  │   │
│ └────────────────────────────────┘   │
│                                      │
│  Due for review: 12 words           │
│  [Start review session →]           │
│                                      │
│ ─────────────────────────────────── │
│ [🏠] [🗣️ Chat] [📚] [👥] [👤]     │
└──────────────────────────────────────┘
```

Key design choices:
- Hero card with full-bleed cultural illustration
- "What are you doing today?" prominently placed
- Due vocabulary shown as urgency signal
- Bottom nav minimal and iconic

---

### Scenario Flash Practice

```
┌──────────────────────────────────────┐
│ [Illustrated: romantic Paris restaurant background, slightly blurred] │
│                                      │
│  ← Back            ❤️ Date tonight  │
│                                      │
│                 [Card]               │
│  ┌──────────────────────────────┐   │
│  │                              │   │
│  │   [Soft glow effect]         │   │
│  │                              │   │
│  │   "Estás muy guapa"          │   │
│  │                              │   │
│  │   ─── tap to flip ───        │   │
│  │                              │   │
│  └──────────────────────────────┘   │
│                                      │
│  ○ ○ ● ○ ○ ○ ○ ○   Card 3 of 8     │
│                                      │
│  [← Swipe cards left/right →]       │
│                                      │
│  🔊 [Hear it]   💡 [Hint]           │
│                                      │
└──────────────────────────────────────┘
```

The background illustration changes per scenario:
- Date → candlelit restaurant, soft bokeh lights
- Coffee → sunlit Parisian café window
- Travel → airport lounge or cobblestone street
- Doctor → calm, clean clinic with plants

---

### Lesson Exercise Screen

```
┌──────────────────────────────────────┐
│ ← Quit      [Progress bar 70%]  ×   │
│                                      │
│ [Subtle lesson scene tint in BG]    │
│                                      │
│                                      │
│  Translate to Spanish:              │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  "The coffee is very good"     │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  [Your answer area]            │  │
│  │                                │  │
│  └────────────────────────────────┘  │
│                                      │
│  Word bank:                         │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │  El  │ │ café │ │ está │        │
│  └──────┘ └──────┘ └──────┘        │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ muy  │ │bueno │ │ rico │        │
│  └──────┘ └──────┘ └──────┘        │
│                                      │
│                                      │
│  ┌────────────────────────────────┐  │
│  │           CHECK →              │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

---

### Correct Answer Celebration

**Not Duolingo's flat green bar.** Something that feels earned:

- Full-screen burst animation (confetti, particles)
- Large animated checkmark with spring physics
- XP counter animates up with satisfying sound
- Cultural comment: "¡Perfecto! That's how they'd say it in Madrid 🇪🇸"
- Duration: 1.5 seconds, then auto-advance

---

### Error Card (No Hearts)

**Not a red banner. An actual learning moment:**

```
┌──────────────────────────────────────┐
│                                      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                      │
│  ✗  Not quite this time              │
│                                      │
│  You wrote:  "El café es muy bueno"  │
│  ✓ Also correct! "Es" works here.   │
│                                      │
│  ─────────────────────────────────  │
│  📖 Quick note:                      │
│                                      │
│  "Está" = temporary state            │
│  "Es" = permanent characteristic     │
│                                      │
│  Coffee being good is temporary      │
│  (this cup), so "está" is preferred. │
│  But "es" is also acceptable!        │
│                                      │
│  ─────────────────────────────────  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │          Got it! →             │  │
│  └────────────────────────────────┘  │
│                                      │
└──────────────────────────────────────┘
```

Tone: calm, educational, never scolding. No red flashing. No "WRONG!" energy.

---

### AI Conversation Screen

```
┌──────────────────────────────────────┐
│ ← Back      ☕ Coffee Shop  🇪🇸      │
│                                      │
│ [Blurred café illustration in BG]   │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ 🤖  Carlos (barista)             │ │
│ │                                  │ │
│ │ "¡Buenos días! ¿Qué le pongo?"   │ │
│ │ Good morning! What can I get you?│ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ 👤  You                          │ │
│ │                                  │ │
│ │ Quiero un café con leche,        │ │
│ │ por favor.                       │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ 🤖  Carlos                       │ │
│ │                                  │ │
│ │ "¡Perfecto! ¿Grande o pequeño?"  │ │
│ │ Perfect! Large or small?         │ │
│ └──────────────────────────────────┘ │
│ ─────────────────────────────────── │
│ [Type response...]   [🎙️ Speak]     │
│ [💡 I need help]                    │
└──────────────────────────────────────┘
```

---

## Animation Principles

| Interaction | Animation |
|------------|-----------|
| Card flip (flashcard) | 3D Y-axis flip, 300ms, spring easing |
| Correct answer | Particle burst + green checkmark scale-in |
| Screen transition | Slide + fade, 250ms |
| Word tile tap | Bounce down into answer area |
| XP gain | Counter rolls up with easing |
| Streak milestone | Full-screen fire animation |
| Lesson complete | Confetti shower + hero animation |
| Error card appearance | Slide up from bottom, no flash |

---

## Accessibility

- All text meets WCAG AA contrast ratio (4.5:1 minimum)
- Voice over / TalkBack support for all interactive elements
- Font size respects system settings (no fixed px sizes)
- All animations respect "Reduce Motion" system setting
- Microphone use always optional — skip button always visible
- No flashing content (seizure safe)

---

## What We're NOT Doing

| Duolingo thing | Our approach |
|---------------|-------------|
| Green/red bar for right/wrong | Full animation for right; calm card for wrong |
| Owl mascot as stress inducer | Optional mascot, always friendly tone |
| Childish flat illustration | Mature, culturally rich illustration |
| Aggressive streak notifications | Gentle reminders, user-chosen tone |
| Hearts (punishment) | No hearts ever |
| Silly disconnected sentences | Real-world sentences in cultural context |
| Bright lime green (#58CC02) | Deep navy + coral — premium feel |

---

*UI/UX Direction v1.0 — 2026-03-09*
