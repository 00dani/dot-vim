local LspAttach = "LspAttach"
local VeryLazy = "VeryLazy"

return {
	-- Penlight is a Lua utility library. It's not Neovim-specific, but installing it like this still makes require("pl") work anywhere else in your config. :)
	"lunarmodules/penlight",

	-- Familiar Vim plugins for Git integration and smart indentation.
	"tpope/vim-fugitive",
	"tpope/vim-sleuth",

	-- Comment toggle plugin, like tpope/vim-commentary.
	{"numToStr/Comment.nvim", opts = {}},

	-- Adds Neovim's Lua package directories to 'path' when editing a Neovim Lua file.
	"sam4llis/nvim-lua-gf",

	-- Reminder popups as you type multiple-key mappings
	{"folke/which-key.nvim", event = VeryLazy, init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end, opts = {}},

	-- Unimpaired's handy bracket mappings, but also which-key.nvim knows about them and can remind me of them.
	{"afreakk/unimpaired-which-key.nvim", dependencies = {"tpope/vim-unimpaired"}, config = function()
		local wk = require "which-key"
		local uwk = require "unimpaired-which-key"
		wk.register(uwk.normal_mode)
		wk.register(uwk.normal_and_visual_mode, {mode = {"n", "v"}})
	end},

	-- Fuzzy finder for all sorts of things. Files, buffers, LSP references and definitions, the list goes on.
	{"nvim-telescope/telescope.nvim",
		branch = '0.1.x',
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- This small native binary is technically optional but is highly recommended to improve Telescope's performance.
			{"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
		},
		opts = {
			extensions = {
				fzf = {},
			},
		},
		init = function()
			local telescope = require('telescope')
			telescope.load_extension('fzf')
		end
	},

	-- Indicate which parts of the buffer have changed according to Git in the left margin. Basically the same thing as mhinz/vim-signify.
	{"lewis6991/gitsigns.nvim", opts = {
			signs = {
				add = {text = "+"},
				change = {text = "~"},
				delete = {text = "_"},
				topdelete = {text = "‾"},
				changedelete = {text = "~"},
			},
	}},

	{"navarasu/onedark.nvim",
		priority = 1000,
		init = function()
			require("onedark").load()
		end,
		opts = {
			transparent = true,
			ending_tildes = true,
		}
	},

	{"nvim-lualine/lualine.nvim",
		dependencies = {
			{"nvim-tree/nvim-web-devicons", opts = {}},
		},
		opts = {
			options = {
				icons_enabled = true,
				theme = "onedark",
			},
			extensions = {
				"fugitive",
				"lazy",
				"quickfix",
			},
		},
	},

	-- Basically a Neovim clone of tpope's vim-surround. The original tpope plugin does work in Neovim, but this one integrates better with other Neovim plugins like which-key.nvim.
	{"kylechui/nvim-surround", event = VeryLazy, opts = {}},

	{"neovim/nvim-lspconfig", dependencies = {
		-- UI for feedback on running language servers.
		{"j-hui/fidget.nvim", tag = "legacy", event = LspAttach, opts = {}},
		-- Better support for using lua_ls with Neovim itself.
		"folke/neodev.nvim",
	}},

	{"hrsh7th/nvim-cmp", dependencies = {
		-- nvim-cmp *requires* a snippet engine to work. We'll use LuaSnip.
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",

		"hrsh7th/cmp-nvim-lsp",
	}},

	{"nvim-treesitter/nvim-treesitter", dependencies = {
		"RRethy/nvim-treesitter-textsubjects",
	}, build = ":TSUpdate"},
}
