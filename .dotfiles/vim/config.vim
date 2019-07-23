filetype plugin indent on
syntax on

set number relativenumber
set ignorecase smartcase incsearch hlsearch infercase
set noswapfile
set undofile undolevels=10000 undodir=$HOME/.vim/undodir
set autoindent expandtab smarttab tabstop=2 softtabstop=2 shiftwidth=2
set shiftround
set showcmd
set autowrite autoread
set laststatus=2
set showmatch
set updatetime=100
set splitbelow
set splitright
set foldmethod=indent
set foldlevelstart=20
set ttimeoutlen=200
set ttimeout
set grepprg=ack
set wildmenu wildmode=longest,full wildignore=*.o,*~,*.pyc
set cursorline
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
