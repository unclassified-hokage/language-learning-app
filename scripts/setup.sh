#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# LinguAI — One-Command Setup Script
# Run this on any fresh machine to get the full dev environment.
# ─────────────────────────────────────────────────────────────────────────────
set -e

FLUTTER_VERSION="3.19.6"
FLUTTER_INSTALL_DIR="$HOME/development"

# Colours
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC}   $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERR]${NC}  $1"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   LinguAI — Development Setup            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Detect OS and chip ────────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

info "Detected: $OS / $ARCH"

if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
  error "Unsupported OS: $OS. This script supports macOS and Linux."
fi

# ── macOS: Install Xcode CLI tools ────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode command-line tools..."
    xcode-select --install
    warn "After Xcode tools install completes, run this script again."
    exit 0
  else
    success "Xcode CLI tools already installed"
  fi
fi

# ── Check if Flutter already installed ───────────────────────────────────────
if command -v flutter &>/dev/null; then
  success "Flutter already installed: $(flutter --version --machine 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('frameworkVersion','unknown'))" 2>/dev/null || echo 'version unknown')"
  FLUTTER_ALREADY_INSTALLED=true
else
  FLUTTER_ALREADY_INSTALLED=false
fi

# ── Install Flutter ───────────────────────────────────────────────────────────
if [[ "$FLUTTER_ALREADY_INSTALLED" == "false" ]]; then
  info "Installing Flutter $FLUTTER_VERSION..."
  mkdir -p "$FLUTTER_INSTALL_DIR"

  if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
      URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${FLUTTER_VERSION}-stable.zip"
      FILENAME="flutter_macos_arm64_${FLUTTER_VERSION}-stable.zip"
    else
      URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${FLUTTER_VERSION}-stable.zip"
      FILENAME="flutter_macos_${FLUTTER_VERSION}-stable.zip"
    fi

    info "Downloading Flutter for macOS ($ARCH)..."
    cd "$FLUTTER_INSTALL_DIR"
    curl -# -O "$URL"
    info "Extracting..."
    unzip -q "$FILENAME"
    rm "$FILENAME"

  elif [[ "$OS" == "Linux" ]]; then
    URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    FILENAME="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

    info "Downloading Flutter for Linux..."
    cd "$FLUTTER_INSTALL_DIR"
    curl -# -O "$URL"
    info "Extracting..."
    tar xf "$FILENAME"
    rm "$FILENAME"
  fi

  # Add Flutter to PATH
  SHELL_RC=""
  if [[ -f "$HOME/.zshrc" ]]; then SHELL_RC="$HOME/.zshrc"
  elif [[ -f "$HOME/.bashrc" ]]; then SHELL_RC="$HOME/.bashrc"
  elif [[ -f "$HOME/.bash_profile" ]]; then SHELL_RC="$HOME/.bash_profile"
  fi

  if [[ -n "$SHELL_RC" ]]; then
    FLUTTER_PATH_LINE='export PATH="$HOME/development/flutter/bin:$PATH"'
    if ! grep -q "development/flutter" "$SHELL_RC"; then
      echo "" >> "$SHELL_RC"
      echo "# Flutter SDK" >> "$SHELL_RC"
      echo "$FLUTTER_PATH_LINE" >> "$SHELL_RC"
      info "Added Flutter to PATH in $SHELL_RC"
    fi
    export PATH="$HOME/development/flutter/bin:$PATH"
  fi

  success "Flutter installed at $FLUTTER_INSTALL_DIR/flutter"
fi

# ── Flutter pub get ───────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_DIR/app"

if [[ -d "$APP_DIR" ]]; then
  info "Running flutter pub get..."
  cd "$APP_DIR"
  flutter pub get
  success "Flutter packages installed"
else
  warn "app/ directory not found at $APP_DIR — skipping flutter pub get"
fi

# ── Create .env.local if it doesn't exist ────────────────────────────────────
ENV_FILE="$PROJECT_DIR/.env.local"
ENV_EXAMPLE="$PROJECT_DIR/.env.example"

if [[ ! -f "$ENV_FILE" ]]; then
  if [[ -f "$ENV_EXAMPLE" ]]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    success "Created .env.local from .env.example"
    warn "IMPORTANT: Edit .env.local and fill in your real API keys before running the app."
    warn "See SETUP.md for instructions on getting each key (all free)."
  fi
else
  success ".env.local already exists"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Setup Complete!                        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo -e "  ${GREEN}✓${NC} Flutter installed"
echo -e "  ${GREEN}✓${NC} Flutter packages downloaded"
echo -e "  ${GREEN}✓${NC} .env.local created"
echo ""
echo "  Next steps:"
echo "  1. Edit .env.local with your API keys (see SETUP.md)"
echo "  2. Run the database schema in Supabase (database/schema.sql)"
echo "  3. cd app && flutter run"
echo ""

# ── Flutter doctor ────────────────────────────────────────────────────────────
info "Running flutter doctor..."
echo ""
flutter doctor
