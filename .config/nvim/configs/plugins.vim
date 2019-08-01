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
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'easymotion/vim-easymotion'
    Plug 'itchyny/lightline.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'kevinhui/vim-docker-tools'
    Plug 'majutsushi/tagbar'
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'skwp/greplace.vim'
    Plug 'tmux-plugins/vim-tmux' | Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-dadbod'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-unimpaired'
    Plug 'w0rp/ale'

    """""""""""""""""""""""""""""""""""""
    " Git Support
    """""""""""""""""""""""""""""""""""""
    Plug 'gregsexton/gitv', { 'on': ['Gitv'] }
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
