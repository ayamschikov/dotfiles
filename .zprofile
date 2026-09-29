
# Cache `brew shellenv`: running brew forks a subprocess, and on this machine a
# security agent taxes every exec ~260ms, so the fork alone costs ~1.3s per login.
# Its output is effectively static — regenerate only when the brew binary changes.
# The `[[ ]]`/`-nt` tests are shell builtins (no fork); brew runs only when stale.
__brew_env_cache="$HOME/.cache/brew_shellenv.zsh"
[[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"
if [[ ! -s "$__brew_env_cache" || /opt/homebrew/bin/brew -nt "$__brew_env_cache" ]]; then
  /opt/homebrew/bin/brew shellenv > "$__brew_env_cache"
fi
source "$__brew_env_cache"
unset __brew_env_cache

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Created by `pipx` on 2025-12-11 22:50:15
export PATH="$PATH:/Users/ayamschikov/.local/bin"
