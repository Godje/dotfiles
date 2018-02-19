" Mouse
set mouse=a

" Share clipboard outside of vim
set clipboard=unnamed

" Don't use swap files
set noswapfile

" Make commands and undo history bigger
set history=1000
set undolevels=1000

"""""""""""""""""""
" Looks and feels "
"""""""""""""""""""

" Tab settings
set tabstop=2
set softtabstop=0 noexpandtab
set shiftwidth=2

"" Environment settings
set number " Show the line numbers
set ruler
set showcmd " Show the last command
set wildmenu " I don't know
set showmatch " Shows the matches when HLsearch? IDK

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" Making a mouse "|" symbol on insert mode. URXVT
au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"

"""""""""""""""""""
" Syntax "
"""""""""""""""""""

" Colors settings
syntax enable
set background=dark
color PaperColor
colorscheme PaperColor
set t_Co=256


" Transparency thinga majigger
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

" Indentation and plugin on
filetype indent on
filetype plugin indent on

"""""""""""""""""""
" NOREMAPS "
"""""""""""""""""""

" <Leader> = \
let mapleader = "\\"

" \Tab = emmet function
inoremap <Leader><Tab> <Esc>:call emmet#expandAbbr(3,"")<CR>i
" \w = toggle wrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>


""""""""""""""""""
" Binds "
""""""""""""""""""

" NERDTree Commands and binds
map <C-n> :NERDTreeToggle<CR>

" Wrap keybin
" noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
		echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap <buffer> <silent> <Up> gk
    noremap <buffer> <silent> <Down> gj
    noremap <buffer> <silent> <Home> g<Home>
    noremap <buffer> <silent> <End> g<End>
		noremap <buffer> <silent> j gj
		noremap <buffer> <silent> k gk
    inoremap <buffer> <silent> <Up> <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End> <C-o>g<End>
  endif
endfunction

" "" Javascript Binds
autocmd FileType javascript inoremap <Leader>f function (<++>){<++>}<Esc>F(i
autocmd FileType javascript inoremap <Leader>l console.log()<Esc>i
autocmd FileType javascript inoremap <Leader>c const
autocmd FileType javascript inoremap <Leader>d document
autocmd FileType javascript inoremap <Leader>w window
autocmd FileType javascript inoremap <Leader><Space> <Esc>/<++><CR>d4li

" "" Formatting JSON
com! FormatJSON %!python -m json.tool

" "" Editing VIMRC file
com! VimrcEdit tabedit ~/.vimrc

" "" Markdown binds
autocmd FileType markdown inoremap <Leader>b **** <++><Esc>F*hi
autocmd FileType markdown inoremap <Space><Space> <Esc>/<++><CR>caw
autocmd FileType markdown inoremap <Leader>i ** <++><Esc>F*i

" "" Moving lines up and down
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" "" FIX ARROW KEYS
inoremap <ESC>[1;5C <Esc>ea
inoremap <ESC>[1;5D <Esc>bi

" Turn on spell-checking
map <F6> :setlocal spell! spelllang=en_us<CR>
"# vim-commentary
"
" comment out line in normal mode with <leader>/
nmap <leader>/ gcc
" " comment out selected block in visual mode with <leader>/
vmap <leader>/ gc

" Execution of Pathogen
execute pathogen#infect()

" remap Ctrl+P to use New tab every time
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }
