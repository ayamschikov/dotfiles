filetype plugin indent on   " Allow auto-indenting depending on file type
syntax on

set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set wrap breakindent
set number relativenumber
set autowrite autoread
set title " Show file title
set splitbelow splitright " Change the split screen behavior
set ignorecase smartcase incsearch hlsearch infercase
set noswapfile
set undofile undolevels=10000 undodir=$HOME/.vim/undodir
" set autoindent expandtab smarttab tabstop=2 softtabstop=2 shiftwidth=2
set updatetime=100
set cursorline lazyredraw
set magic
colorscheme jellybeans
set encoding=utf-8
set foldmethod=indent
set foldlevel=99

set clipboard=unnamedplus " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
set cursorline " Highlights the current line in the editor
set hidden " Hide unused buffers
set autoindent " Indent a new line
set inccommand=split " Show replacements in a split screen
set mouse=a " Allow to use the mouse in the editor
set wildmenu " Show a more advance menu
set cc=120 " Show at 120 column a border for good code style
" set spell " enable spell check (may need to download language package)
set ttyfast " Speed up scrolling in Vim
