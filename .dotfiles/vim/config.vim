filetype plugin indent on
syntax on

set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set wrap breakindent linebreak
set number relativenumber
set autowrite autoread
set title
set splitbelow splitright

set ignorecase smartcase incsearch hlsearch infercase
set noswapfile
set undofile undolevels=10000 undodir=$HOME/.vim/undodir
" set autoindent expandtab smarttab tabstop=2 softtabstop=2 shiftwidth=2
set shiftround
set autowrite autoread
set laststatus=2
set showmatch
set updatetime=100
set foldmethod=indent foldcolumn=0 foldlevelstart=20
set ttimeout ttimeoutlen=200
set grepprg=ack
set wildmenu wildmode=longest,full wildignore=*.o,*~,*.pyc
set cursorline lazyredraw
set magic

" Syntastic Configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

if !has('gui_running')
    set t_Co=256
endif

colorscheme jellybeans
