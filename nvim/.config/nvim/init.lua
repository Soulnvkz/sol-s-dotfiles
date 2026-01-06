-- help
-- CTRL-w-d - diagnostic
--

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.swapfile = false
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>cd', vim.cmd.Ex)
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
--
-- lsp
-- vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
-- vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition)
-- vim.keymap.set('n', '<leader>r', vim.lsp.buf.references)
-- vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover)
--
-- toggle comments
-- vim.keymap.set({"n"}, "<space>", "gcc", { silent = true })
-- vim.keymap.set({"v"}, "<space>", "gc", { silent = true })

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/olimorris/onedarkpro.nvim" },
	-- { src = "https://githib.com/mason-org/mason.nvim" }, -- lsp servers manager
})

vim.cmd("colorscheme onedark")

require('nvim-treesitter').install({
	'c',
	'typescript',
	'glsl',
	'rust',
	'zig',
	'javascript',
	'go',
	'python',
	'cpp'
})

-- telescope https://github.com/nvim-telescope/telescope.nvim
local builtin = require('telescope.builtin')
require("telescope").setup({
	defaults = {
		preview = { treesitter = true },
		sorting_strategy = "ascending",
		borderchars = {
			"", -- top
			"", -- right
			"", -- bottom
			"", -- left
			"", -- top-left
			"", -- top-right
			"", -- bottom-right
			"", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "make",
	callback = function()
		vim.cmd("copen 10")
		vim.cmd("wincmd p") -- return focus to source window
	end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]
-- autocomplete: C-x C-o
-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	group = vim.api.nvim_create_augroup('my.lsp', {}),
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method('textDocument/completion') then
-- 			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
-- 			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
-- 			client.server_capabilities.completionProvider.triggerCharacters = chars
-- 			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

vim.keymap.set("n", "<M-n>", ":cnext<CR>")
vim.keymap.set("n", "<M-p>", ":cprev<CR>")
-- vim.keymap.set("n", "<M-o>", ":cc<CR>")

vim.lsp.enable({ "lua_ls", "pyright" })

-- ctags
-- create ctags: ctags -R
-- set: set tags=./tags;,tags;
-- use: :Telescope tags or Ctrl-] Ctrl-T
