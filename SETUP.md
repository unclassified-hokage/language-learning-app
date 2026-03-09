# Complete Setup Guide
**LinguAI — Open Source AI Language Learning App**

> GitHub is the single source of truth for this project.
> This guide gets you from zero to running app on any machine.

---

## Prerequisites

- macOS (Apple Silicon or Intel), Windows, or Linux
- Internet connection
- ~5GB free disk space

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/unclassified-hokage/language-learning-app.git
cd language-learning-app
```

---

## Step 2: Run the Automated Setup Script

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

This script will:
- Detect your OS and chip (Apple Silicon vs Intel)
- Download and install Flutter SDK into `~/development/flutter/`
- Add Flutter to your PATH
- Install Xcode command-line tools (macOS)
- Run `flutter doctor` to verify setup
- Create `.env.local` from `.env.example`

> If you prefer manual setup, follow Steps 3–6 below.

---

## Step 3: Install Flutter (Manual)

### macOS Apple Silicon (M1/M2/M3)

```bash
mkdir -p ~/development && cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.19.6-stable.zip
unzip flutter_macos_arm64_3.19.6-stable.zip
rm flutter_macos_arm64_3.19.6-stable.zip

# Add to PATH
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### macOS Intel (older Macs)

```bash
mkdir -p ~/development && cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.19.6-stable.zip
unzip flutter_macos_3.19.6-stable.zip
rm flutter_macos_3.19.6-stable.zip
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Linux

```bash
mkdir -p ~/development && cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz
tar xf flutter_linux_3.19.6-stable.tar.xz
rm flutter_linux_3.19.6-stable.tar.xz
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Verify Installation

```bash
flutter --version
flutter doctor    # Shows what's installed and what's missing
```

---

## Step 4: Install Xcode (macOS only — needed for iOS)

```bash
xcode-select --install   # Command-line tools (already running)
```

Then from the App Store, install **Xcode** (full IDE, ~7GB).
After installing: open Xcode → agree to license → let it install components.

```bash
sudo xcodebuild -license accept
```

---

## Step 5: Set Up Free API Keys

Copy the environment template:

```bash
cp .env.example .env.local
```

Now fill in each value. All are **free**:

### Supabase (Database + Auth + Storage)

1. Go to [supabase.com](https://supabase.com) → Sign up free
2. Click **New Project** → Name it `linguai-dev` → Choose a region → Create
3. Wait ~2 minutes for project to spin up
4. Go to **Project Settings** → **API**
5. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_ANON_KEY`

### Groq AI (Primary AI — Free)

1. Go to [groq.com](https://groq.com) → Sign up free
2. Click your profile → **API Keys** → **Create API Key**
3. Copy key → `GROQ_API_KEY`
4. Free tier: 14,400 requests/day with Llama 3 70B — no credit card needed

### Google Gemini (Backup AI — Free)

1. Go to [ai.google.dev](https://ai.google.dev) → Click **Get API key**
2. Sign in with Google → **Create API key** → Select a project
3. Copy key → `GEMINI_API_KEY`
4. Free tier: 1,500 requests/day — no credit card needed

### Slack Webhook (Daily reports)

1. Go to [slack.com](https://slack.com) → Create or open your workspace
2. Go to [api.slack.com/apps](https://api.slack.com/apps) → **Create New App** → From Scratch
3. Name: `LinguAI Bot` → Select your workspace → Create
4. Click **Incoming Webhooks** → Toggle **Activate** → Add to Workspace
5. Choose your channel → **Authorize** → Copy webhook URL → `SLACK_WEBHOOK_URL`

### GitHub Token (For automated commits)

1. Go to [github.com](https://github.com) → Settings → Developer settings
2. Personal access tokens → Tokens (classic) → Generate new token
3. Name: `linguai-automation` | Expiration: No expiration | Scopes: `repo`
4. Copy token → `GITHUB_TOKEN`
5. Also update remote URL:
   ```bash
   cd /path/to/language-learning-app
   git remote set-url origin https://YOUR_TOKEN@github.com/unclassified-hokage/language-learning-app.git
   ```

---

## Step 6: Run the Database Schema

1. Open [supabase.com](https://supabase.com) → Your project → **SQL Editor**
2. Copy the contents of `database/schema.sql`
3. Paste and click **Run**

This creates all tables, RLS policies, and indexes.

---

## Step 7: Run the App

```bash
cd app
flutter pub get        # Download all packages
flutter devices        # List available simulators/devices
flutter run            # Run on default device (iPhone Simulator if Xcode installed)
```

To run on a specific device:

```bash
flutter run -d "iPhone 15 Pro"   # iOS Simulator
flutter run -d chrome             # Web (for quick testing)
```

---

## Step 8: Set Up Daily Autonomous Claude Task (Optional)

If you use Claude Code CLI, set up the daily automation:

```bash
chmod +x scripts/setup-claude-task.sh
./scripts/setup-claude-task.sh
```

This creates a scheduled task that:
- Runs daily at 9:06 AM
- Advances the project (docs, code, architecture)
- Sends a Slack notification + email with progress
- Commits and pushes to GitHub

---

## Project Structure

```
language-learning-app/
├── app/                    # Flutter mobile app (iOS + Android)
│   ├── lib/
│   │   ├── core/           # Theme, router, auth, config
│   │   ├── features/       # Feature modules (onboarding, lessons, scenarios, AI chat...)
│   │   └── shared/         # Models, widgets, repositories
│   └── pubspec.yaml        # Flutter dependencies
├── database/
│   └── schema.sql          # Full Supabase/PostgreSQL schema
├── docs/
│   ├── architecture/       # System design, data model, AI system, infra costs
│   ├── design/             # UI/UX direction, colour system
│   ├── features/           # Feature specifications
│   ├── flows/              # User journey and screen flows
│   └── api-specs/          # API endpoint documentation
├── research/               # Market research, gap analysis
├── reports/daily/          # Auto-generated daily progress reports
├── scripts/
│   ├── setup.sh            # One-command full environment setup
│   └── setup-claude-task.sh # Set up Claude Code daily automation
├── .env.example            # Template for environment variables (commit this)
├── .env.local              # Real secrets — gitignored, never commit
├── APPROVALS.md            # Async permission requests for autonomous Claude sessions
├── CLAUDE.md               # Project context for Claude Code
├── README.md               # Project overview
└── SETUP.md                # This file
```

---

## Environments

| Environment | Purpose | Supabase Project | Flutter flavor |
|------------|---------|-----------------|----------------|
| `dev` | Local development | `linguai-dev` | `--flavor dev` |
| `uat` | Testing / beta | `linguai-uat` | `--flavor uat` |
| `prod` | Live app stores | `linguai-prod` | `--flavor prod` |

For now, just use `dev`. UAT and prod come before beta testing.

---

## Troubleshooting

**`flutter: command not found`**
```bash
source ~/.zshrc   # Reload shell config
```

**`flutter doctor` shows issues**
Run `flutter doctor -v` for verbose output. Common fixes:
- Xcode license: `sudo xcodebuild -license accept`
- Android SDK: Install Android Studio → open SDK Manager → install SDK 34
- CocoaPods (iOS): `sudo gem install cocoapods`

**`pub get` fails**
```bash
flutter clean
flutter pub get
```

**Supabase connection fails**
- Check `.env.local` has correct `SUPABASE_URL` and `SUPABASE_ANON_KEY`
- Make sure the Supabase project is active (not paused — free tier pauses after 1 week of inactivity)

---

## Contributing

This is open source. Once the MVP is stable, contribution guidelines will be added.
For now, all development is managed through the Claude Code daily task and this GitHub repository.

---

*Last updated: 2026-03-09*
