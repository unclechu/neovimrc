-- Author: Viacheslav Lotsmanov
-- License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

-- A setup for native Neovim LSP support.
-- Mind that the key mappings are in conflict with ones set for vim-lsp plugin
-- (see “vim-lsp-plugin-setup.vim” module). Use either setup, not both at the
-- same time.

-- TODO: Try lspsaga.nvim and other plugins from this page
--       https://dev.to/craftzdog/my-neovim-setup-for-react-typescript-tailwind-css-etc-58fb

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- ’l‘ for (L)SP
	vim.keymap.set('n', '<space>l', '', opts)

	-- ’d‘ for (D)iagnostic
	vim.keymap.set('n', '<space>ld', '', opts)
	vim.keymap.set('n', '<space>ldo', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '<space>ldp', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', '<space>ldn', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>ldl', vim.diagnostic.setloclist, opts)
	vim.keymap.set('n', '<space>ldq', vim.diagnostic.setqflist, opts)
	vim.keymap.set('n', '<space>ldr', vim.diagnostic.reset, opts)
	vim.keymap.set('n', '<space>lds', vim.diagnostic.show, opts)
	vim.keymap.set('n', '<space>ldh', vim.diagnostic.hide, opts)

	vim.keymap.set('n', '<space>lv', vim.lsp.buf.hover, opts)

	vim.keymap.set('n', '<space>lrf', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<space>lrn', vim.lsp.buf.rename, opts)

	vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<space>li', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<space>lg', vim.lsp.buf.signature_help, opts)

	vim.keymap.set('n', '<space>ldc', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', '<space>ldf', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', '<space>lt', '', opts)
	vim.keymap.set('n', '<space>ltd', vim.lsp.buf.type_definition, opts)

	vim.keymap.set('n', '<space>ls', vim.lsp.buf.document_symbol, opts)

	-- ’w‘ for (W)orkspace
	vim.keymap.set('n', '<space>lw', '', opts)
	vim.keymap.set('n', '<space>lws', vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>lwl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	vim.keymap.set('n', '<space>lf', function()
		vim.lsp.buf.format { async = true }
	end, opts)
end

-- Create a new table that is a shallow merge of the two
local merge_tables = function(a, b)
	local result = {}
	for k, v in pairs(a) do result[k] = v end
	for k, v in pairs(b) do result[k] = v end
	return result
end

-- Setup Neovim LSP.
-- Call when you need LSP support.
local SetupNeovimLsp = function(overrides)
	if overrides == nil then overrides = {} end

	local lsp_flags = {}

	local opts = {
		on_attach = on_attach,
		flags = lsp_flags,
	}

	for _, k in ipairs({
		'hls', -- Haskell
		'ts_ls', -- TypeScript
		'kotlin_language_server', -- Kotlin
	}) do
		require('lspconfig')[k].setup(merge_tables(opts, overrides[k] or {}))
	end
end

-- If you need to customize something here is an example:
-- :lua vim.g.SetupNeovimLsp({ts_ls = {cmd = {'npx', 'typescript-language-server', '--stdio'}}})
vim.g.SetupNeovimLsp = SetupNeovimLsp

vim.api.nvim_create_user_command(
	'SetupNeovimLsp',
	function() SetupNeovimLsp() end,
	{}
)

-- vim: set noet :
