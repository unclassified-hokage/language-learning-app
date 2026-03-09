# Language Learning App - Project Context

## Project Overview
Building an open-source, free, AI-driven language learning app that improves on Duolingo.
Publish on Android and iOS app stores.

## Owner
- Name: Vivek
- Email: viveknanda370@icloud.com
- GitHub: https://github.com/unclassified-hokage/language-learning-app
- Slack Workspace: language-app-updates.slack.com
- Slack Webhook: stored in .env.local (gitignored)

## Project Goals
- Free and open source
- AI-driven, interactive, personalized
- Faster and more effective than Duolingo
- Support multiple languages from day 1
- Publish on both Android and iOS

## Environments
- DEV: Local development
- UAT: Staging/testing
- PROD: Live app stores

## Tech Stack Decision
- **DECIDED: Flutter** — Best performance, single codebase iOS+Android, strong AI/ML plugin ecosystem, faster rendering than React Native for complex UI
- Dart language (easy to learn, similar to Java/TypeScript)
- Supabase as backend (open source Firebase alternative — perfect for open source project)
- AI: Groq free tier (Llama 3 70B) + Google Gemini free backup — NO paid API at launch
- Notifications: Firebase Cloud Messaging (free forever)
- TTS: flutter_tts (device-native, free) + Google TTS free tier for pre-generation
- Monthly cost: ~$8.25/month (Apple Dev only) up to 50,000 users

## Research Conclusions
- Research complete: see /research/01-duolingo-market-analysis.md
- Gap analysis complete: see /research/02-gap-analysis-opportunity.md
- Top gap: AI conversation practice + grammar depth + free + open source
- Positioning: "Makes you fluent, not just addicted"

## Key Features Decided
- Just-in-time learning: "What are you doing today?" daily scenario (see /docs/features/)
- No GPS Phase 1 — manual scenario selection, location opt-in Phase 2
- 10 scenarios: café, restaurant, date, travel, work, shopping, gym, doctor, class, directions
- UI: dark-first, cultural immersion, glassmorphism, NO hearts ever
- See /docs/design/ui-ux-direction.md for full design system

## Key Files & Directories
- `/research/` - Market research, gap analysis, competitive analysis
- `/docs/architecture/` - System design, data model, AI system, infra costs
- `/docs/features/` - Feature specifications
- `/docs/design/` - UI/UX direction, design system
- `/docs/flows/` - User flows and journey maps
- `/docs/api-specs/` - API specifications
- `/app/` - Flutter source code (scaffolding next)
- `/reports/daily/` - Daily progress reports
- `APPROVALS.md` - Async permission requests from Claude

## Daily Reporting
- Email: viveknanda370@icloud.com
- Slack: language-app-updates.slack.com (webhook in .env.local)
- Schedule: Daily at 9:06 AM

## Project Status
- Phase: BUILD — Architecture complete, Flutter scaffold next
- Started: 2026-03-09

## Important Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-09 | Multiple languages from day 1 | User requirement |
| 2026-03-09 | Open source & free | User requirement |
| 2026-03-09 | AI-driven core | Key differentiator |
| 2026-03-09 | Flutter + Supabase | Best free cross-platform stack |
| 2026-03-09 | Groq + Gemini (not Claude API) | Free tiers, $0 AI cost at launch |
| 2026-03-09 | Manual scenario selection first (not GPS) | Simpler, privacy-first, faster to ship |
| 2026-03-09 | Dark-first UI, cultural immersion design | Premium feel, target demographic (18-34) |
