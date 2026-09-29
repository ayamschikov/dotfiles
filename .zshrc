# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  docker-compose
  git-flow
  vi-mode
  history-substring-search
  colored-man-pages
  asdf
)

# Homebrew's `zsh-completions` formula. (`site-functions` is already on FPATH
# via `brew shellenv` in ~/.zprofile.) Must run BEFORE oh-my-zsh's compinit so
# these register in the completion dump — that's why FPATH is set here, not below.
if type brew &>/dev/null; then
  FPATH="${HOMEBREW_PREFIX:-$(brew --prefix)}/share/zsh-completions:$FPATH"
fi

# oh-my-zsh runs compinit once (compinit -i -d "$ZSH_COMPDUMP"). Do NOT call
# compinit again later — each extra call re-runs compaudit over the whole fpath.
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Full UTF-8 locale. Required so wcwidth/box-drawing render at correct width
# (fixes TUI text overlap under tmux). C.UTF-8 and the invalid LC_CTYPE=UTF-8
# fall back to narrow C width tables. LC_ALL overrides any stray LC_CTYPE.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR='nvim'
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias clear_vifm_trash="rm -rf ~/.local/share/vifm/Trash/*"
alias dc="docker compose"

# Память одной командой — следи за этим вместо «ощущений».
# Настоящий сигнал = pressure-level от ядра + тренд swap/compressor, НЕ сырой free
# (macOS держит free низким специально, inactive-страницы отдаются мгновенно).
# 🟡/🔴 ИЛИ растущий swap = пора закрывать лишнее (обычно браузерные вкладки).
memcheck() {
  local ps=16384 free ina pur comp used lvl label
  free=$(vm_stat | awk '/Pages free/             {gsub(/\./,"",$3); print $3}')
  ina=$(vm_stat  | awk '/Pages inactive/         {gsub(/\./,"",$3); print $3}')
  pur=$(vm_stat  | awk '/Pages purgeable/        {gsub(/\./,"",$3); print $3}')
  comp=$(vm_stat | awk '/occupied by compressor/ {gsub(/\./,"",$5); print $5}')
  used=$(sysctl -n vm.swapusage | awk '{print $6}')
  lvl=$(sysctl -n kern.memorystatus_vm_pressure_level)
  case $lvl in 1) label="🟢 норма";; 2) label="🟡 warning";; 4) label="🔴 critical";; *) label="? ($lvl)";; esac
  printf "pressure: %s | доступно ~%d MB | swap used: %s | compressor: %d MB\n" \
    "$label" $(((free+ina+pur)*ps/1048576)) "$used" $((comp*ps/1048576))
}
export FZF_DEFAULT_COMMAND='rg -l --hidden -g \!.git .'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/ruby@2.7/bin:$PATH"

unsetopt HIST_VERIFY
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export AWS_PROFILE=staging
export NVIM_APPNAME=lazy_vim

# Secrets (OPENROUTER_API_KEY, JIRA_API_TOKEN, etc.) live in ~/.zshrc.local,
# which is intentionally outside this dotfiles repo.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '~/yandex-cloud/path.bash.inc' ]; then source '~/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '~/yandex-cloud/completion.zsh.inc' ]; then source '~/yandex-cloud/completion.zsh.inc'; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ayamschikov/.lmstudio/bin"
# End of LM Studio CLI section


# Created by `pipx` on 2025-12-11 22:50:15
export PATH="$PATH:/Users/ayamschikov/.local/bin"

# Go binaries
export PATH="$HOME/go/bin:$PATH"
