-- Hook LSP into completion
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
  .protocol
  .make_client_capabilities())


-- Setup go language server gopls
require'lspconfig'.gopls.setup {
    capabilities = capabilities,
    completeUnimported = true,
    analyses = {unusedparams = true},
    staticcheck = true,
    settings = { 
        gopls = {
            buildFlags = {"-tags=cluster,integration"},
        },
    },
    on_attach = function()
        -- "n" means normal mode
        -- {buffer=0} means only for this buffer
        -- <cmd> == :
        -- <cr> == enter

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer = 0})
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer = 0})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer = 0})
        vim.keymap.set("n", "gR", vim.lsp.buf.rename, {buffer = 0})
        vim.keymap.set("n", "gf", vim.lsp.buf.formatting, {buffer = 0})
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, {buffer = 0})
        vim.keymap.set("n", "en", vim.diagnostic.goto_next, {buffer = 0})
        vim.keymap.set("n", "ep", vim.diagnostic.goto_prev, {buffer = 0})
    end
}

-- LSP autocomplete
vim.opt.completeopt = {"menu", "menuone", "noselect"} -- setting vim values

-- Setup nvim-cmp
local cmp = require 'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({select = true})
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'},
		{name = 'luasnip'} -- For luasnip users.
    }, {{name = 'buffer'}})
})

-- Enable inline errors
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
      {update_in_insert = true})

require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "all",

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing
    ignore_install = { "javascript" },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- list of language that will be disabled
        disable = { "c", "rust" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
