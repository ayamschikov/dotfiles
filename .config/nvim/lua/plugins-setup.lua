-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- TODO: check why this is not working
-- import packer safely
-- local statuspacker = pcall(require, 'packer')
-- if not status then
--   print("packer not installed")
--   return
-- end

-- add list of plugins to install
return require('packer').startup(function()
  -- packer can manage itself
  use("wbthomason/packer.nvim")

  use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

  ---------------------
  -- Theme / Interface
  ---------------------
  use("nanotech/jellybeans.vim") -- preferred colorscheme
  use("bluz71/vim-nightfly-guicolors") -- previous colorscheme

  use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

  use("szw/vim-maximizer") -- maximizes and restores current window

  -- essential plugins
  use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
  use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  -- Previous plugin was
  -- Plug 'tpope/vim-commentary' (https://github.com/tpope/vim-commentary)
  use("numToStr/Comment.nvim")

  -- file explorer
  -- Previous plugin was
  -- Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  use("nvim-tree/nvim-tree.lua")

  -- vs-code like icons
  use("nvim-tree/nvim-web-devicons")

  -- statusline
  -- Plug 'itchyny/lightline.vim'
  use("nvim-lualine/lualine.nvim")

  -- fuzzy finding w/ telescope
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

  -- autocompletion
  use("hrsh7th/nvim-cmp") -- completion plugin
  use("hrsh7th/cmp-buffer") -- source for text in buffer
  use("hrsh7th/cmp-path") -- source for file system paths

  -- snippets
  use("L3MON4D3/LuaSnip") -- snippet engine
  use("saadparwaiz1/cmp_luasnip") -- for autocompletion
  use("rafamadriz/friendly-snippets") -- useful snippets

  -- managing & installing lsp servers, linters & formatters
  -- in charge of managing lsp servers, linters & formatters
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

  -- configuring lsp servers
  use("neovim/nvim-lspconfig") -- easily configure language servers
  use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    requires = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }) -- enhanced lsp uis
  use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
  use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

  -- formatting & linting
  use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
  use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

  -- treesitter configuration
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })

  -- auto closing
  -- Plug 'jiangmiao/auto-pairs'
  use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags



  ---------------------
  -- Database
  ---------------------
  -- "Plug 'tpope/vim-dadbod'


  ---------------------
  -- Utility
  ---------------------
  use("preservim/vimux") -- Allows to run commands in tmux separate window with VimuxRunCommand
  use("roxma/vim-tmux-clipboard") -- Allows copy to vim or tmux buffer
    -- Plug 'easymotion/vim-easymotion'
    -- Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    -- Plug 'junegunn/fzf.vim'
    -- Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    -- Plug 'neovim/nvim-lspconfig', { 'do': 'gem install solargraph' }
    -- " Plug 'hrsh7th/nvim-compe'
    -- Plug 'hrsh7th/vim-vsnip'

    -- " Plug 'hrsh7th/cmp-nvim-lsp'
    -- " Plug 'hrsh7th/cmp-buffer'
    -- " Plug 'hrsh7th/cmp-path'
    -- Plug 'hrsh7th/cmp-cmdline'
    -- " Plug 'hrsh7th/nvim-cmp'

    -- " For vsnip users.
    -- Plug 'hrsh7th/cmp-vsnip'
    -- Plug 'hrsh7th/vim-vsnip'

    -- "" tags
    -- Plug 'ludovicchabant/vim-gutentags'
    -- Plug 'preservim/tagbar'
    -- Plug 'tpope/vim-abolish'
    -- Plug 'tpope/vim-repeat'
    -- Plug 'tpope/vim-surround'
    -- Plug 'tpope/vim-endwise'
    -- " to keep undoes for file after it has been moved or renamed
    -- Plug 'tpope/vim-eunuch'
    -- "Plug 'tpope/vim-sleuth'
    -- "Plug 'tpope/vim-dispatch'
    -- "Plug 'tpope/vim-obsession'
    -- "Plug 'tpope/vim-sensible'
    -- "Plug 'tpope/vim-unimpaired'
    -- Plug 'dense-analysis/ale'
    -- Plug 'KabbAmine/zeavim.vim'
    -- Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install()  }  }

  ---------------------
  -- Git Support
  ---------------------
  -- use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side
  use("junegunn/gv.vim")
  use("tpope/vim-fugitive")
  -- " TODO: check it, maybe i dont need this plugin anymore
  use("airblade/vim-gitgutter")
  use("sodapopcan/vim-twiggy")

    -- """"""""""""""""""""""""""""""""""""""
    -- "" Rails Support
    -- """"""""""""""""""""""""""""""""""""""
    -- "Plug 'vim-ruby/vim-ruby'
    use("tpope/vim-rails") -- adds rails support
    --
    -- "Plug 'ngmy/vim-rubocop'
    -- Plug 'slim-template/vim-slim'
    -- Plug 'jparise/vim-graphql'

    -- """"""""""""""""""""""""""""""""""""""
    -- "" Elixir Support
    -- """"""""""""""""""""""""""""""""""""""
    -- Plug 'elixir-editors/vim-elixir'
    -- Plug 'slashmili/alchemist.vim'

    -- """"""""""""""""""""""""""""""""""""""
    -- "" Python Support
    -- """"""""""""""""""""""""""""""""""""""
    -- Plug 'psf/black', { 'branch': 'stable' }


  if packer_bootstrap then
    require("packer").sync()
  end
end)
