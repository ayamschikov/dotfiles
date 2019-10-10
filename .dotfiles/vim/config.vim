set showcmd showmode
set list
set wrap breakindent linebreak
set number relativenumber
set autowrite
set title
set splitbelow splitright
set ignorecase smartcase hlsearch infercase
set noswapfile
set undofile undolevels=10000 undodir=$HOME/.vim/undodir
set shiftround
set showmatch
set updatetime=100
set foldmethod=indent foldcolumn=0 foldlevelstart=20
set ttimeout ttimeoutlen=200
set grepprg=ack
set wildmode=longest,full wildignore=*.o,*~,*.pyc
set cursorline lazyredraw
set magic

if !has('gui_running')
    set t_Co=256
endif

colorscheme jellybeans

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 25
let g:netrw_altv = 1
