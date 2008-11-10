" syntax hilighting
syntax enable

" Verhalten der <TAB> taste
"set softtabstop=2
"set shiftwidth=2
" Highly recommended to set tab keys to 4 spaces
set tabstop=4
set shiftwidth=4
" Nie tabs speichern:
" set expandtab

set ignorecase
set autoindent
 
" Die Zeile die ich bearbeite hat Respektsabstand zum Screenrand
set scrolloff=3

" see :help wildmode
set wildmode=longest,list

" show found text as I type
set incsearch
" lowercase searches ignore case, uppercase respect it
set ignorecase
set smartcase


" visual bell
"set vb

"source  ...

" autocmd FileType html,mail set formatoptions=tq textwidth=72
" autocmd FileType perl set smartindent nowrap
" autocmd FileType html source $HOME/.vimrc.html

" imap = mapping only for insert mode
" map = command mode (no c)
"imap <F12> <code> </code> <Esc>2F>a
"(OK, nice. But how do I automatically f>a when I press ESC?)

" don't automatically open new comments
"set formatoptions=tcq
"autocmd FileType perl set formatoptions=tcq

" A colorscheme that works better with dark backgrounds [1]
"colorscheme darkblue
"colorscheme elflord
" [1] The only problem I have with the default color (”darkblue”) for the
" comments is that it is too dark for me to read. Since I wasn’t sure where
" the default settings were located, I just changed the comment field in:
" /usr/share/vim/vim63/colors/darkblue.vim
" from “darkred” (which wasn’t that bad) to “lightcyan”, and included that color
" scheme in my .vimrc file. This works out quite nicely.
"
" set background=dark


" Highlights all occurrences of your search
set hlsearch

" Tab complete now ignores these
set wildignore=*.o,*.obj,*~,*.pyc,*.pyo

" Wrap too long lines?
set nowrap


" py import sys,os; sys.path.append('/home/martin/.vim')
" py import pyhelp
" au Syntax python map <F2> :py pyhelp.lookup()<CR>
" "au[tocmd] [group] {event} {pat} [nested] {cmd}


" py import martin
" imap <c-l> <esc>:py martin.mycomplete()<cr>a

"imap <M-l> 
nnoremap ü <C-]>
nnoremap è <C-t>

" detect indenting of the file being edited (and more)
"filetype on
filetype plugin indent on

" when opening a file, put cursor where it was the last time (from FAQ)
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                         \ exe "normal g'\"" | endif

" revert unmodified files automatically when another program writes them
" (only on GUI focus change or shell exit) 
" TODO: vim should periodically check... eg. if I svn up in the background
:set autoread

" completion stuff
set completeopt=longest,menuone

" turn off vi compatibility
set nocompatible

set cindent
set autoindent
set smartindent

""Move a line of text using alt
"nmap <M-j> mz:m+<cr>`z
"nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"Fast open a buffer by search for a name
map <c-q> :sb " Don't close window, when deleting a buffer

map K :q<cr>

"" Don't close window, when deleting a buffer
"command! Bclose call <SID>BufcloseCloseIt()
"
"function! <SID>BufcloseCloseIt()
"    let l:currentBufNum = bufnr("%")
"    let l:alternateBufNum = bufnr("#")
"
"    if buflisted(l:alternateBufNum)
"        buffer #
"    else
"        bnext
"    endif
"
"    if bufnr("%") == l:currentBufNum
"        new
"    endif
"
"    if buflisted(l:currentBufNum)
"        execute("bdelete! ".l:currentBufNum)
"    endif
"endfunction

" comment region in various styles
map ," :s/^/"/<CR>
map ,# :s/^/#/<CR>
map ,/ :s/^/\/\//<CR>
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>

" TODO: insert default, for editing?
set makeprg=scons
nnoremap <F8> :set makeprg=
nnoremap <F9> :w<CR>:make<CR>:cope 5<CR>:cc<CR>
nnoremap <F4> :cn<CR>
nnoremap <S-F4> :cp<CR>

set background=dark

