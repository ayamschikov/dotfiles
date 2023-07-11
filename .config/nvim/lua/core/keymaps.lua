-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- use jk to exit insert mode
-- keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- Previous tab management config
-- keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
-- keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
-- keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
-- keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

keymap.set("n", "tn", ":tabnew<CR>") -- open new tab
keymap.set("n", "tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "tj", ":tabnext<CR>") --  go to next tab
keymap.set("n", "tk", ":tabprev<CR>") --  go to previous tab

-- vimdiff
keymap.set("n", "yod", ":diffthis<CR>") --  diff on
keymap.set("n", "yof", ":diffoff<CR>") --  diff off

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

----------------------
-- My mappings
----------------------

----------------------
-- Git
----------------------
keymap.set("n", "gb", ":Git blame<CR>") -- 
keymap.set("n", "gh", ":!git hist<CR>") -- 
keymap.set("n", "gs", ":Git<CR>") -- 
keymap.set("n", "<leader>h", ":GV<CR>") -- 
keymap.set("n", "<leader>g", ":Ggrep ") -- 
keymap.set("n", "<leader>g", "y:Ggrep '<C-R>\"'<CR>") -- 
keymap.set("n", "<leader>l", ":Twiggy<CR>") -- 
keymap.set("n", "gp", ":GitGutterPreviewHunk<CR>") -- 

-- nmap j gj
-- nmap k gk

keymap.set("n", "<leader>vl", ":vsp $MYVIMRC<CR>") -- open config
keymap.set("n", "<leader>vr", ":source $MYVIMRC<CR>") -- reload config

keymap.set("n", "Q", "q") -- start macros
keymap.set("n", "q", ":q<CR>") -- quit

keymap.set("n", "q", ":q<CR>") -- quit
keymap.set("n", "q", ":q<CR>") -- quit

keymap.set("n", ")", ":cnext<CR>") -- next element from copen
keymap.set("n", "(", ":cprevious<CR>") -- previous element from copen

keymap.set("n", "<Leader>r", ":Rg<CR>") -- run fuzzy search through project
keymap.set("v", "<leader>r", 'y:Rg <C-R>"<CR>') -- run fuzzy search through project by selected text

keymap.set("n", "<C-m>", ":NvimTreeFindFile<CR>")
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>=", ":%!python3 -m json.tool<CR>") -- json formatter

keymap.set("n", "<leader>u", "gUiw") -- uppercase word

keymap.set("n", "<Leader>j", "<Plug>(easymotion-s)") -- Easy motion

keymap.set("v", "//", 'y/<C-R>"<CR>') -- search visually selected text
-- nnoremap <Leader>q :set paste!<CR>
-- noremap <Leader>y "*y

keymap.set("n", "<Leader>w", ":w<CR>") -- save file
keymap.set("n", "<Leader>f", ":Files<CR>") -- open list of files
keymap.set("n", "<Leader>t", ":Tags<CR>") -- open list of tags
keymap.set("n", "<Leader>b", ":Buffers<CR>") -- open list of buffers

keymap.set("n", "<Up>", ":resize +2<CR>")
keymap.set("n", "<Down>", ":resize -2<CR>")
keymap.set("n", "<Left>", ":vertical resize +2<CR>")
keymap.set("n", "<Right>", ":vertical resize -2<CR>")

keymap.set("n", "<Leader>rl", ':VimuxRunCommand("!!")<CR>') -- run last command in terminal


----------------------
-- Rails commands
----------------------

keymap.set("n", "<Leader>s", ":A<CR>")
-- nnoremap <Leader>rt :VimuxRunCommand("rails t")<CR>
keymap.set("n", "<Leader>ru", ':VimuxRunCommand("bundle exec rubocop -a -f fuubar")<CR>') -- run rubocop
keymap.set("n", "<Leader>rc", ':VimuxRunCommand("bundle exec rails c")<CR>') -- launch rails console
-- " Run all test files
-- map <leader>rt :call RunTests('spec')<cr>
keymap.set("n", "<leader>m", ":call RunTestFile()<cr>") -- Run this file
keymap.set("n", "<leader>.", ":call RunNearestTest()<cr>") -- Run only the example under the cursor

keymap.set("n", "<leader>n", ":call RunRubocopFile()<cr>") -- Run rubocop with safe autocorrect on current file
keymap.set("n", "<leader>N", ":call RunRubocopFileA()<cr>") -- Run rubocop with unsafe autocorrect on current file

keymap.set("n", "<leader>d", "oap '=' * 50<Esc>") -- insert line with 50 '=' chars


----------------------
-- Elixir commands
----------------------
-- nnoremap <Leader>et :VimuxRunCommand("MIX_ENV=test mix test")<CR>
-- nnoremap <Leader>eu :VimuxRunCommand("mix do format, credo")<CR>
