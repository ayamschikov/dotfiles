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
call plug#begin('~/.vim/plugged')
    " Utility
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'SirVer/ultisnips'
    Plug 'benmills/vimux'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'ervandew/supertab'
    Plug 'gilsondev/searchtasks.vim'
    Plug 'godlygeek/tabular'
    " todo: check it
    " Plug 'jceb/vim-orgmode'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-speeddating'
    " todo: check it
    " Plug 'wakatime/vim-wakatime'
    Plug 'wesQ3/vim-windowswap'
    Plug 'easymotion/vim-easymotion'
    Plug 'tmux-plugins/vim-tmux' | Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'mileszs/ack.vim', { 'do': 'brew install ack' }
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-dadbod'
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'google/vim-searchindex'
    Plug 'skwp/greplace.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'mhinz/vim-startify' 
    Plug 'lifepillar/pgsql.vim'
    Plug 'airblade/vim-rooter'
    Plug 'jiangmiao/auto-pairs'
    Plug 'kevinhui/vim-docker-tools'
    Plug 'nicr9/vim-orca'
    Plug 'junegunn/vim-peekaboo'

    " Generic Programming Support 
    Plug 'honza/vim-snippets'
    Plug 'Townk/vim-autoclose'
    Plug 'janko-m/vim-test'
    " todo: call plugin only on js files
    Plug 'maksimr/vim-jsbeautify'
    Plug 'vim-syntastic/syntastic'
    Plug 'neomake/neomake'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-sleuth'

    " Markdown / Writting
    Plug 'tpope/vim-markdown'
    Plug 'jtratner/vim-flavored-markdown'

    " Git Support
    Plug 'kablamo/vim-git-log'
    Plug 'gregsexton/gitv', { 'on': ['Gitv'] }
    Plug 'tpope/vim-fugitive'
    " TODO: check it, maybe i dont need this plugin anymore
    Plug 'airblade/vim-gitgutter'
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'sodapopcan/vim-twiggy'

    " Erlang Support
    Plug 'vim-erlang/vim-erlang-tags'
    Plug 'vim-erlang/vim-erlang-runtime'
    Plug 'vim-erlang/vim-erlang-compiler'

    " Elixir Support 
    Plug 'elixir-lang/vim-elixir'
    Plug 'avdgaag/vim-phoenix'
    Plug 'mmorearty/elixir-ctags'
    Plug 'mattreduce/vim-mix'
    Plug 'BjRo/vim-extest'
    Plug 'frost/vim-eh-docs'
    Plug 'slashmili/alchemist.vim'
    Plug 'tpope/vim-endwise'
    Plug 'jadercorrea/elixir_generator.vim'
    Plug 'mhinz/vim-mix-format'

    " Rails Support
    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-rails'
    Plug 'ngmy/vim-rubocop'
    " Elm Support
    Plug 'lambdatoast/elm.vim'

    " Theme / Interface
    Plug 'sjl/badwolf'
    Plug 'tomasr/molokai'
    Plug 'morhetz/gruvbox'
    Plug 'zenorocha/dracula-theme', {'rtp': 'vim/'}
    Plug 'junegunn/limelight.vim'
    Plug 'mkarmona/colorsbox'
    Plug 'romainl/Apprentice'
    Plug 'Lokaltog/vim-distinguished'
    Plug 'w0ng/vim-hybrid'
    Plug 'AlessandroYorba/Sierra'
    Plug 'daylerees/colour-schemes'
    Plug 'effkay/argonaut.vim'
    Plug 'ajh17/Spacegray.vim'
    Plug 'colepeters/spacemacs-theme.vim'
    Plug 'dylanaraps/wal.vim'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'whatyouhide/vim-gotham'
    Plug 'nanotech/jellybeans.vim'
    Plug 'danilo-augusto/vim-afterglow'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'joshdick/onedark.vim'
    Plug 'dikiaap/minimalist'
call plug#end()

filetype plugin indent on
syntax on

set number
set ignorecase
set smartcase
set incsearch
set hlsearch
set noswapfile
set undolevels=10000
set undofile
set undodir=$HOME/.vim/undodir
set autoindent
set expandtab
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set showcmd
set autowrite
set autoread
set laststatus=2
set showmatch
set updatetime=100
set splitbelow
set splitright
set foldmethod=indent
set foldlevelstart=20
set noesckeys
set ttimeoutlen=200
set ttimeout
set encoding=utf-8
set grepprg=ack
set wildmenu
set wildmode=longest,full
set cursorline
set infercase
set wildignore=*.o,*~,*.pyc
set lazyredraw
set magic
set mat=2
set foldcolumn=0
set nowrap
" OSX stupid backspace fix
set backspace=indent,eol,start
" Syntastic Configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

if !has('gui_running')
    set t_Co=256
endif

colorscheme jellybeans

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
	    \   'right': [ [ 'syntastic', 'lineinfo' ],
	    \              [ 'percent' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }


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
let NERDTreeShowBookmarks=1
let g:NERDTreeNodeDelimiter = "\u00a0"
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" auto close nerdtree if it is last window in tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_override_sign_column_highlight = 0
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_remote_branch_sort = 'date'

let g:rooter_patterns = ['.git', '.git/']
let g:rooter_manual_only = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd QuickFixCmdPost *grep* cwindow

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
autocmd BufWritePre *.rb :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.py :call <SID>StripTrailingWhitespaces()

let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""

" Enable Elite mode, No ARRRROWWS!!!!
let g:elite_mode=1

"let base16colorspace=256  " Access colors present in 256 colorspace
let g:challenger_deep_termcolors = 256

let g:spacegray_underline_search = 1
let g:spacegray_italicize_comments = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_enable_elixir_checker = 1
" let g:syntastic_elixir_checkers = ["elixir"]

" Neomake settings
autocmd! BufWritePost * Neomake
let g:neomake_elixir_enabled_makers = ['mix', 'credo', 'dogma']

" Markdown Syntax Support
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Vim-Alchemist Configuration
let g:alchemist#elixir_erlang_src = "/Users/amacgregor/Projects/Github/alchemist-source"
let g:alchemist_tag_disable = 1

" Vim-Supertab Configuration
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

" Vim-UtilSnips Configuration
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical" " If you want :UltiSnipsEdit to split your window.

" Vim-Test Configuration
let test#strategy = "vimux"

function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" Elixir Tagbar Configuration
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records',
        \ 't:tests'
    \ ]
    \ }

" Fzf Configuration
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
map <SPACE> <leader>

" Act like D and C
nnoremap Y y$

" Enables you to save files with :w!! by using sudo if you forgot to open it as root
cmap w!! %!sudo tee > /dev/null %

" tabs
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<CR>

" Git
nnoremap gr :Gread<CR>
nnoremap gw :Gwrite<CR>
nnoremap gh :!git hist<CR>
nnoremap gp :!git push origin HEAD<CR>
nnoremap gci :Gcommit<CR>
nnoremap gs :silent Gstatus<CR>
nnoremap gvf :Gvdiff<CR>
nnoremap <leader>h :Gitv<CR>
nnoremap <leader>g :Ggrep 
vnoremap <leader>g y:Ggrep '<C-R>"'<CR>
nnoremap <leader>br :Twiggy<CR>

nmap j gj
nmap k gk

map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

nnoremap Q q
nnoremap q :q<CR>

nmap <Leader>r :Rg<CR>
vnoremap <leader>r y:Rg <C-R>"<CR>

" Rails
nmap <Leader>s :A<CR>

nnoremap <leader>a :Ack! 
vnoremap <leader>a y:Ack! '<C-R>"'<CR>
map <C-m> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>

" Easy motion
map <Leader>j <Plug>(easymotion-s)

" Docker
nmap <Leader>d :DockerToolsToggle<CR>
nmap <Leader>dcu :DCup<CR>
nmap <Leader>dcs :DCstop<CR>
nmap <Leader>dcp :DCps<CR>

" QuickFixList navigation
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>c :ccl<CR>

" search visually selected text
vnoremap // y/<C-R>"<CR>
nmap <Leader>n :echo @%<CR>
nmap <Leader>q :set paste!<CR>
noremap <Leader>y "*y

" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Shortcuts
nnoremap <Leader>w :w<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>b :Buffers<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Vim-Test Mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
    nnoremap <Up>    :resize +2<CR>
    nnoremap <Down>  :resize -2<CR>
    nnoremap <Left>  :vertical resize +2<CR>
    nnoremap <Right> :vertical resize -2<CR>
endif

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" Vim-Alchemist Mappings
autocmd FileType elixir nnoremap <buffer> <leader>h :call alchemist#exdoc()<CR>
autocmd FileType elixir nnoremap <buffer> <leader>d :call alchemist#exdef()<CR>
