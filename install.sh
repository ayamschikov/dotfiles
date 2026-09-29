#!/usr/bin/env bash
# Link dotfiles from this repo into $HOME. Safe to re-run: correct links are
# skipped, anything else in the way is moved aside to <name>.bak-<timestamp>.
# Kept bash 3.2 compatible (macOS /bin/bash).
set -u

current_dir="$(cd "$(dirname "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

files_to_link=(
  .config/nvim
  .config/vifm
  .config/lazy_vim
  .config/karabiner
  .config/htop
  .config/diffx
  .config/tmuxinator/baldurs_gate.yml
  .config/tmuxinator/cs_cart.yml
  .config/tmuxinator/cynology.yml
  .config/tmuxinator/german-tests.yml
  .config/tmuxinator/individual_enterpreneur.yml
  .config/tmuxinator/kuber_day1.yml
  .config/tmuxinator/learning.yml
  .gitconfig
  .gitignore_global
  .markdownlint.json
  .rvmrc
  .terraformrc
  .tmux.conf
  .tmux/claude.conf
  .zlogin
  .zprofile
  .zshrc
  # Claude Code: personal hooks, skills and status line. Hooks are wired up
  # in ~/.claude/settings.json, which is not tracked here.
  .claude/bin/review
  .claude/hooks/block-fulldisk-find.py
  .claude/hooks/declare-cuts.py
  .claude/hooks/lib-tmux-pane.sh
  .claude/hooks/notify.sh
  .claude/hooks/tmux-state.sh
  .claude/skills/diffx-finish-review
  .claude/skills/diffx-start-review
  .claude/skills/local-review
  .claude/statusline.sh
  .claude/statusline.ts
)

for link_file in "${files_to_link[@]}"; do
  src="$current_dir/$link_file"
  dst="$HOME/$link_file"

  if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
    continue
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$stamp" && echo "Moved existing '~/$link_file' to '~/$link_file.bak-$stamp'"
  fi
  ln -s "$src" "$dst" && echo "Created symlink '~/$link_file'"
done

if command -v brew >/dev/null 2>&1; then
  echo "Install packages with: brew bundle --file='$current_dir/Brewfile'"
fi
