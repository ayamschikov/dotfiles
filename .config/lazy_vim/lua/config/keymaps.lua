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

vim.cmd([[
function! RunTests(filename, ...)
    " Write the file and run tests for the given filename
    :w
    " :silent !echo;echo;echo;echo;echo
    " FOR RAILS

    exec VimuxRunCommand(a:1 . "RAILS_ENV=test bin/rspec " . a:filename)
    " exec VimuxRunCommand("bin/rspec " . a:filename)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    let prev_line = line('.')
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    let in_swagger_file = match(expand("%"), '_docs.rb$') != -1

    if !in_spec_file && !in_swagger_file
        return
    end

    if in_swagger_file
      let prefix = 'SWAGGER_DRY_RUN=0 '
    else
      let prefix = ''
    endif

    call SetTestFile()
    call RunTests(t:grb_test_file . command_suffix, prefix)
    exe "normal!" prev_line . "gg" . "zz"
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
    exe "normal!" spec_line_number . "gg" . "zz"
endfunction
]])
vim.keymap.set("n", "<Leader>t.", "<Cmd>call RunNearestTest()<CR>", {})
vim.keymap.set("n", "<Leader>yp", '<Cmd>let @+=expand("%")<CR>', { desc = "Copy relative file path" })
