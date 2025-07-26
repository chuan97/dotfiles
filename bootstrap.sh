#!/bin/bash
set -e

echo "🔧 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

echo "🔌 Installing zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "🔗 Symlinking dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"

for file in "$DOTFILES_DIR"/.*; do
  filename=$(basename "$file")

  # Skip irrelevant files
  [[ "$filename" == "." || "$filename" == ".." || "$filename" == ".git" || "$filename" == ".gitignore" || "$filename" == ".DS_Store" ]] && continue

  src="$DOTFILES_DIR/$filename"
  dest="$HOME/$filename"

  # Only link regular files or symlinks
  if [[ -f "$src" || -L "$src" ]]; then
    # Backup existing file (if not already a symlink)
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      backup="${dest}.backup.$(date +%s)"
      mv "$dest" "$backup"
      echo "  🔁 Backed up existing $filename to $(basename "$backup")"
    fi

    echo "  🔗 Linking $filename → $dest"
    ln -sf "$src" "$dest"
  else
    echo "  ⚠️ Skipping $filename (not a regular file)"
  fi
done

echo "📁 Symlinking XDG config files..."
CONFIG_SOURCE_DIR="$DOTFILES_DIR/config"
CONFIG_TARGET_DIR="$HOME/.config"

mkdir -p "$CONFIG_TARGET_DIR"

for src in "$CONFIG_SOURCE_DIR"/*; do
  name=$(basename "$src")
  dest="$CONFIG_TARGET_DIR/$name"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    backup="${dest}.backup.$(date +%s)"
    mv "$dest" "$backup"
    echo "  🔁 Backed up existing $name to $(basename "$backup")"
  fi

  echo "  🔗 Linking $name → $dest"
  ln -sfn "$src" "$dest"
done

echo "🎉 Bootstrap complete! Restart your terminal."