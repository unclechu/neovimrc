require'nvim-treesitter'.setup {}

vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft)

		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
})
