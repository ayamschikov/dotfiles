"""""""""""""""""""""""""""""""""""""
" Mappings configuration
"""""""""""""""""""""""""""""""""""""
map <SPACE> <leader>

" Act like D and C
nnoremap Y y$

" tabs
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<CR>

" Git
nnoremap gr :Gread<CR>
nnoremap gw :Gwrite<CR>
nnoremap gh :!git hist<CR>
nnoremap gs :Gstatus<CR>
nnoremap <leader>h :GV<CR>
nnoremap <leader>g :Ggrep 
vnoremap <leader>g y:Ggrep '<C-R>"'<CR>
nnoremap <leader>l :Twiggy<CR>
nnoremap gp :GitGutterPreviewHunk<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nmap j gj
nmap k gk
" nnoremap <C-J> <C-W>j
" nnoremap <C-K> <C-W>k
" nnoremap <C-L> <C-W>l
" nnoremap <C-h> <C-W>h

map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

nnoremap Q q
nnoremap q :q<CR>

nnoremap ) :cnext<CR>
nnoremap ( :cprevious<CR>
nmap <Leader>r :Rg<CR>
vnoremap <leader>r y:Rg <C-R>"<CR>

" Rails
nmap <Leader>s :A<CR>

" nnoremap <leader>a :Ack! 
" vnoremap <leader>a y:Ack! '<C-R>"'<CR>
map <C-m> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>

" Easy motion
map <Leader>j <Plug>(easymotion-s)

" Docker
" https://github.com/skanehira/docker-compose.vim
" https://github.com/skanehira/docker.vim
" nmap <Leader>dcl :DockerComposeList<CR>
" nmap <Leader>di :DockerImages<CR>

" search visually selected text
vnoremap // y/<C-R>"<CR>
nnoremap <Leader>q :set paste!<CR>
noremap <Leader>y "*y

" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Shortcuts
nnoremap <Leader>w :w<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>b :Buffers<CR>

nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

nnoremap <Leader>rl :VimuxRunCommand("!!")<CR>

" Rails commands

nnoremap <Leader>rt :VimuxRunCommand("rails t")<CR>
nnoremap <Leader>ru :VimuxRunCommand("bundle exec rubocop -a -f fuubar")<CR>
nnoremap <Leader>rc :VimuxRunCommand("bundle exec rails c")<CR>
" Run all test files
map <leader>rt :call RunTests('spec')<cr>
" Run this file
map <leader>m :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>. :call RunNearestTest()<cr>


" Elixir commands
nnoremap <Leader>et :VimuxRunCommand("MIX_ENV=test mix test")<CR>
nnoremap <Leader>eu :VimuxRunCommand("mix do format, credo")<CR>


" Test helpers from Gary Bernhardt's screen cast:
" https://www.destroyallsoftware.com/screencasts/catalog/file-navigation-in-vim
" https://www.destroyallsoftware.com/file-navigation-in-vim.html
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    " :silent !echo;echo;echo;echo;echo
    exec VimuxRunCommand("RAILS_ENV=test bin/rspec " . a:filename)
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
    if !in_spec_file
        return
    end

    call SetTestFile()
    call RunTests(t:grb_test_file . command_suffix)
    exe "normal!" prev_line . "gg"
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
    exe "normal!" spec_line_number . "gg"
endfunction

" " Jump to last cursor position unless it's invalid or in an event handler
" autocmd BufReadPost *
"   \ if line("'\"") > 0 && line("'\"") <= line("$") |
"   \   exe "normal g`\"" |
"   \ endif

nmap <leader>d oap '=' * 50<Esc>

" json formatter
nmap <leader>= :%!python -m json.tool<CR>

" uppercase word
nmap <leader>u gUiw
