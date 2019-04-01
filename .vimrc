call plug#begin('~/.vim/plugged')
    " NERD tree
    " https://github.com/scrooloose/nerdtree
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }

    " display search result's counting
    " https://github.com/google/vim-searchindex
    Plug 'google/vim-searchindex'

    " Rails
    " https://vimawesome.com/plugin/rails-vim
    Plug 'tpope/vim-rails'
    " rubocop
    " https://vimawesome.com/plugin/vim-rubocop
    Plug 'ngmy/vim-rubocop'

    " Multi language support
    " https://github.com/sheerun/vim-polyglot
    Plug 'sheerun/vim-polyglot'

    " Easy motion
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
    "
    " https://github.com/tpope/vim-fugitive
    Plug 'tpope/vim-fugitive'
    " Allow hunks
    " TODO: check it, maybe i dont need this plugin anymore
    " https://github.com/airblade/vim-gitgutter
    Plug 'airblade/vim-gitgutter'
    " Show git status in nerdtree
    " https://github.com/Xuyuanp/nerdtree-git-plugin
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    " git branching
    " https://vimawesome.com/plugin/twiggy
    Plug 'sodapopcan/vim-twiggy'
    "
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

    " comment automatically with gcc or gc[motion]
    " https://github.com/tpope/vim-commentary
    Plug 'tpope/vim-commentary'

    " the . command can repeat whatever you want!
    " http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
    " https://github.com/tpope/vim-repeat
    Plug 'tpope/vim-repeat'

    " database interface
    " https://vimawesome.com/plugin/vim-dadbod
    Plug 'tpope/vim-dadbod'

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
    Plug 'itchyny/lightline.vim'

    " Start screen
    " https://github.com/mhinz/vim-startify
    Plug 'mhinz/vim-startify' 

    " Syntax checker
    " https://github.com/vim-syntastic/syntastic
    Plug 'scrooloose/syntastic'

    " postgresql support plugin
    " https://github.com/lifepillar/pgsql.vim
    Plug 'lifepillar/pgsql.vim'

    " vim tips
    " https://github.com/hobbestigrou/vimtips-fortune
    " Plug 'hobbestigrou/vimtips-fortune'

    " auto change cur dir to project root
    " https://github.com/airblade/vim-rooter
    Plug 'airblade/vim-rooter'

    " Search files
    " https://github.com/junegunn/fzf
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    " https://github.com/junegunn/fzf.vim
    Plug 'junegunn/fzf.vim'

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
    " https://github.com/honza/vim-snippets
    Plug 'honza/vim-snippets'
    Plug 'SirVer/ultisnips'
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

if !has('gui_running')
    set t_Co=256
endif

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

nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>b :Buffers<CR>

" Rails
nmap <Leader>s :A<CR>
nmap <Leader>r :R<CR>

nmap <Leader>k :!tmux send-keys -t 2 'cd ~/projects/edtech/backend;docker-compose run --rm web bash' C-m<CR>

nnoremap <leader>a :Ack! 
vnoremap <leader>a y:Ack! '<C-R>"'<CR>

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

" NERDTree
nmap <C-m> :NERDTreeFind<CR>
nmap <C-n> :NERDTreeToggle<CR>

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

" NERDTree end

" Gitgutter settings
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_override_sign_column_highlight = 0

" Rooter
let g:rooter_patterns = ['tags', '.git', '.git/']

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{FugitiveStatusline()}
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
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
nmap <Leader>d :DockerToolsToggle<CR>
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
autocmd BufWritePre *.rb :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre *.py :call <SID>StripTrailingWhitespaces()

nmap <Leader>v <C-w>v
" tmp
nmap <Leader>q :set paste!<CR>

let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
