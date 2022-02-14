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

require('mapx').setup{ global = true }

-- set clipboard to global clipboard
-- vim.opt.clipboard:append("unnamedplus")

if (vim.g.vscode) then -- VSCode only
    nnoremap('z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
else -- ordinary neovim only
end
