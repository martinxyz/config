" syntax hilighting
syntax enable

" Verhalten der <TAB> taste
set softtabstop=2
set shiftwidth=2

" Wie tabs angezeigt werden
" set tabstop=4

" Nie tabs speichern:
" set expandtab

" Die Zeile die ich bearbeite hat Respektsabstand zum Screenrand
set scrolloff=3

" see :help wildmode
set wildmode=longest,list

" lowercase searches ignore case, uppercase respect it
set ignorecase
set smartcase

" show found text as I type
set incsearch

" filetype on
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
colorscheme darkblue
"colorscheme elflord
" [1] The only problem I have with the default color (”darkblue”) for the
" comments is that it is too dark for me to read. Since I wasn’t sure where
" the default settings were located, I just changed the comment field in:
" /usr/share/vim/vim63/colors/darkblue.vim
" from “darkred” (which wasn’t that bad) to “lightcyan”, and included that color
" scheme in my .vimrc file. This works out quite nicely.


" Highlights all occurrences of your search
set hlsearch

" Tab complete now ignores these
set wildignore=*.o,*.obj,*~,*.pyc,*.pyo

" py import sys,os; sys.path.append('/home/martin/.vim')
" py import pyhelp
" au Syntax python map <F2> :py pyhelp.lookup()<CR>
" "au[tocmd] [group] {event} {pat} [nested] {cmd}


" py import martin
" imap <c-l> <esc>:py martin.mycomplete()<cr>a

