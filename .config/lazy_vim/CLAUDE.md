# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration focused on Ruby on Rails development with Docker, Tmux integration, and AI assistance (Avante + Copilot).

## Architecture

- **init.lua** → loads `config/lazy.lua` which bootstraps lazy.nvim and imports all plugins
- **lua/config/** — Core config: options, keymaps, autocmds, lazy.nvim setup
- **lua/plugins/** — One file per plugin or plugin group, each returning a lazy.nvim spec table
- **lazyvim.json** — Declares enabled LazyVim extras (lang packs, DAP, fzf, test core, etc.)
- **lazy-lock.json** — Pinned plugin versions (auto-managed by lazy.nvim)

## Key Conventions

- Plugin specs use LazyVim's `opts` merging pattern — prefer extending defaults over replacing them
- Lua formatting: StyLua with 2-space indent, 120 char line width (`stylua.toml`)
- Spell checking configured for English and Russian

## Testing Setup

Tests run inside Docker via `docker compose exec -e RAILS_ENV=test web bundle exec rspec` (configured in `lua/plugins/test.lua`). Custom Vimux-based test functions in `lua/config/keymaps.lua` also support running specs with `<Leader>t.` (nearest test) and `<Leader>rl` (last command).

## Enabled LazyVim Extras

Ruby, TypeScript, Docker, JSON, Markdown, Tailwind, fzf, DAP (core + nlua), yanky, neotest core, dotenv.

## Format Lua Files

```
stylua lua/
```
