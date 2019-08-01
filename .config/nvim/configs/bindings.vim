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
nnoremap <leader>h :Gitv<CR>
nnoremap <leader>g :Ggrep 
vnoremap <leader>g y:Ggrep '<C-R>"'<CR>
nnoremap <leader>l :Twiggy<CR>

nmap j gj
nmap k gk
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-h> <C-W>h

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
