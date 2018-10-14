norm 1G
set nocompatible
" mOUSe
set mouse=a

" Share clipboard outside of vim
set clipboard=unnamed

" Don't use swap files
set noswapfile

" Make commands and undo history bigger
set history=1000
set undolevels=1000

" Fold level
set foldlevelstart=20
"
" Automatically update the file, on it's change
set autoread

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
set t_Co=256
color monokai
colorscheme monokai


" Transparency thinga majigger
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

" Indentation and plugin on
filetype plugin indent on

"""""""""""""""""""
" NOREMAPS "
"""""""""""""""""""

" <Leader> = \
let mapleader = "\\"

" \Tab = emmet function
inoremap <Leader><Tab> <Esc>:call emmet#expandAbbr(3,"")<CR>i
" \w = toggle wrap
noremap <silent> <Leader>w :call ToggleWrapCustom()<CR>


""""""""""""""""""
" Binds "
""""""""""""""""""
" "" General Binds
inoremap <Home> <Esc>^i
nnoremap x "_d1l
vnoremap x "_d

" NERDTree Commands and binds
map <C-n> :NERDTreeToggle<CR>

" Russian binds
"
map р h
map о j
map л k
map д l
map Щ O
map щ o
map ф a
map Ф A
map г u
map Ж :
map т n
map в d

" Word Counting Function
function! WordCount()
   let s:old_status = v:statusmsg
   let position = getpos(".")
   exe ":silent normal g\<c-g>"
   let stat = v:statusmsg
   let s:word_count = 0
   if stat != '--No lines in buffer--'
     let s:word_count = str2nr(split(v:statusmsg)[11])
     let v:statusmsg = s:old_status
   end
   call setpos('.', position)
   return s:word_count 
endfunction

" Wrap keybin
" noremap <silent> <Leader>w :call ToggleWrapCustom()<CR>
function! ToggleWrapCustom()
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
autocmd FileType javascript inoremap <Leader>t this.
autocmd FileType javascript inoremap <Leader><Space> <Esc>/<++><CR>v3l"_di

" "" Javascript Folding
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

" "" Formatting JSON
com! FormatJSON %!python -m json.tool

" "" Editing VIMRC file
com! VimrcEdit tabedit ~/.vimrc

" "" Saving the session
com! MakeSesh mks! vimsession.vim
" "" Markdown binds
autocmd FileType markdown inoremap <Leader>b **** <++><Esc>F*hi
autocmd FileType markdown inoremap <Leader><Space> <Esc>/<++><CR>v3l"_di
autocmd FileType markdown inoremap <Leader>i ** <++><Esc>F*i

" "" FIX ARROW KEYS
inoremap <ESC>[1;5C <Esc>ea
inoremap <ESC>[1;5D <Esc>bi

" Turn on spell-checking
map <F6> :setlocal spell! spelllang=en_us<CR>

" Hiding and showing comments
nnoremap <F10> :hi! link Comment Ignore<CR>
nnoremap <F9> :hi! link Comment Comment<CR>

map <F7> :CarbonNowSh<CR>
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
let g:lightline = {
			\ 'enable': {
			\ 'tabline': 0
			\ }
			\ }
