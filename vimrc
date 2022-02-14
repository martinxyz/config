" Legacy vimrc
" put new stuff into nvim/init.lua

let mapleader=","
set background=dark
if !exists('g:vscode')
	" syntax hilighting
	syntax enable

	" Verhalten der <TAB> taste
	"set softtabstop=2
	"set shiftwidth=2
	"
	" Highly recommended to set tab keys to 4 spaces
	set tabstop=4
	set shiftwidth=4
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

	" Tab complete now ignores these
	set wildignore=*.o,*.obj,*~,*.pyc,*.pyo

	" Wrap too long lines?
	set nowrap

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

	"Fast open a buffer by search for a name
	map <c-q> :sb " Don't close window, when deleting a buffer

	map K :q<cr>

	" comment region in various styles
	map ," :s/^/"/<CR>
	map ,# :s/^/#/<CR>
	map ,/ :s/^/\/\//<CR>
	map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
	map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>

    set hlsearch
endif
