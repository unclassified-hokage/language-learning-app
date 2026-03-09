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
- Claude API / open-source LLM (Ollama/Mistral) for AI features

## Research Conclusions
- Research complete: see /research/01-duolingo-market-analysis.md
- Gap analysis complete: see /research/02-gap-analysis-opportunity.md
- Top gap: AI conversation practice + grammar depth + free + open source
- Positioning: "Makes you fluent, not just addicted"
- Phase: Moving to ARCHITECTURE

## Key Files & Directories
- `/research/` - All market research, gap analysis, competitive analysis
- `/docs/architecture/` - System architecture diagrams and decisions
- `/docs/flows/` - User flows and journey maps
- `/docs/charts/` - Data charts and visualizations
- `/docs/api-specs/` - API specifications
- `/app/` - App source code (to be scaffolded after tech stack decision)
- `/reports/daily/` - Daily status reports

## Daily Reporting
- Email: viveknanda370@icloud.com
- Slack: TBD
- Schedule: Daily at 9:00 AM local time

## Project Status
- Phase: Research & Architecture
- Started: 2026-03-09

## Important Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-09 | Multiple languages from day 1 | User requirement |
| 2026-03-09 | Open source & free | User requirement |
| 2026-03-09 | AI-driven core | Key differentiator |
