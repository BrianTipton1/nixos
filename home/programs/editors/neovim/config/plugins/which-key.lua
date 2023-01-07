vim.g.mapleader = " "
local wk = require("which-key")
wk.setup({})
local options = { noremap = true }
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.keymap.set("i", "jj", "<Esc>", options)

wk.register({
	["<leader>"] = {
		f = {
			name = "File",
			["F"] = {
				"Telescope current_buffer_fuzzy_find",
				"Fuzzy find in current buffer",
			},
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
			b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
			o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
			h = { "<cmd>Telescope help_tags<cr>", "Open help tags" },
			m = {
				function()
					vim.lsp.buf.format({ async = true })
				end,
				"Format",
			},
		},
		t = {
			name = "Toggle",
			t = { "<cmd>NvimTreeToggle<cr>", "Toggle Tree" },
			h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Toggle Terminal Horizontal" },
			v = { "<cmd>ToggleTerm direction=vertical size=50<cr>", "Toggle Terminal Vertical" },
			g = { "<cmd>lua _lazygit_toggle()<cr>", "Toggle Terminal Vertical" },
		},
		["~"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
		["`"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
		["-"] = { "<cmd>nohlsearch<cr>", "Remove search highlight" },
		["/"] = {
			function()
				require("Comment.api").toggle.blockwise()
			end,
			"Toggle Comment",
		},
		T = {
			{ "<cmd>Telescope colorscheme<cr>", "Change colorscheme" },
		},
		s = {
			name = "Split",
			h = { "<cmd>split<cr>", "Horizontal" },
			v = { "<cmd>vsplit<cr>", "Vertical" },
		},
		n = {
			name = "New",
			t = { "<cmd>tabnew<cr>", "Tab" },
		},
		b = {
			name = "Buffer",
			d = { "<cmd>bd<cr>", "Destroy" },
			h = { "<cmd>split && new<cr>", "New Horizontal" },
			v = { "<cmd>vsplit && new<cr>", "New Vertical" },
		},
		["<Tab>"] = {
			"<cmd>tabnext<cr>",
			"Cycle through tabs",
		},
	},
	["<C-f>"] = {
		"<cmd>Telescope current_buffer_fuzzy_find<cr>",
		"Fuzzy find in current buffer",
	},
})

-- Language Specific keybinds
--
--[[ function setKeybinds() ]]
--[[ local fileTy = vim.api.nvim_buf_get_option(0, "filetype") ]]
--[[ local opts = { prefix = "<leader>", buffer = 0 } ]]

--[[ if fileTy == "latex" then ]]
--[[ wk.register({ ]]
--[[ ["l"] = { { ":wq<cr>", "test write" } }, ]]
--[[ ["q"] = { ":q<CR>", "test quit" }, ]]
--[[ }, opts) ]]
--[[ elseif fileTy == "sh" then ]]
--[[ wk.register({ ]]
--[[ ["W"] = { ":w<CR>", "test write" }, ]]
--[[ ["Q"] = { ":q<CR>", "test quit" }, ]]
--[[ }, opts) ]]
--[[ end ]]
--[[ end ]]
--[[ vim.cmd("autocmd FileType * lua setKeybinds()") ]]
