" "" ================================
" "" Vimrc of Godje, aka weirdmayo, aka Daniel Mayovskiy
" "" Github: https://github.com/Godje
" "" ================================
" I left some comments for dudes to copy code
" Cause that is what I did with other people's rices before.
" Because they were kind enough to leave comments, I decided to continue the
" favor

" "" ================
" "" Basics
" "" ================

" "" Mouse
set mouse=a

" open the file at the first line
norm 1G
set nocompatible

" "" Share clipboard outside of vim
set clipboard=unnamed

" "" Don't use swap files
set noswapfile

" "" Make commands and undo history bigger
set history=1000
set undolevels=1000
set encoding=UTF-8

" "" Fold level
set foldlevelstart=20
set foldmethod=syntax

" "" Automatically update the file, on it's change
set autoread

" "" Split will be on the right and bottom, if I :split
set splitbelow splitright

" "" ================
" "" Looks and Feels
" "" ================

" "" Tab settings
set tabstop=2
set softtabstop=0 noexpandtab
set shiftwidth=2
set ts=2

" "" Environment settings
set relativenumber " Show the line numbers
set ruler
set showcmd " Show the last command
set wildmenu " I don't know
set showmatch " Shows the matches when HLsearch? IDK

" "" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" "" Making a mouse "|" symbol on insert mode. URXVT
au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"

"""""""""""""""""""
" Syntax "
"""""""""""""""""""

" "" Colors settings
syntax enable
set background=dark
hi Normal guibg=NONE ctermbg=NONE
set t_Co=256
color monokai
colorscheme monokai


" "" Transparency thinga majigger
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

" "" Indentation and plugin on
filetype plugin indent on

" "" <Leader> = \
let mapleader = "\\"


" "" Cyrillic binds
" Usually only works in normal and visual mode. Which is basically what you
" need. The leader doesn't work. Things are quite messy sometimes. This is not
" a complete remap. Some things I just didn't remember or never used so the
" list will grow in the future.
set langmap=рh,оj,лk,дl,ЩO,щo,фa,ФA,гu,Ж:,тn,вd,сc,шi,мv,МV,цw,ЦW,уe,УE,иb,ИB,ґ\\,иb,нy,НY,зp,ЗP,чx,вd,ВD


" "" ================
" "" Custom Functions
" "" ================

" "" Goyo Toggle.
" You don't need this most likely. I am using Ubuntu with i3 windows manager,
" just like all the nerds do that preach Vim and Linux to be the best thing
" ever that programmer can ever have.
" The reason why I am doing this is because pywal sets my terminal background.
" If I go into Goyo and come back to normal mode, my background in the editor
" is set to the Monokai (colorscheme) background, not the pywal one. I have to
" run the highlight command to reset it. I made a function to do that for me.
function! CustomGoyoToggle()
	exe ":Goyo"
	exe ":hi Normal guibg=NONE ctermbg=NONE"
endfunction

" "" Word Counting Function
" Found this somewhere online. Used it only once but it still works though.
" You may need this if you're doing some college writing work in Vim. 
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

" "" Wrap keybin
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


" "" ================
" "" Binds
" "" ================

" "" General Binds
inoremap <Home> <Esc>^i
nnoremap x "_d1l
nnoremap X "_D
vnoremap x "_d

" "" Toggle wrapping
noremap <silent> <Leader>w :call ToggleWrapCustom()<CR>

" "" NERDTree Toggle
map <C-n> :NERDTreeToggle<CR>

" "" Turn on spell-checking
map <F6> :setlocal spell! spelllang=en_us<CR>

" "" Hiding and showing comments
nnoremap <F10> :hi! link Comment Ignore<CR>
nnoremap <F9> :hi! link Comment Comment<CR>

" "" Carbon Bind
map <F7> :CarbonNowSh<CR>

" "" Commenting
nmap <leader>/ gcc
vmap <leader>/ gc

" "" Emmet Expansion
inoremap <Leader><Tab> <Esc>:call emmet#expandAbbr(3,"")<CR>i

" "" Limelight toggle
nmap <Leader>l :Limelight!! 0.7<CR>

" "" Goyo toggle
nmap <Leader>g :call CustomGoyoToggle()<CR>

" "" ================
" "" FileType Binds
" "" ================

" "" Javascript Binds
autocmd FileType javascript inoremap <Leader>f function (<++>){<++>}<Esc>F(i
autocmd FileType javascript inoremap <Leader>l console.log()<Esc>i
autocmd FileType javascript inoremap <Leader>t this.
autocmd FileType javascript inoremap <Leader><Space> <Esc>/<++><CR>v3l"_di

" "" Markdown binds
autocmd FileType markdown inoremap <Leader>b **** <++><Esc>F*hi
autocmd FileType markdown inoremap <Leader><Space> <Esc>/<++><CR>v3l"_di
autocmd FileType markdown inoremap <Leader>i ** <++><Esc>F*i

" "" Python fix
autocmd FileType python setlocal noet tabstop=4
" "" Javascript Folding
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

" "" ================
" "" Custom commands
" "" ================

" "" Formatting JSON
com! FormatJSON %!python -m json.tool

" "" Editing VIMRC file
com! VimrcEdit tabedit ~/.vimrc

" "" Saving the session
com! MakeSesh mks! vimsession.vim



" "" FIX ARROW KEYS
inoremap <ESC>[1;5C <Esc>ea
inoremap <ESC>[1;5D <Esc>bi


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
let g:goyo_width = 90
let g:goyo_height = 100

