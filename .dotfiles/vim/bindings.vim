"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
map <SPACE> <leader>

" Act like D and C
nnoremap Y y$

" Enables you to save files with :w!! by using sudo if you forgot to open it as root
cmap w!! %!sudo tee > /dev/null %

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
nnoremap gp :!git push origin HEAD<CR>
nnoremap gci :Gcommit<CR>
nnoremap gs :silent Gstatus<CR>
nnoremap gvf :Gvdiff<CR>
nnoremap <leader>h :Gitv<CR>
nnoremap <leader>g :Ggrep 
vnoremap <leader>g y:Ggrep '<C-R>"'<CR>
nnoremap <leader>l :Twiggy<CR>

nmap j gj
nmap k gk

map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

nnoremap Q q
nnoremap q :q<CR>

nmap <Leader>r :Rg<CR>
vnoremap <leader>r y:Rg <C-R>"<CR>

" Rails
nmap <Leader>s :A<CR>

nnoremap <leader>a :Ack! 
vnoremap <leader>a y:Ack! '<C-R>"'<CR>
map <C-m> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>

" Easy motion
map <Leader>j <Plug>(easymotion-s)

" Docker
nmap <Leader>d :DockerToolsToggle<CR>
nmap <Leader>dcu :DCup<CR>
nmap <Leader>dcs :DCstop<CR>
nmap <Leader>dcp :DCps<CR>

" QuickFixList navigation
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>c :ccl<CR>

" search visually selected text
vnoremap // y/<C-R>"<CR>
nmap <Leader>n :echo @%<CR>
nmap <Leader>q :set paste!<CR>
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

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Vim-Test Mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
    nnoremap <Up>    :resize +2<CR>
    nnoremap <Down>  :resize -2<CR>
    nnoremap <Left>  :vertical resize +2<CR>
    nnoremap <Right> :vertical resize -2<CR>
endif

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" Vim-Alchemist Mappings
autocmd FileType elixir nnoremap <buffer> <leader>h :call alchemist#exdoc()<CR>
autocmd FileType elixir nnoremap <buffer> <leader>d :call alchemist#exdef()<CR>
