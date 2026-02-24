-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
-- nnoremap <Leader>q obinding.pry<esc>

-- vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd("colorscheme gruvbox")

vim.keymap.set("n", "<Leader>rl", '<Cmd>VimuxRunCommand("!!")<CR>', {})
vim.keymap.set("n", "q", function()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft == "snacks_dashboard" then
    return
  end
  vim.cmd("bd")
end, {})
vim.keymap.set(
  "n",
  "<Leader>ff",
  "<Cmd>lua Snacks.picker.files({ignored = true, hidden = true, exclude = { '.git', 'node_modules', },})<CR>",
  {}
)
vim.keymap.set("n", "<Leader>sf", "<Cmd>Rg<CR>", { desc = "Fuzzy search using ripgrep" })
vim.keymap.set("n", "yod", "<Cmd>diffthis<CR>", { desc = "Diffthis" })
vim.keymap.set("n", "yof", "<Cmd>diffoff<CR>", { desc = "Diffoff" })

local function run_tests(filename, prefix)
  vim.cmd("w")
  local cmd = (prefix or "") .. "RAILS_ENV=test bin/rspec " .. filename
  vim.fn.VimuxRunCommand(cmd)
end

local function run_test_file(suffix)
  local prev_line = vim.fn.line(".")
  suffix = suffix or ""

  vim.cmd("cd .")
  local filepath = vim.fn.expand("%:.")
  local in_spec_file = filepath:match("_spec%.rb$") ~= nil
  local in_swagger_file = filepath:match("_docs%.rb$") ~= nil

  if not in_spec_file and not in_swagger_file then
    return
  end

  local prefix = in_swagger_file and "SWAGGER_DRY_RUN=0 " or ""

  run_tests(filepath .. suffix, prefix)
  vim.cmd("normal! " .. prev_line .. "ggzz")
end

local function run_nearest_test()
  local spec_line_number = vim.fn.line(".")
  run_test_file(":" .. spec_line_number)
  vim.cmd("normal! " .. spec_line_number .. "ggzz")
end

vim.keymap.set("n", "<Leader>t.", run_nearest_test, { desc = "Run nearest test" })
vim.keymap.set("n", "<Leader>yp", '<Cmd>let @+=expand("%")<CR>', { desc = "Copy relative file path" })
vim.keymap.set("n", "<Leader>rfa", function()
  vim.cmd("cd .")
  local filepath = vim.fn.expand("%:.")
  vim.fn.VimuxRunCommand("bundle exec rubocop -a -f fuubar " .. filepath)
end, { desc = "Rubocop auto-correct current file" })
vim.keymap.set("n", "<Leader>rfA", function()
  vim.cmd("cd .")
  local filepath = vim.fn.expand("%:.")
  vim.fn.VimuxRunCommand("bundle exec rubocop -A -f fuubar " .. filepath)
end, { desc = "Rubocop auto-correct (unsafe) current file" })
