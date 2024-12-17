local union = require"pl.tablex".union
local neodev = require "neodev"
local lspconfig = require "lspconfig"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

---@param _ any the vim.lsp.client object that got attached, but Neovim doesn't expose that type properly?
---@param bufnr number the number of the buffer the LSP client just attached to
local function on_attach(_, bufnr)
	local telescope = require('telescope.builtin')
	---@param lhs string LHS like you'd pass to vim.keymap.set
	---@param func fun(): nil The function to be called when the mapping is invoked
	---@param desc? string Human-readable description of what this mapping does
	local function nmap(lhs, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', lhs, func, { buffer = bufnr, desc = desc })
	end

	nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

local servers = {
	lua_ls = {},
	jsonls = {},
	perlls = {},
	perlnavigator = {cmd = {"perlnavigator"}},
	phpactor = {},
	pylsp = {},
	solargraph = {},
	taplo = {},
	ts_ls = {},
	yamlls = {},
}

return {
	setup = function()
		neodev.setup{}

		for name, opts in pairs(servers) do
			lspconfig[name].setup(union({
				capabilities = capabilities,
				on_attach = on_attach,
			}, opts))
		end
	end,
}
