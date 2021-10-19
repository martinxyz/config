let mapleader=","
set background=dark

"  "n" work in Normal mode. |mapmode-n|
"  "o" work in Operator-pending mode. |mapmode-o|
"  "v" work in Visual mode. |mapmode-v|
"  "x" work in Visual and Select mode. |mapmode-x|
"  "s" work in Select mode. |mapmode-s|
"  "i" work in Insert mode. |mapmode-i|
"  "c" work in Cmdline mode. |mapmode-c|
"  "tl" work in Terminal mode. |mapmode-t|

if exists('g:vscode')
    nnoremap <space> :call VSCodeNotify('whichkey.show')<CR>

	function! s:VisualCommand(commandString)
			normal! gv
			call VSCodeNotify(a:commandString)
	endfunction

	xnoremap <silent> gh :<C-u>call <SID>hover()<CR>

	nnoremap <silent> <C-w> :<C-u>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

	" nnoremap <silent> <Leader><space> :<C-u>call VSCodeNotify('workbench.action.showCommands')<CR>
	" nnoremap <silent> <Leader>pf :<C-u>call VSCodeNotify('workbench.action.quickOpen')<CR>
	" nnoremap <silent> <Leader>/ :<C-u>call VSCodeNotify('actions.find')<CR>
	" nnoremap <silent> <Leader>= :<C-u>call VSCodeNotify('editor.action.formatDocument')<CR>
	" nnoremap <silent> <Leader>bd :<C-u>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
	" nnoremap <silent> <Leader>bo :<C-u>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>
	" nnoremap <silent> <Leader>br :<C-u>call VSCodeNotify('workbench.action.files.revert')<CR>
	" nnoremap <silent> <Leader>bs :<C-u>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>
	" nnoremap <silent> <Leader>el :<C-u>call VSCodeNotify('workbench.actions.view.problems')<CR>
	" nnoremap <silent> <Leader>ep :<C-u>call VSCodeNotify('editor.action.marker.previous')<CR>
	" nnoremap <silent> <Leader>en :<C-u>call VSCodeNotify('editor.action.marker.next')<CR>
	" nnoremap <silent> <Leader>f/ :<C-u>call VSCodeNotify('actions.find')<CR>
	" nnoremap <silent> <Leader>f2 :<C-u>call VSCodeNotify('fileutils.duplicateFile')<CR>
	" nnoremap <silent> <Leader>fd :<C-u>call VSCodeNotify('fileutils.removeFile')<CR>
	" nnoremap <silent> <Leader>fe :<C-u>call VSCodeNotify('workbench.action.openGlobalSettings')<CR>
	" nnoremap <silent> <Leader>fE :<C-u>call VSCodeNotify('workbench.action.openSettingsJson')<CR>
	" nnoremap <silent> <Leader>fh :<C-u>call VSCodeNotify('gitlens.showQuickFileHistory')<CR>
	" nnoremap <silent> <Leader>fm :<C-u>call VSCodeNotify('fileutils.moveFile')<CR>
	" nnoremap <silent> <Leader>fn :<C-u>call VSCodeNotify('fileutils.newFileAtRoot')<CR>
	" nnoremap <silent> <Leader>fo :<C-u>call VSCodeNotify('workbench.action.files.openFile')<CR>
	" nnoremap <silent> <Leader>fO :<C-u>call VSCodeNotify('workbench.action.files.openFile')<CR>
	" nnoremap <silent> <Leader>fr :<C-u>call VSCodeNotify('fileutils.renameFile')<CR>
	" nnoremap <silent> <Leader>fs :<C-u>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
	" nnoremap <silent> <Leader>fw :<C-u>call VSCodeNotify('workbench.action.files.save')<CR>
	" nnoremap <silent> <Leader>fy :<C-u>call VSCodeNotify('workbench.action.files.copyPathOfActiveFile')<CR>
	" nnoremap <silent> <Leader>gb :<C-u>call VSCodeNotify('gitlens.toggleFileBlame')<CR>
	" nnoremap <silent> <Leader>gh :<C-u>call VSCodeNotify('gitlens.showQuickRepoHistory')<CR>
	" nnoremap <silent> <Leader>gs :<C-u>call VSCodeNotify('workbench.view.scm')<CR>
	" nnoremap <silent> <Leader>hd :<C-u>call VSCodeNotify('workbench.action.openGlobalKeybindings')<CR>
	" nnoremap <silent> <Leader>hD :<C-u>call VSCodeNotify('workbench.action.openGlobalKeybindingsFile')<CR>
	" nnoremap <silent> <Leader>pf :<C-u>call VSCodeNotify('workbench.action.quickOpen')<CR>
	" nnoremap <silent> <Leader>pl :<C-u>call VSCodeNotify('workbench.action.files.openFolder')<CR>
	" nnoremap <silent> <Leader>pp :<C-u>call VSCodeNotify('workbench.action.openRecent')<CR>
	" nnoremap <silent> <Leader>ps :<C-u>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
	" nnoremap <silent> <Leader>qq :<C-u>call VSCodeNotify('workbench.action.closeWindow')<CR>
	" nnoremap <silent> <Leader>qr :<C-u>call VSCodeNotify('workbench.action.reloadWindow')<CR>
	" nnoremap <silent> <Leader>rn :<C-u>call VSCodeNotify('search.action.focusNextSearchResult')<CR>
	" nnoremap <silent> <Leader>rp :<C-u>call VSCodeNotify('search.action.focusPreviousSearchResult')<CR>
	" nnoremap <silent> <Leader>rs :<C-u>call VSCodeNotify('workbench.action.findInFiles')<CR>
	" nnoremap <silent> <Leader>rn :<C-u>call VSCodeNotify('editor.action.rename')<CR>
	" nnoremap <silent> <Leader>ta :<C-u>call VSCodeNotify('workbench.action.toggleActivityBarVisibility')<CR>
	" nnoremap <silent> <Leader>tb :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
	" nnoremap <silent> <Leader>tc :<C-u>call VSCodeNotify('workbench.action.toggleCenteredLayout')<CR>
	" nnoremap <silent> <Leader>td :<C-u>call VSCodeNotify('workbench.view.debug')<CR>
	" nnoremap <silent> <Leader>te :<C-u>call VSCodeNotify('workbench.view.explorer')<CR>
	" nnoremap <silent> <Leader>tf :<C-u>call VSCodeNotify('workbench.action.toggleFullScreen')<CR>
	" nnoremap <silent> <Leader>tg :<C-u>call VSCodeNotify('workbench.view.scm')<CR>
	" nnoremap <silent> <Leader>t/ :<C-u>call VSCodeNotify('workbench.action.findInFiles')<CR>
	" nnoremap <silent> <Leader>tl :<C-u>call VSCodeNotify('workbench.view.extension.gitlens')<CR>
	" nnoremap <silent> <Leader>tm :<C-u>call VSCodeNotify('workbench.action.toggleMenuBar')<CR>
	" nnoremap <silent> <Leader>tM :<C-u>call VSCodeNotify('editor.action.toggleMinimap')<CR>
	" nnoremap <silent> <Leader>tp :<C-u>call VSCodeNotify('workbench.action.togglePanel')<CR>
	" nnoremap <silent> <Leader>' :<C-u>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>
	" nnoremap <silent> <Leader>ts :<C-u>call VSCodeNotify('workbench.action.selectTheme')<CR>
	" nnoremap <silent> <Leader>tx :<C-u>call VSCodeNotify('workbench.view.extensions')<CR>
	" nnoremap <silent> <Leader>tz :<C-u>call VSCodeNotify('workbench.action.toggleZenMode')<CR>
	" nnoremap <silent> <Leader>v :<C-u>call VSCodeNotify('editor.action.smartSelect.grow')<CR>
	" nnoremap <silent> <Leader>V :<C-u>call VSCodeNotify('editor.action.smartSelect.shrink')<CR>
	" nnoremap <silent> <Leader>w- :<C-u>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
	" nnoremap <silent> <Leader>w/ :<C-u>call VSCodeNotify('workbench.action.splitEditorRight')<CR>
	" nnoremap <silent> <Leader>wd :<C-u>call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>
	" nnoremap <silent> <Leader>wh :<C-u>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
	" nnoremap <silent> <Leader>wH :<C-u>call VSCodeNotify('workbench.action.moveActiveEditorGroupLeft')<CR>
	" nnoremap <silent> <Leader>wj :<C-u>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
	" nnoremap <silent> <Leader>wJ :<C-u>call VSCodeNotify('workbench.action.moveActiveEditorGroupDown')<CR>
	" nnoremap <silent> <Leader>wk :<C-u>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
	" nnoremap <silent> <Leader>wK :<C-u>call VSCodeNotify('workbench.action.moveActiveEditorGroupUp')<CR>
	" nnoremap <silent> <Leader>wl :<C-u>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
	" nnoremap <silent> <Leader>wL :<C-u>call VSCodeNotify('workbench.action.moveActiveEditorGroupRight')<CR>
	" nnoremap <silent> <Leader>wm :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
	" nnoremap <silent> <Leader>wo :<C-u>call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')<CR>
	" nnoremap <silent> <Leader>ws :<C-u>call VSCodeNotify('workbench.action.splitEditorDown')<CR>
	" nnoremap <silent> <Leader>wv :<C-u>call VSCodeNotify('workbench.action.splitEditorRight')<CR>
	" nnoremap <silent> <Leader>ww :<C-u>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
	" nnoremap <silent> <Leader>wW :<C-u>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
	" nnoremap <silent> <Leader>xw :<C-u>call VSCodeNotify('editor.action.trimTrailingWhitespace')<CR>
	" nnoremap <silent> go :<C-u>call VSCodeNotify('editor.action.showContextMenu')<CR>

	" xnoremap <silent> <Leader><space> :<C-u>call <SID>VisualCommand('workbench.action.showCommands')<CR>
	" xnoremap <silent> > :<C-u>call <SID>VisualCommand("editor.action.indentLines")<CR>
	" xnoremap <silent> < :<C-u>call <SID>VisualCommand("editor.action.outdentLines")<CR>
	" xnoremap <silent> go :<C-u>call <SID>VisualCommand("editor.action.showContextMenu")<CR>
	" nnoremap <silent> <Leader>/ :<C-u>call <SID>VisualCommand('actions.find')<CR>

	" xmap gc  <Plug>VSCodeCommentary
	" nmap gc  <Plug>VSCodeCommentary
	" omap gc  <Plug>VSCodeCommentary
	" nmap gcc <Plug>VSCodeCommentaryLine
endif

if !exists('g:vscode')
	" syntax hilighting
	syntax enable

	" Verhalten der <TAB> taste
	"set softtabstop=2
	"set shiftwidth=2
	" Highly recommended to set tab keys to 4 spaces
	set tabstop=4
	set shiftwidth=4
	" Nie tabs speichern:
	set expandtab

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

    set hlsearch
endif