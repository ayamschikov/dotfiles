call plug#begin('~/.vim/plugged')
    " NERD tree will be loaded on the first invocation of NERDTreeToggle command
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    " display the result when searching
    Plug 'henrik/vim-indexed-search'

    " Rails
    " https://vimawesome.com/plugin/rails-vim
    Plug 'tpope/vim-rails'
    " rubocop
    " https://vimawesome.com/plugin/vim-rubocop
    Plug 'ngmy/vim-rubocop'

    " Multi language support
    Plug 'sheerun/vim-polyglot'

    " Easy motion
    " https://vimawesome.com/plugin/easymotion
    Plug 'easymotion/vim-easymotion'

    " syntax highlighting for tmux.conf + other cool options
    Plug 'tmux-plugins/vim-tmux' | Plug 'tmux-plugins/vim-tmux-focus-events'
    " seemless navigation between vim windows / tmux pane
    Plug 'christoomey/vim-tmux-navigator'

    " wrapper for git and display git diff in the left gutter
    Plug 'tpope/vim-fugitive' | Plug 'mhinz/vim-signify' 
    Plug 'xuyuanp/nerdtree-git-plugin'
    " https://vimawesome.com/plugin/gitv
    Plug 'gregsexton/gitv', {'on': ['Gitv']}
    " git branching
    " https://vimawesome.com/plugin/twiggy
    Plug 'sodapopcan/vim-twiggy'

    " Display commits for project / file
    Plug 'junegunn/gv.vim'

    " surrounding with whatever you want (paranthesis, quotes...)
    Plug 'tpope/vim-surround'
    " easily search, substitute and abbreviate multiple version of words
    Plug 'tpope/vim-abolish'
    " comment automatically
    Plug 'tpope/vim-commentary'
    " the . command can repeat whatever you want! http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
    Plug 'tpope/vim-repeat'
    " database interface
    " https://vimawesome.com/plugin/vim-dadbod
    Plug 'tpope/vim-dadbod'

    " Ack-grep
    Plug 'mileszs/ack.vim'

    " Buf kill
    Plug 'qpkorr/vim-bufkill'

    " Plug 'altercation/vim-colors-solarized'
    Plug 'nanotech/jellybeans.vim'

    " status bar
    Plug 'itchyny/lightline.vim'

    " Start screen
    Plug 'mhinz/vim-startify' 

    " Vagrant integration
    Plug 'hashivim/vim-vagrant'

    Plug 'scrooloose/syntastic'

    " postgresql support plugin
    Plug 'lifepillar/pgsql.vim'

    " vim tips
    "Plug 'hobbestigrou/vimtips-fortune'

    Plug 'airblade/vim-rooter'

    " composer integration
    Plug 'noahfrederick/vim-composer'

    Plug 'vim-scripts/matchit.zip'

    " JS plugin
    Plug 'pangloss/vim-javascript'
    Plug 'othree/javascript-libraries-syntax.vim'

    " Search files
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Docker
    " https://vimawesome.com/plugin/vim-docker-tools
    Plug 'kevinhui/vim-docker-tools'
call plug#end()

filetype plugin indent on
syntax on

map <SPACE> <leader>

" Act like D and C
nnoremap Y y$

" Enables you to save files with :w!! by using sudo if you forgot to open it
" as root
cmap w!! %!sudo tee > /dev/null %

set number
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch
set hlsearch

" no swap file! This is just annoying
set noswapfile

" number of undo saved in memory
set undolevels=10000
set undofile                 "turn on the feature
set undodir=$HOME/.vim/undodir  "directory where the undo files will be stored

" use 4 spaces instead of tab (to replace existing tab use :retab)
" copy indent from current line when starting a new line
set autoindent
set expandtab
set tabstop=2
set softtabstop=4
set shiftwidth=4
" when at 3 spaces, and I hit > ... go to 4, not 7
set shiftround

set showcmd       " display incomplete commands
set autowrite     " Automatically :write before running commands

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
nnoremap <leader>l :Twiggy<CR>


" Turn off linewise keys. Normally, the `j' and `k' keys move the cursor down one entire line. with line wrapping on, this can cause the cursor to
" actually skip a few lines on the screen because it's moving from line N to line N+1 in the file. I want this to act more visually -- I want `down' to
" mean the next line on the screen
nmap j gj
nmap k gk

" Edit .vimrc
map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>
nnoremap <Leader>pi :PlugInstall<CR>

nnoremap <Leader>w :w<CR>
nnoremap q :q<CR>

nmap <C-m> :NERDTreeFind<CR>
nmap <C-n> :NERDTreeToggle<CR>

nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>b :Buffers<CR>

" Rails
nmap <Leader>s :A<CR>
nmap <Leader>r :R<CR>

nmap <Leader>k :!tmux send-keys -t 2 'cd ~/projects/edtech/backend;docker-compose run --rm web bash' C-m<CR>

nmap <Leader>a :Ack! "\b<cword>\b" 

colorscheme jellybeans

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
set laststatus=2

if !has('gui_running')
    set t_Co=256
endif

" NERDTress File highlighting
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

" NERDTree show Hidden files
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1

" Show matching brackets when text indicator is over them
set showmatch

" Rooter
let g:rooter_patterns = ['tags', '.git', '.git/']

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{FugitiveStatusline()}
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Buff close
nmap <Leader>c :BD<CR>

vnoremap // y/<C-R>"<CR>

set foldmethod=indent
set foldlevelstart=20

autocmd QuickFixCmdPost *grep* cwindow

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Split settings
set splitbelow
set splitright

" Git branching
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_remote_branch_sort = 'date'

" Easy motion
map <Leader>j <Plug>(easymotion-s)

" Docker
nmap <Leader>d :DockerToolsToggle<CR>
