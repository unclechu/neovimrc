-- Author: Viacheslav Lotsmanov
-- License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

-- Setup SuperCollider integration plugin.
-- Call when you need integration with “sclang” for SuperCollider files.
local SetupSuperCollider = function(opts)
	if opts == nil then opts = {} end

	-- Autostart “sclang” for “supercollider” filetype
	if opts.fthook == nil then opts.fthook = true end

	local scnvim = require 'scnvim'
	local postwin = require 'scnvim.postwin'
	local map = scnvim.map
	local map_expr = scnvim.map_expr

	scnvim.setup({
		keymaps = {
			['<space>l'] = map('editor.send_line', 'n'),
			['<space>h'] = {
				map('editor.send_block', 'n'),
				map('editor.send_selection', 'x'),
			},

			['<CR>'] = map('postwin.toggle', 'n'),
			['<space>c'] = map('postwin.clear', 'n'),
			['<space>si'] = map('signature.show', 'n'),

			['<space>sh'] = map('sclang.hard_stop', 'n'),
			['<space>st'] = map('sclang.start', 'n'),
			['<space>sk'] = map('sclang.recompile', 'n'),

			['<F1>'] = map_expr('s.boot', 'n'),
			['<F2>'] = map_expr('s.meter', 'n'),
		},

		-- editor = {
		-- 	highlight = {
		-- 		color = 'IncSearch',
		-- 	},
		-- },

		postwin = {
			float = {
				enabled = true,
			},
		},
	})

	if opts.fthook then
		local fthook = function(args)
			if not scnvim.is_running() then
				scnvim.start()
				postwin.close()
			end
		end
		vim.api.nvim_create_autocmd('FileType', {
			pattern = "supercollider",
			callback = fthook,
		})
	end
end

vim.g.SetupSuperCollider = SetupSuperCollider

vim.api.nvim_create_user_command(
	'SetupSuperCollider',
	function() SetupSuperCollider() end,
	{}
)

-- vim: set noet :
