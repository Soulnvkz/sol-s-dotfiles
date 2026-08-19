vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", space = "·", trail = "·", nbsp = "␣" }
vim.opt.swapfile = false

-- these filetypes require real tabs, keep them
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "make", "go" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})
vim.o.signcolumn = "yes" -- always reserved so diagnostics don't shift the text
vim.o.completeopt = "menuone,noselect,popup,fuzzy" -- popup = docs float for selected item
vim.o.winborder = "rounded"
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>cd', vim.cmd.Ex)
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/olimorris/onedarkpro.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" }, -- lsp server installer
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" }, -- keymap hints on pause
})

-- git clone https://github.com/ManuLinares/nvim-c3 ~/.local/share/nvim/site/pack/plugins/start/nvim-c3
require("c3").setup({
  lsp = {
    enable = false,
  },
  formatter = {
    config_file = "~/.dotfiles/nvim/.config/nvim/.c3fmt",
  }
})


vim.cmd("colorscheme onedark")

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright" },
	automatic_enable = false, -- vim.lsp.enable() below stays the single source of truth
})

vim.filetype.add({
    extension = {
        fs = "glsl",
        vs = "glsl",
        frag = "glsl",
        vert = "glsl",
        geom = "glsl",
        comp = "glsl",
        tesc = "glsl",
        tese = "glsl",
    },
})

require("nvim-treesitter").install({
    "c",
    "cpp",
    "lua",
    "typescript",
    "javascript",
    "glsl",
    "go",
    "python",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "lua",
        "typescript",
        "javascript",
        "glsl",
        "go",
        "python",
    },
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].syntax = "on"
    end,
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
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>ts', builtin.treesitter)

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = {"make", "grep"},
	callback = function()
		vim.cmd("copen 10")
		vim.cmd("wincmd p") -- return focus to source window
	end,
})

vim.keymap.set("n", "<M-n>", ":cnext<CR>")
vim.keymap.set("n", "<M-p>", ":cprev<CR>")
-- vim.keymap.set("n", "<M-o>", ":cc<CR>")

-- lsp -------------------------------------------------------------------

vim.diagnostic.config({ virtual_text = true })

-- native LSP completion: menu opens only on <C-Space>; set autotrigger = true
-- to have it pop up automatically while typing instead
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
		end
	end,
})

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get)

-- Enter accepts the selected completion item; otherwise Enter works as usual
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		if vim.fn.complete_info({ "selected" }).selected ~= -1 then
			return "<C-y>" -- an item is highlighted: accept it
		end
		return "<C-e><CR>" -- menu open but nothing selected: close it, normal newline
	end
	return "<CR>"
end, { expr = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

local lsp_servers = { "lua_ls", "pyright", "clangd" }
vim.g.lsp_enabled = true
vim.lsp.enable(lsp_servers)

local function lsp_set(on)
	vim.g.lsp_enabled = on
	vim.lsp.enable(lsp_servers, on) -- off: stops clients; on: reattaches open buffers
	vim.notify("LSP " .. (on and "enabled" or "disabled"))
end
vim.api.nvim_create_user_command("LspEnable", function() lsp_set(true) end, {})
vim.api.nvim_create_user_command("LspDisable", function() lsp_set(false) end, {})
vim.api.nvim_create_user_command("LspToggle", function() lsp_set(not vim.g.lsp_enabled) end, {})

require("which-key").setup()

-- CHEATSHEET ============================================================
--
-- MOVEMENT
--   h j k l        left / down / up / right
--   w b e          next word / back word / end of word
--   0 ^ $          line start / first non-blank / line end
--   gg G           top / bottom of file
--   { }            previous / next paragraph (blank line)
--   C-d C-u        scroll half page down / up
--   C-o C-i        jump back / forward (jumplist — e.g. after gd/grr)
--   gi             back to where you last typed, straight into insert mode
--   `.             jump to the last change in the file
--   f{char} ; ,    jump to {char} in line / repeat / repeat backwards
--   %              jump to matching bracket
--   zz             center screen on cursor
--
-- EDITING
--   i a I A o O    insert: here / after / line start / line end / line below / above
--   x r{char}      delete char / replace char
--   dd yy p P      delete line / yank line / paste after / before
--   ciw diw yiw    change / delete / yank inner word (text objects!)
--   ci( di" cit    same inside parens / quotes / html tag — also a( a" (incl. delimiters)
--   u C-r          undo / redo
--   .              repeat last change
--   >> <<          indent / dedent line
--   J              join line below onto this one
--   gcc gc         toggle comment: line / selection (builtin)
--
-- VISUAL
--   v V C-v        char-wise / line-wise / block-wise select
--   o              jump to other end of selection
--   gv             reselect last selection
--
-- WINDOWS / SPLITS
--   :vsplit :split vertical / horizontal split
--   C-w h/j/k/l    move between windows
--   C-w w q o =    cycle / close / close others / equalize
--
-- SEARCH / REPLACE
--   / ? n N        search forward / backward, next / previous match
--   *              search word under cursor
--   :%s/old/new/gc replace in file, confirm each
--   :noh           clear search highlight
--
-- THIS CONFIG
--   <leader>f      telescope: find files        <leader>g   telescope: live grep
--   <leader>y      yank to system clipboard     <leader>d   delete to system clipboard
--   <leader>w      write                        <leader>o   save + reload config
--   <leader>cd     file explorer (:Ex)          <leader>cf  clang-format buffer
--   <leader>lf     LSP format buffer            gd          go to definition
--   <M-n> <M-p>    quickfix next / prev         i_<C-Space> open completion menu
--
-- LSP BUILT-INS (work whenever a server is attached)
--   grn            rename symbol                gra         code action
--   grr            references                   gri         implementation
--   grt            type definition              gO          document symbols
--   K              hover docs (K again to enter the float)
--   i_<C-s>        signature help (insert mode; if dead: stty -ixon)
--   [d ]d          previous / next diagnostic   C-w d       diagnostic float
--   (grr results open the quickfix list: Enter jumps, <M-n>/<M-p> cycle, :cclose closes;
--    return to your edit spot with C-o or gi)
--
-- COMPLETION MENU (while popup is visible)
--   C-n C-p        next / previous item (docs popup follows selection)
--   Enter          accept highlighted item (plain newline if nothing highlighted)
--   C-y            accept                       C-e         cancel
--
-- COMMANDS
--   :LspEnable :LspDisable :LspToggle   global LSP on/off (this config)
--   :lsp enable|disable|restart {name}  per-server control (builtin)
--   :Mason                              LSP server installer UI
--   :retab                              convert existing real tabs in a file to spaces
--   :checkhealth vim.lsp                show attached/enabled servers
--
-- LEARNING NVIM
--   :Tutor         builtin 30-min interactive tutorial — best starting point
--   :help quickref quick reference of everything
--   which-key      press <leader> and wait: popup shows what you can press next
--   plugins to try later (not installed):
--     m4xshen/hardtime.nvim       blocks bad habits (key spam), suggests better motions
--     tris203/precognition.nvim   overlay hints showing available motions
--     ThePrimeagen/vim-be-good    motion practice game
--
-- CTAGS
--   create ctags: ctags -R
--   set: set tags=./tags;,tags;
--   use: :Telescope tags or Ctrl-] Ctrl-T
-- =======================================================================
