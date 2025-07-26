#!/bin/bash
set -e

echo "🔧 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed."
fi

echo "🔌 Installing zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

echo "🔗 Symlinking dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"

for file in "$DOTFILES_DIR"/.*; do
  filename=$(basename "$file")

  # Skip .git, .gitignore, .DS_Store, and the current and parent directories
  [[ "$filename" == "." || "$filename" == ".." || "$filename" == ".git" || "$filename" == ".gitignore" || "$filename" == ".DS_Store" ]] && continue

  echo "→ Linking $filename"
  ln -sf "$DOTFILES_DIR/$filename" "$HOME/$filename"
done

echo "✅ All dotfiles linked."

echo "✅ Bootstrap complete! Restart your terminal."
