-- g:mapleader needs to be set before any plugins are loaded.
vim.g.mapleader = "\\"

-- Bootstrap the lazy.nvim package manager. It will automatically manage
-- itself, but other plugins to use are defined in ./lua/plugins.lua.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup "dot_vim.plugins"

vim.o.breakindent = true
vim.o.termguicolors = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.relativenumber = true

vim.o.wildmode = 'longest,full'

vim.keymap.set('i', 'jj', '<Esc>')

require("dot_vim.tree-sitter").setup()
require("dot_vim.completion").setup()
require("dot_vim.lsp").setup()
