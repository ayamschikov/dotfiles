let vimplug_exists=expand('~/.vim/autoload/plug.vim')

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

    """""""""""""""""""""""""""""""""""""
    " Generic Programming Support 
    """""""""""""""""""""""""""""""""""""
    Plug 'honza/vim-snippets'
    Plug 'Townk/vim-autoclose'
    " todo: check how integrate it with docker
    " Plug 'janko-m/vim-test'
    " todo: call plugin only on js files
    Plug 'maksimr/vim-jsbeautify'
    Plug 'vim-syntastic/syntastic'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-sleuth'

    """""""""""""""""""""""""""""""""""""
    " Markdown / Writting
    """""""""""""""""""""""""""""""""""""
    Plug 'tpope/vim-markdown'
    Plug 'jtratner/vim-flavored-markdown'

    """""""""""""""""""""""""""""""""""""
    " Git Support
    """""""""""""""""""""""""""""""""""""
    Plug 'kablamo/vim-git-log'
    Plug 'gregsexton/gitv', { 'on': ['Gitv'] }
    Plug 'tpope/vim-fugitive'
    " TODO: check it, maybe i dont need this plugin anymore
    Plug 'airblade/vim-gitgutter'
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'sodapopcan/vim-twiggy'

    """""""""""""""""""""""""""""""""""""
    " Erlang Support
    """""""""""""""""""""""""""""""""""""
    Plug 'vim-erlang/vim-erlang-tags'
    Plug 'vim-erlang/vim-erlang-runtime'
    Plug 'vim-erlang/vim-erlang-compiler'

    """""""""""""""""""""""""""""""""""""
    " Elixir Support
    """""""""""""""""""""""""""""""""""""
    Plug 'elixir-lang/vim-elixir'
    Plug 'avdgaag/vim-phoenix'
    Plug 'mmorearty/elixir-ctags'
    Plug 'mattreduce/vim-mix'
    Plug 'frost/vim-eh-docs'
    Plug 'slashmili/alchemist.vim'
    Plug 'tpope/vim-endwise'
    Plug 'jadercorrea/elixir_generator.vim'
    Plug 'mhinz/vim-mix-format'

    """""""""""""""""""""""""""""""""""""
    " Rails Support
    """""""""""""""""""""""""""""""""""""
    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-rails'
    Plug 'ngmy/vim-rubocop'

    """""""""""""""""""""""""""""""""""""
    " Elm Support
    """""""""""""""""""""""""""""""""""""
    Plug 'lambdatoast/elm.vim'

    """""""""""""""""""""""""""""""""""""
    " Theme / Interface
    """""""""""""""""""""""""""""""""""""
    Plug 'nanotech/jellybeans.vim'
call plug#end()
