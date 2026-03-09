# Infrastructure & Cost Plan
**Project:** LinguAI
**Constraint:** Free as possible. Max budget: $20-50/month.
**Date:** 2026-03-09

---

## Guiding Principle

> Use free tiers and open source everywhere. The only non-negotiable costs are app store developer accounts.

---

## Full Infrastructure Stack (Free-First)

### Backend: Supabase (Free Tier)

| Resource | Free Tier Limit | Our Usage (MVP) |
|---------|----------------|----------------|
| Database (PostgreSQL) | 500 MB | ~50 MB |
| Monthly Active Users | 50,000 | Target: <10k at launch |
| Storage | 1 GB | Audio files ~500 MB |
| Bandwidth | 5 GB | ~2 GB |
| Edge Functions | 500k invocations/month | ~100k |
| Realtime connections | 200 concurrent | ~50 at launch |

**Free until:** 50,000 monthly active users.
**When to upgrade:** Supabase Pro = $25/month (within budget). Handles millions of users.

**No AWS. No GCP. No Azure.** Supabase replaces all of it.

---

### AI Layer: Groq + Google Gemini (Both Free Tiers)

#### Primary AI: Groq (Free)

[groq.com](https://groq.com) — fastest free LLM inference available.

| Model | Speed | Quality | Use Case |
|-------|-------|---------|---------|
| `llama-3.3-70b-versatile` | ~300 tok/s | Excellent | Conversation practice |
| `llama-3.1-8b-instant` | ~700 tok/s | Good | Grammar explanations |
| `gemma2-9b-it` | ~500 tok/s | Good | Simple exercises |

**Free tier limits (Groq):**
- 14,400 requests per day
- 100 requests per minute
- 6,000 tokens per minute

For 1,000 daily active users doing 5 AI interactions each = 5,000 requests/day. **Well within free tier.**

#### Backup AI: Google Gemini Free Tier

[ai.google.dev](https://ai.google.dev) — generous free tier.

| Model | Free Limit | Use Case |
|-------|-----------|---------|
| `gemini-1.5-flash` | 1,500 req/day, 1M tok/min | Grammar, explanations |
| `gemini-1.5-flash-8b` | 1,500 req/day | Simple tasks |

Used as overflow when Groq hits limits (unlikely at launch scale).

#### Pronunciation: Whisper (Open Source, Self-Hostable)

- OpenAI's Whisper model is fully open source
- Can run via `whisper.cpp` on a cheap VPS OR use Groq's hosted Whisper API (free tier: 2 hours audio/day)
- At launch: Groq hosted Whisper. At scale: self-host on $5/month VPS.

#### Why NOT Claude API at launch:

Claude API costs ~$0.80/1M tokens (haiku) to ~$3/1M tokens (sonnet).
At 10,000 users × 20 AI turns/day × ~200 tokens/turn = **40M tokens/day = $32-120/day**.

That's $1,000-3,600/month. Way over budget.

Groq with Llama 3 70B: **$0/month** for the same capability at launch scale. When we hit 50k+ users and need quality + scale, we can revisit.

**Exception:** If a user self-hosts the app and has their own Claude API key, they can configure it. This is an open-source option, not a hosted cost.

---

### Push Notifications: Firebase (Free)

Firebase Cloud Messaging (FCM) — used by billions of apps.
- **Free forever** for push notifications (no limit on messages)
- Works on both iOS and Android
- Simple integration with Flutter via `firebase_messaging` package
- No need for a full Firebase project — just use FCM

---

### Audio/TTS (Text to Speech): Google TTS Free Tier

For generating lesson audio (native speaker pronunciation of vocabulary):
- Google Cloud TTS: **1 million characters/month free**
- Pre-generate audio for all vocabulary and store in Supabase Storage
- Don't re-generate — cache it. Each word generated once, stored forever.
- Estimate: 10,000 vocabulary items × 20 chars avg = 200,000 chars. Well within free tier.

**Fallback:** Flutter's `flutter_tts` package uses the device's built-in TTS (iOS/Android native). No API needed, zero cost, works offline.

---

### App Stores: Required Costs

| Store | Cost | Type |
|-------|------|------|
| Apple App Store | $99/year ($8.25/month) | Annual subscription — required |
| Google Play Store | $25 | One-time registration fee |

**These are the only real costs.** No way around them to publish publicly.

**Monthly cost: $8.25** (Apple only, Google is paid once).
Well under the $20-50 budget.

---

## Monthly Cost Summary

| Phase | What We're Running | Monthly Cost |
|-------|-------------------|-------------|
| **Development (now)** | GitHub only | $0 |
| **MVP Launch** | Supabase free + Groq free + Firebase free + Apple Dev | **$8.25** |
| **Growth (10k users)** | Same free tiers | **$8.25** |
| **Scale (50k+ users)** | Supabase Pro + Groq free + Firebase free | **$33.25** |
| **Large scale (500k+ users)** | Supabase Pro + Groq paid + Cloudflare | **~$50-80** (needs sponsor at this point) |

---

## If Vivek Needs to Sponsor

**At $20/month:** Covers Apple Developer ($8.25) + Supabase Pro ($25 if needed) comfortably.

**At $50/month:** Covers everything through 500k users with AI upgrade if needed.

The app stays free for users at all tiers. These costs are infrastructure, not monetization.

---

## Development Environment: All Free

| Tool | Cost | Purpose |
|------|------|---------|
| Flutter SDK | Free | Mobile app development |
| VS Code | Free | IDE |
| Android Studio | Free | Android emulator |
| Xcode (Mac only) | Free | iOS simulator |
| Supabase CLI | Free | Local dev database |
| Git / GitHub | Free | Version control |
| GitHub Actions | Free (2,000 min/month) | CI/CD |
| Figma (free tier) | Free | UI design |

**Total development cost: $0.**

---

## Architecture Decision Log

| Decision | Rejected Alternative | Reason |
|---------|---------------------|--------|
| Groq (free) | Claude API | Claude API too expensive at scale ($1k+/month) |
| Supabase | AWS / Firebase Firestore | Open source, PostgreSQL (better for our data model), generous free tier |
| Device TTS fallback | Paid TTS API | Zero cost, works offline, acceptable quality |
| Manual scenario selection | GPS location tracking | Privacy, App Store approval, battery, simpler to build |
| Google Gemini backup | OpenAI GPT-4 | Gemini has more generous free tier |
| GitHub Actions CI/CD | CircleCI / Jenkins | Already free with GitHub |

---

*Infrastructure Plan v1.0 — 2026-03-09*
