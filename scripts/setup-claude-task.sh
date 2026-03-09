#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# LinguAI — Set Up Claude Code Daily Automation Task
# Run this to recreate the autonomous daily task on any machine.
# Requires: Claude Code CLI installed (claude.ai/claude-code)
# ─────────────────────────────────────────────────────────────────────────────
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env.local"

# Colours
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "\033[0;34m[INFO]\033[0m $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERR]${NC}  $1"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   LinguAI — Claude Task Setup            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Check Claude CLI ──────────────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
  error "Claude Code CLI not found. Install it from: https://claude.ai/claude-code"
fi

# ── Read .env.local ───────────────────────────────────────────────────────────
if [[ ! -f "$ENV_FILE" ]]; then
  error ".env.local not found. Run scripts/setup.sh first."
fi

source "$ENV_FILE"

if [[ -z "$SLACK_WEBHOOK_URL" || "$SLACK_WEBHOOK_URL" == *"REPLACE"* ]]; then
  warn "SLACK_WEBHOOK_URL not set in .env.local — Slack notifications will be skipped"
fi

if [[ -z "$GITHUB_TOKEN" || "$GITHUB_TOKEN" == *"REPLACE"* ]]; then
  warn "GITHUB_TOKEN not set in .env.local — auto-push to GitHub will be skipped"
fi

# ── Create the scheduled task ─────────────────────────────────────────────────
info "Creating Claude daily task..."

TASK_DIR="$HOME/.claude/scheduled-tasks/language-app-daily-report"
mkdir -p "$TASK_DIR"

cat > "$TASK_DIR/SKILL.md" << 'SKILLEOF'
---
name: language-app-daily-report
description: Daily progress report and autonomous work session for the Language Learning App project
schedule: 0 9 * * *
---

You are working autonomously on an open-source AI-driven language learning app project for Vivek.

## Project Details
- Working directory: PROJECT_DIR_PLACEHOLDER
- Secrets file: PROJECT_DIR_PLACEHOLDER/.env.local (read for tokens)
- GitHub: https://github.com/unclassified-hokage/language-learning-app
- Email: viveknanda370@icloud.com

## STEP 0: Load secrets
Read PROJECT_DIR_PLACEHOLDER/.env.local to get SLACK_WEBHOOK_URL, GITHUB_TOKEN, NOTIFICATION_EMAIL.

## STEP 1: Check APPROVALS.md
Read PROJECT_DIR_PLACEHOLDER/APPROVALS.md.
Process any PENDING items that have YES/NO written next to them.

## STEP 2: Read current state
Read PROJECT_DIR_PLACEHOLDER/CLAUDE.md and the most recent report in PROJECT_DIR_PLACEHOLDER/reports/daily/.

## STEP 3: Do real work based on current phase in CLAUDE.md
- ARCHITECTURE phase: Write docs to /docs/
- BUILD phase: Write Flutter code to /app/lib/, implement features
- Always produce real, detailed output. Never be idle.

## STEP 4: If you need permission
Add to APPROVALS.md under PENDING, send Slack message, skip gated action.

## STEP 5: Write daily report
Save to: PROJECT_DIR_PLACEHOLDER/reports/daily/YYYY-MM-DD-report.md

## STEP 6: Send Slack notification (use Python3)
Read SLACK_WEBHOOK_URL from .env.local, then:
```python
import urllib.request, json
data = json.dumps({"text": "Language App - DATE\n\nWHAT_WAS_DONE"}).encode("utf-8")
req = urllib.request.Request(SLACK_WEBHOOK_URL, data=data, headers={"Content-Type": "application/json"})
urllib.request.urlopen(req)
```

## STEP 7: Git commit and push (never commit .env.local)
```bash
cd "PROJECT_DIR_PLACEHOLDER"
git add -A -- ':!.env.local'
git commit -m "daily: YYYY-MM-DD - brief description"
git push origin main
```

Standing permissions (no need to ask): write files, commit/push, send Slack/email, create folders.
Always ask via APPROVALS.md + Slack: delete files, publish to app stores, change paid API settings.
SKILLEOF

# Replace placeholder with real path
sed -i '' "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$TASK_DIR/SKILL.md" 2>/dev/null || \
sed -i "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$TASK_DIR/SKILL.md"

echo -e "${GREEN}✓${NC} Claude daily task created at $TASK_DIR/SKILL.md"
echo ""
echo "  The task will run daily at 9:06 AM and:"
echo "  - Advance the project (code, docs, research)"
echo "  - Send you a Slack notification"
echo "  - Email you at $NOTIFICATION_EMAIL"
echo "  - Commit and push all changes to GitHub"
echo ""
echo "  To run it manually any time:"
echo "  Open Claude Code → Scheduled tab → language-app-daily-report → Run now"
echo ""
