local setup = function()
	local config = {
		ensure_installed = {
			"c", "cpp", "make",
			"css", "html", "http", "javascript", "typescript",
			"elixir", "erlang",
			"csv", "json", "jq", "toml", "yaml",
			"git_config", "gitattributes", "gitignore",
			"lua", "luadoc",
			"perl", "php", "python", "ruby",
		},
		auto_install = false,
		sync_install = false,
		ignore_install = {},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {enable = true},
		textsubjects = {
			enable = true,
			prev_selection = ",",
			keymaps = {
				["."]  = {"textsubjects-smart", desc = "textsubjects subject"},
				["a;"] = {"textsubjects-container-outer", desc = "container (class, function, etc.)"},
				["i;"] = {"textsubjects-container-inner", desc = "container (class, function, etc.)"},
			},
		},
	}

	require("nvim-treesitter.configs").setup(config)
end

local defer_setup = function()
	vim.defer_fn(setup, 0)
end

return {
	setup = setup,
	defer_setup = defer_setup,
}
