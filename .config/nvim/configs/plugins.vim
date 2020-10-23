" Install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
    """""""""""""""""""""""""""""""""""""
    " Utility
    """""""""""""""""""""""""""""""""""""
    "  check it
    " Plug 'benmills/vimux'
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'
    " Usage: cp{motion} - copy to system clipboard
    " Usage: cv{motion} - paste from system clipboard
    Plug 'christoomey/vim-system-copy'
    Plug 'roxma/vim-tmux-clipboard'
    Plug 'easymotion/vim-easymotion'
    Plug 'itchyny/lightline.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree', { 'tag': '6.9.2', 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'skwp/greplace.vim'
    Plug 'tmux-plugins/vim-tmux' | Plug 'tmux-plugins/vim-tmux-focus-events'
    " Plug 'ludovicchabant/vim-gutentags'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-dadbod'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-abolish'
    Plug 'w0rp/ale'
    Plug 'KabbAmine/zeavim.vim'
    Plug 'stephpy/vim-yaml'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install()  }  }
    Plug 'chr4/nginx.vim'
    " todo list
    Plug 'vuciv/vim-bujo'

    " autocomplete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    """""""""""""""""""""""""""""""""""""
    " Git Support
    """""""""""""""""""""""""""""""""""""
    Plug 'junegunn/gv.vim'
    Plug 'tpope/vim-fugitive'
    " TODO: check it, maybe i dont need this plugin anymore
    Plug 'airblade/vim-gitgutter'
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'sodapopcan/vim-twiggy'

    """""""""""""""""""""""""""""""""""""
    " Rails Support
    """""""""""""""""""""""""""""""""""""
    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-rails'
    Plug 'ngmy/vim-rubocop'

    """""""""""""""""""""""""""""""""""""
    " Elixir Support
    """""""""""""""""""""""""""""""""""""
    Plug 'elixir-editors/vim-elixir'
    Plug 'slashmili/alchemist.vim'

    """""""""""""""""""""""""""""""""""""
    " Theme / Interface
    """""""""""""""""""""""""""""""""""""
    Plug 'nanotech/jellybeans.vim'
call plug#end()
