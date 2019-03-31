" vim-bootstrap 017f592

"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "elixir,python,ruby"
let g:vim_bootstrap_editor = "vim"				" nvim or vim

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
    " https://github.com/scrooloose/nerdtree
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    " https://github.com/jistr/vim-nerdtree-tabs
    Plug 'jistr/vim-nerdtree-tabs'
    " https://github.com/tpope/vim-commentary
    Plug 'tpope/vim-commentary'
    " https://github.com/tpope/vim-fugitive
    Plug 'tpope/vim-fugitive'
    " https://github.com/vim-airline/vim-airline
    Plug 'vim-airline/vim-airline'
    " https://github.com/vim-airline/vim-airline-themes
    Plug 'vim-airline/vim-airline-themes'
    " https://github.com/airblade/vim-gitgutter
    Plug 'airblade/vim-gitgutter'
    " https://github.com/vim-scripts/grep.vim
    Plug 'vim-scripts/grep.vim'
    " https://github.com/vim-scripts/CSApprox
    Plug 'vim-scripts/CSApprox'
    " https://github.com/bronson/vim-trailing-whitespace
    Plug 'bronson/vim-trailing-whitespace'
    " https://github.com/Raimondi/delimitMate
    Plug 'Raimondi/delimitMate'
    " https://github.com/majutsushi/tagbar
    Plug 'majutsushi/tagbar'
    " https://github.com/scrooloose/syntastic
    Plug 'scrooloose/syntastic'
    " https://github.com/Yggdroot/indentLine
    Plug 'Yggdroot/indentLine'
    " https://github.com/avelino/vim-bootstrap-updater
    Plug 'avelino/vim-bootstrap-updater'
    " https://github.com/sheerun/vim-polyglot
    Plug 'sheerun/vim-polyglot'

    " https://github.com/junegunn/fzf
    " https://github.com/junegunn/fzf.vim
    if isdirectory('/usr/local/opt/fzf')
      Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    else
      Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
      Plug 'junegunn/fzf.vim'
    endif

    let g:make = 'gmake'
    if exists('make')
      let g:make = 'make'
    endif

    " https://github.com/Shougo/vimproc.vim
    Plug 'Shougo/vimproc.vim', {'do': g:make}

    "" Vim-Session
    " https://github.com/xolox/vim-misc
    Plug 'xolox/vim-misc'
    " https://github.com/xolox/vim-session
    Plug 'xolox/vim-session'

    if v:version >= 703
      " https://github.com/Shougo/vimshell.vim
      Plug 'Shougo/vimshell.vim'
    endif

    if v:version >= 704
      "" Snippets
      " https://github.com/SirVer/ultisnips
      Plug 'SirVer/ultisnips'
    endif

    " https://github.com/honza/vim-snippets
    Plug 'honza/vim-snippets'

    "" Color
    " https://github.com/tomasr/molokai
    Plug 'tomasr/molokai'

    "*****************************************************************************
    "" Custom bundles
    "*****************************************************************************

    " elixir
    " https://github.com/elixir-lang/vim-elixir
    Plug 'elixir-lang/vim-elixir'
    " https://github.com/carlosgaldino/elixir-snippets
    Plug 'carlosgaldino/elixir-snippets'


    " python
    "" Python Bundle
    " https://github.com/davidhalter/jedi-vim
    Plug 'davidhalter/jedi-vim'
    " https://github.com/raimon49/requirements.txt.vim
    Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}


    " ruby
    " https://github.com/tpope/vim-rails
    Plug 'tpope/vim-rails'
    " https://github.com/tpope/vim-rake
    Plug 'tpope/vim-rake'
    " https://github.com/tpope/vim-projectionist
    Plug 'tpope/vim-projectionist'
    " https://github.com/thoughtbot/vim-rspec
    Plug 'thoughtbot/vim-rspec'
    " https://github.com/ecomba/vim-ruby-refactoring
    Plug 'ecomba/vim-ruby-refactoring'


    "*****************************************************************************
    "*****************************************************************************

    "" Include user's extra bundle
    if filereadable(expand("~/.vimrc.local.bundles"))
      source ~/.vimrc.local.bundles
    endif

    "*****************************************************************************
    "*****************************************************************************
    " My bundles

    " display search result's counting
    " https://github.com/google/vim-searchindex
    Plug 'google/vim-searchindex'

    " https://vimawesome.com/plugin/vim-rubocop
    Plug 'ngmy/vim-rubocop'
    " https://vimawesome.com/plugin/easymotion
    Plug 'easymotion/vim-easymotion'

    " syntax highlighting for tmux.conf + other cool options
    "  https://github.com/tmux-plugins/vim-tmux
    "   press 'K' to open tmux' man page
    "  https://github.com/tmux-plugins/vim-tmux-focus-events
    Plug 'tmux-plugins/vim-tmux' | Plug 'tmux-plugins/vim-tmux-focus-events'
    " seemless navigation between vim windows / tmux pane
    " https://github.com/christoomey/vim-tmux-navigator
    Plug 'christoomey/vim-tmux-navigator'

    " Git wrappers
    " Show git status in nerdtree
    " https://github.com/Xuyuanp/nerdtree-git-plugin
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    " git branching
    " https://vimawesome.com/plugin/twiggy
    Plug 'sodapopcan/vim-twiggy'
    " Display commits for project / file
    " https://vimawesome.com/plugin/gitv
    Plug 'gregsexton/gitv', { 'on': ['Gitv'] }

    " surrounding with whatever you want (paranthesis, quotes...)
    " https://github.com/tpope/vim-surround
    Plug 'tpope/vim-surround'
    " substitute with pattern, chage camel-(or other)case to another, create
    " spell checker
    " https://github.com/tpope/vim-abolish
    Plug 'tpope/vim-abolish'

    " the . command can repeat whatever you want!
    " http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
    " https://github.com/tpope/vim-repeat
    Plug 'tpope/vim-repeat'
    "
    "
    "
    "
    "
    "
    "
    "
    " database interface
    " https://vimawesome.com/plugin/vim-dadbod
    Plug 'tpope/vim-dadbod'
    " postgresql support plugin
    " https://github.com/lifepillar/pgsql.vim
    Plug 'lifepillar/pgsql.vim'

    " testing
    " https://github.com/tpope/vim-dispatch
    Plug 'tpope/vim-dispatch'

    " Ack-grep
    " https://github.com/mileszs/ack.vim
    Plug 'mileszs/ack.vim', { 'do': 'brew install ack' }

    " Colourschemes
    " https://github.com/whatyouhide/vim-gotham
    Plug 'whatyouhide/vim-gotham'
    " https://github.com/nanotech/jellybeans.vim
    Plug 'nanotech/jellybeans.vim'
    " https://github.com/danilo-augusto/vim-afterglow
    Plug 'danilo-augusto/vim-afterglow'
    " https://github.com/dracula/vim
    Plug 'dracula/vim', { 'as': 'dracula' }
    " https://github.com/joshdick/onedark.vim
    Plug 'joshdick/onedark.vim'
    " https://github.com/dikiaap/minimalist
    Plug 'dikiaap/minimalist'


    " status bar
    " https://github.com/itchyny/lightline.vim
    " Plug 'itchyny/lightline.vim'

    " Start screen
    " https://github.com/mhinz/vim-startify
    " Plug 'mhinz/vim-startify'


    " vim tips
    " https://github.com/hobbestigrou/vimtips-fortune
    " Plug 'hobbestigrou/vimtips-fortune'

    " auto change cur dir to project root
    " https://github.com/airblade/vim-rooter
    " Plug 'airblade/vim-rooter'

    " Docker
    " https://vimawesome.com/plugin/vim-docker-tools
    Plug 'kevinhui/vim-docker-tools'
    " https://github.com/nicr9/vim-orca
    Plug 'nicr9/vim-orca'

    " Ruby
    " https://github.com/vim-ruby/vim-ruby
    Plug 'vim-ruby/vim-ruby'

    " Auto-pair
    " https://github.com/jiangmiao/auto-pairs
    Plug 'jiangmiao/auto-pairs'

    " Peekabo
    " show available registers after pressing " or @
    " https://github.com/junegunn/vim-peekaboo
    Plug 'junegunn/vim-peekaboo'

    " Autocomplete
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif

    " Snippets
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    " https://github.com/garbas/vim-snipmate
    Plug 'garbas/vim-snipmate'
call plug#end()

" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to space
let mapleader=' '

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
  colorscheme molokai
endif

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1

  
  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
  
endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 40
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <C-m> :NERDTreeFind<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" grep.vim
nnoremap <silent> <leader>fi :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" vimshell.vim
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '

" terminal emulation
if g:vim_bootstrap_editor == 'nvim'
  nnoremap <silent> <leader>sh :terminal<CR>
else
  nnoremap <silent> <leader>sh :VimShellCreate<CR>
endif

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>

" snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"

" syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_auto_loc_list=1
let g:syntastic_aggregate_errors = 1

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" elixir


" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0

" syntastic
let g:syntastic_python_checkers=['python', 'flake8']

" vim-airline
let g:airline#extensions#virtualenv#enabled = 1

" Syntax highlight
" Default highlight is better than polyglot
let g:polyglot_disabled = ['python']
let python_highlight_all = 1


" ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" For ruby refactory
if has('nvim')
  runtime! macros/matchit.vim
else
  packadd! matchit
endif

" Ruby refactory
nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rcpc :RConvertPostConditional<cr>
nnoremap <leader>rel  :RExtractLet<cr>
vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
nnoremap <leader>rit  :RInlineTemp<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>


"*****************************************************************************
"*****************************************************************************

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"*****************************************************************************
"" Convenience variables
"*****************************************************************************

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif


" custom options and mappings
"
"
" *******************************
" *******************************
" *******************************

" Act like D and C
nnoremap Y y$
" Turn off linewise keys. Normally, the `j' and `k' keys move the cursor down one entire line. with line wrapping on, this can cause the cursor to
" actually skip a few lines on the screen because it's moving from line N to line N+1 in the file. I want this to act more visually -- I want `down' to
" mean the next line on the screen
nmap j gj
nmap k gk

set undolevels=10000
set undofile
set undodir=$HOME/.vim/undodir
set autoindent
set shiftround
set showcmd
set autowrite
set showmatch
set updatetime=100
set splitbelow
set splitright
set foldmethod=indent
set foldlevelstart=20
set noesckeys
set ttimeoutlen=200
set ttimeout

" tabs
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<CR>

" Git
nnoremap gr :Gread<CR>
nnoremap gh :!git hist<CR>
nnoremap gp :!git push origin HEAD<CR>
nnoremap <leader>h :Gitv<CR>
nnoremap <leader>g :Ggrep
vnoremap <leader>g y:Ggrep '<C-R>"'<CR>
nnoremap <leader>l :Twiggy<CR>


" Edit .vimrc
map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>
nnoremap <Leader>pi :PlugInstall<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

nmap <Leader>f :Files<CR>
" nmap <Leader>t :Tags<CR>
" nmap <Leader>b :Buffers<CR>

" Rails
" nmap <Leader>s :A<CR>
" nmap <Leader>r :R<CR>

colorscheme jellybeans

" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'active': {
" 	    \   'right': [ [ 'syntastic', 'lineinfo' ],
" 	    \              [ 'percent' ],
"       \              [ 'gitbranch' ] ]
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'fugitive#head'
"       \ },
"       \ }

" NERDTree

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer = 1
" let g:NERDTreeNodeDelimiter = "\u00a0"
" let NERDTreeMinimalUI = 1
" let NERDTreeDirArrows = 1
" auto close nerdtree if it is last window in tab
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTree end

" Gitgutter settings
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_override_sign_column_highlight = 0

" Rooter
let g:rooter_patterns = ['tags', '.git', '.git/']

" Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{FugitiveStatusline()}
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Syntastic end

" search visually selected text
vnoremap // y/<C-R>"<CR>

autocmd QuickFixCmdPost *grep* cwindow
" Git branching
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_remote_branch_sort = 'date'

" Easy motion
map <Leader>j <Plug>(easymotion-s)

" Docker
nmap <Leader>do :DockerToolsToggle<CR>
nmap <Leader>dcu :DCup<CR>
nmap <Leader>dcs :DCstop<CR>
nmap <Leader>dcp :DCps<CR>

" QuickFixList navigation
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>

" show error if string is longer than 160 chars
:match ErrorMsg '\%>160v.\+'

" remove trailing spaces
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.rb,*.py :call <SID>StripTrailingWhitespaces()

" nmap <Leader>q :set paste!<CR>

" let g:deoplete#enable_at_startup = 1
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
