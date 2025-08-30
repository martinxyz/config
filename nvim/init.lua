-- ensure packer is installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- plugins
require('packer').startup(function(use)
    -- use ":PackerSync" after making changes
    use 'wbthomason/packer.nvim'
    use 'b0o/mapx.nvim'
    use 'machakann/vim-sandwich'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require'Comment'.setup()
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end
)

-- broken in some setups? (works fine on debian 13 nvim)
require('mapx').setup{ global = true }

-- vim.g.mapleader = ","
--
-- n  Normal mode map. Defined using ':nmap' or ':nnoremap'.
-- i  Insert mode map. Defined using ':imap' or ':inoremap'.
-- v  Visual and select mode map. Defined using ':vmap' or ':vnoremap'.
-- x  Visual mode map. Defined using ':xmap' or ':xnoremap'.
-- s  Select mode map. Defined using ':smap' or ':snoremap'.
-- c  Command-line mode map. Defined using ':cmap' or ':cnoremap'.
-- o  Operator pending mode map. Defined using ':omap' or ':onoremap'.

function toggle_semicolon()
    local line = vim.api.nvim_get_current_line()
    if string.sub(line, -1) == ";" then
        line = string.sub(line, 1, -2)
    else
        line = line .. ';'
    end
    vim.api.nvim_set_current_line(line)
end
nnoremap(';', toggle_semicolon)

-- set clipboard to global clipboard
-- vim.opt.clipboard:append("unnamedplus")
vim.opt.clipboard="unnamed,unnamedplus"


nnoremap('<backspace>', 'V')
vnoremap('<backspace>', 'V')

-- https://stackoverflow.com/questions/26395562/why-does-vim-delay-on-this-remapped-key-and-how-do-i-fix-it
--:verbose :map g
-- However, all this doesn't work.
-- Same issue with all of them: 1s delay
-- Supposed to be solved by <nowait>, which works for <c-w> below, but here it doesn't.
--
-- vim.api.nvim_del_keymap("n", "[");
-- vim.api.nvim_del_keymap("n", "]");
-- vim.cmd("unmap ]")
-- vim.cmd("unmap [")
-- vim.cmd("nunmap ]%")  -- this fixes the issue, but only if executed later manually, not from here
-- vim.cmd("nunmap [%")
-- vim.cmd("nnoremap <nowait> [ 4j")  -- okay (but not different)
-- vim.cmd("nnoremap <nowait> ] 4k")
vim.api.nvim_set_keymap("n", "[", "4j", { noremap = true, nowait = true })
vim.api.nvim_set_keymap("n", "]", "4k", { noremap = true, nowait = true })

if (vim.g.vscode) then -- VSCode only
    nnoremap('z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
    -- VSpaceCode: integrate with whichkey for spacemacs-style space key
    nnoremap('<space>', "<Cmd>call VSCodeNotify('whichkey.show')<Cr>")

    -- <c-w> is window management (actually very useful... I should probably learn to use it instead of SPC-w)
    -- nnoremap('<c-w>', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<Cr>", { nowait = true })
	-- Learn to use C-w q for that!
	-- (or SPC b d)

    -- not exactly what I wanted, but pretty close:
    nnoremap('q', "<Cmd>call VSCodeNotify('workbench.action.openPreviousEditorFromHistory')<Cr>")
    -- nnoremap('Q', "<Cmd>call VSCodeNotify('workbench.action.quickOpenNavigatePrejqvious')<Cr>")
	
    -- this is Ctrl-p by VSCode default (learn that instead?)
    nnoremap('t', "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<Cr>")
    -- this is also the VSCode default ; seems to be correct, however it never finds anything... (lsp issue?)
    nnoremap('<c-t>', "<Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<Cr>")
	
else -- ordinary neovim only
end
