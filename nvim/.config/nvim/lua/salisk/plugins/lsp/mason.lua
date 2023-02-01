-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"tsserver",
		"gopls",
		"sumneko_lua",
		"ansiblels",
		"yamlls",
		"clangd",
		"pyright",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"gofumpt", -- go linter
		-- "goimports", -- go linter
		"yamlfmt", -- yaml formatter
		"eslint",
		"goimports_reviser", -- go imports
		"clang-format", -- c++ format
		"cpplint", -- c++ lint
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = false,
	automic_setup = true,
})
