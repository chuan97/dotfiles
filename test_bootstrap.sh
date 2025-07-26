#!/bin/bash
set -euo pipefail

echo "🧪 Starting bootstrap test in fakehome..."

FAKEHOME="$HOME/fakehome"
FAKEDOTFILES="$FAKEHOME/dotfiles"

# Clean slate
echo "🧹 Cleaning previous fakehome..."
rm -rf "$FAKEHOME"

echo "📁 Creating fakehome..."
mkdir -p "$FAKEHOME"

echo "📥 Copying dotfiles (excluding .git and sockets)..."
rsync -a --exclude='.git' "$HOME/dotfiles/" "$FAKEDOTFILES/"

echo "🔓 Making bootstrap executable..."
chmod +x "$FAKEDOTFILES/bootstrap.sh"

echo "🚀 Running bootstrap.sh in fake environment..."
env HOME="$FAKEHOME" "$FAKEDOTFILES/bootstrap.sh"

echo "✅ Test bootstrap complete."
echo "🔍 Inspect test environment at: $FAKEHOME"
echo "🧼 When you're done, run the following to clean up:"
echo "    rm -rf \"$FAKEHOME\""
