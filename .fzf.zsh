# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ayamschikov/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/ayamschikov/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ayamschikov/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/ayamschikov/.fzf/shell/key-bindings.zsh"
