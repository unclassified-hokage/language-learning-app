# Just-In-Time Learning Feature — "What Are You Doing Today?"
**Status:** Approved for MVP (Phase 1 — no GPS)
**Date:** 2026-03-09

---

## Concept

> Practice the language you'll actually need, right before you need it.

This is LinguAI's most distinctive feature. Instead of generic lessons, the app asks every morning what the user is doing today — then builds a 5-minute targeted practice session for that specific situation.

**Learning science backing:** Retention is 3-5x higher when you use knowledge within minutes of learning it ("desirable difficulty" + immediate application). No other app does this.

---

## Phase 1: Manual Scenario Selection (MVP)

No GPS required. User declares their intent.

### Daily Morning Card (shown on app open before 11am)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Good morning, Vivek! ☀️                           │
│                                                     │
│   What's on your agenda today?                     │
│   (Pick one — we'll prep you in 5 min)             │
│                                                     │
│  ┌─────────────────┐  ┌─────────────────┐          │
│  │  ☕ Coffee /    │  │  🍽️  Restaurant │          │
│  │     Café        │  │     or Bar      │          │
│  └─────────────────┘  └─────────────────┘          │
│                                                     │
│  ┌─────────────────┐  ┌─────────────────┐          │
│  │  🛒 Shopping    │  │  🚇 Getting     │          │
│  │                 │  │     around      │          │
│  └─────────────────┘  └─────────────────┘          │
│                                                     │
│  ┌─────────────────┐  ┌─────────────────┐          │
│  │  💼 Work /      │  │  💊 Doctor /    │          │
│  │     Meeting     │  │     Pharmacy    │          │
│  └─────────────────┘  └─────────────────┘          │
│                                                     │
│  ┌─────────────────┐  ┌─────────────────┐          │
│  │  ❤️  Date       │  │  ✈️  Travel /   │          │
│  │     tonight     │  │     Airport     │          │
│  └─────────────────┘  └─────────────────┘          │
│                                                     │
│  ┌─────────────────┐  ┌─────────────────┐          │
│  │  🏋️  Gym /      │  │  🎓 Class /     │          │
│  │     Sports      │  │     Study       │          │
│  └─────────────────┘  └─────────────────┘          │
│                                                     │
│           [ Nothing special today ]                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

### What Happens After Selection (Example: "Date Tonight")

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ❤️  Date tonight — let's get you ready!           │
│                                                     │
│   5-minute flash practice:                         │
│   8 essential phrases for tonight                   │
│                                                     │
│   You'll learn:                                     │
│   • Complimenting how someone looks                │
│   • Suggesting what to eat/drink                   │
│   • Asking about their interests                   │
│   • Making them laugh (yes, this exists)           │
│                                                     │
│   ┌─────────────────────────────┐                  │
│   │   Start 5-min practice →   │                  │
│   └─────────────────────────────┘                  │
│                                                     │
│   [Maybe later]                                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

### Practice Session Format: Flashcards + Quiz

The session has 3 stages (total ~5 min):

**Stage 1: Flash Intro (1 min)**
- 8 cards slide in one by one, flip to reveal translation
- Each card shows: phrase → translation → pronunciation guide
- Ambient background: a restaurant/date-appropriate scene
- Can tap audio to hear native pronunciation

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Card 3 of 8                                       │
│                                                     │
│   ┌───────────────────────────────────────────┐    │
│   │                                           │    │
│   │    "Estás muy guapa esta noche"            │    │
│   │                                           │    │
│   │  ──────── tap to flip ──────────          │    │
│   │                                           │    │
│   │    "You look beautiful tonight"           │    │
│   │    [es-TAS mwee GWA-pa ES-ta NO-che]      │    │
│   │                                           │    │
│   │    🔊  [Hear it]                          │    │
│   │                                           │    │
│   └───────────────────────────────────────────┘    │
│                                                     │
│   ← Swipe to continue →                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Stage 2: Quick Quiz (2 min)**
- 8 questions, one per phrase just learned
- Multiple choice format (4 options)
- Instant feedback with AI grammar note on wrong answers
- No hearts — just learn and continue

**Stage 3: AI Practice Conversation (2 min)**
- Short AI roleplay: "You're at a restaurant. The person you're with asks what you'd like to drink. Respond."
- 3-4 turns only — just enough to build confidence
- AI responds as the date/waiter/situation requires

**Completion:**
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   🎉 You're ready for tonight!                      │
│                                                     │
│   You learned 8 phrases in 4:32                    │
│                                                     │
│   💡 Quick tip:                                     │
│   Spanish people appreciate when foreigners         │
│   try — even imperfect Spanish gets smiles.        │
│                                                     │
│   ┌─────────────────────────────┐                  │
│   │  📋 Save phrases to review │                  │
│   └─────────────────────────────┘                  │
│                                                     │
│   ┌─────────────────────────────┐                  │
│   │  🔁 Practice again          │                  │
│   └─────────────────────────────┘                  │
│                                                     │
│   Good luck! 😄                                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Scenario Library (MVP — 10 scenarios)

| Scenario | Phrases Count | AI Roleplay Setting | Cultural Note |
|---------|--------------|---------------------|---------------|
| ☕ Coffee / Café | 8 | Barista conversation | Café culture by country |
| 🍽️ Restaurant / Bar | 10 | Ordering dinner | Tipping customs |
| 🛒 Shopping | 8 | Finding an item, asking price | Bargaining culture |
| 🚇 Getting around | 8 | Asking directions, metro | Transport vocab |
| 💼 Work / Meeting | 10 | Intro, small talk, agenda | Professional register |
| 💊 Doctor / Pharmacy | 8 | Describing symptoms | Medical vocab |
| ❤️ Date | 8 | Dinner conversation | Romance phrases |
| ✈️ Travel / Airport | 10 | Check-in, security, boarding | Travel vocab |
| 🏋️ Gym / Sports | 6 | Asking for help, equipment | Sports vocab |
| 🎓 Class / Study | 8 | Asking teacher, group work | Academic phrases |

---

## Phase 2: Optional Location Awareness (Post-MVP)

After MVP is proven and users trust the app, add optional location:

**How it works (privacy-first):**
- Uses on-device location (processed locally, never sent to server)
- Detects place category (café, restaurant, shop) using Google Places API
- If user walks near a café: soft notification "Quick Spanish café practice? (2 min)"
- **Fully opt-in.** Location permission requested with clear explanation: "So we can suggest relevant practice near you"
- Can be turned off at any time

**Privacy rules:**
- GPS coordinates are NEVER stored on our servers
- Only place category is sent (e.g., "cafe") — not address
- User can use the app fully without ever granting location permission

---

## Why Manual First (Expert Rationale)

1. **App Store approval:** Apple is strict about location usage. "Practice language near venues" is a valid use case — but building it correctly takes 3x longer. Manual selection ships the same core value in days not months.

2. **Battery:** Background location kills battery. Users who get 1-star reviews for battery drain won't hear about the language features.

3. **Same outcome, simpler delivery:** A user who types "I'm going on a date tonight" and a user who walks past a restaurant both get the same 5-minute practice. The manual version works just as well.

4. **Trust first:** Users need to trust the app before granting location. Build the trust with great manual scenarios first, then offer location as a value-add later.

---

*Just-In-Time Learning Feature v1.0 — 2026-03-09*
