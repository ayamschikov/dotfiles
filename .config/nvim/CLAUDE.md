# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration with a hybrid Lua/Vimscript architecture, primarily designed for Ruby on Rails development with TypeScript/JavaScript support. The configuration is actively migrating from legacy Vim scripts to modern Lua.

## Architecture

### Entry Points

- **`init.vim`** (active) - Sources legacy configs from `configs/` directory

### Directory Structure

- **`lua/`** - Modern Lua configuration
  - `plugins-setup.lua` - Packer.nvim plugin manager with auto-sync on save
  - `core/` - Options, keymaps, colorscheme, helper functions
  - `plugins/` - Individual plugin configurations (use pcall for safe loading)
  - `plugins/lsp/` - LSP server configs via Mason.nvim
- **`configs/`** - Legacy Vimscript configurations (bindings, settings, plugin configs)
- **`autoload/`** - Vim autoload scripts

### Plugin Management

Primary: **Packer.nvim** (`lua/plugins-setup.lua`)

- Auto-installs packer if missing
- Auto-reloads and syncs when file is saved
- ~50+ plugins organized by category

### LSP Setup

Mason.nvim manages language servers:

- Ruby: solargraph, rubocop
- TypeScript/JS: tsserver
- Web: html, cssls, tailwindcss, emmet_ls
- Lua: lua_ls (with Vim globals)

Formatting via null-ls: Prettier, Stylua, ESLint_d, Rubocop

## Key Configuration Patterns

### Safe Module Loading

All plugin configs use this pattern:

```lua
local status, plugin = pcall(require, "plugin_name")
if not status then return end
plugin.setup({...})
```

### Keybindings

- Leader key: Space
- Uses `vim.keymap.set()` in `lua/core/keymaps.lua`
- Organized by category: General, Plugin, Git, Rails

### Helper Functions

Defined in `lua/core/functions.lua` (Vimscript):

- `RunTests()`, `RunTestFile()`, `RunNearestTest()` - RSpec runners via Vimux
- `RunRubocopFile()`, `RunRubocopFileA()` - Rubocop with safe/unsafe autocorrect
- `LeaveFirst()`, `LeaveLast()` - Git conflict resolution

## Important Keybindings

| Binding | Action |
|---------|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fs` | Live grep |
| `<leader>e` / `<C-n>` | Toggle file explorer |
| `<leader>m` | Run test file |
| `<leader>.` | Run test under cursor |
| `<leader>n` / `<leader>N` | Rubocop safe/unsafe |
| `gf` | LSP finder |
| `gd` | Peek definition |
| `<leader>rn` | Smart rename |
| `K` | Hover docs |
| `gb` | Git blame |
| `gs` | Git status |

## Development Notes

- Format on save enabled for JS/TS/Ruby/Lua
- Tmux integration via vim-tmux-navigator and Vimux
- Colorscheme: Jellybeans (primary), Nightfly (fallback)
- Tab size: 2 spaces, no line wrapping
- Relative line numbers enabled
