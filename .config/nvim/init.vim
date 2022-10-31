source ~/.config/nvim/configs/plugins.vim
source ~/.config/nvim/configs/config.vim
source ~/.config/nvim/configs/plugins_config.vim
source ~/.config/nvim/configs/bindings.vim

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)
