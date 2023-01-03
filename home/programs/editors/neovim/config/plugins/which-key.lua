vim.g.mapleader = " "
local wk = require("which-key")
wk.setup {}
local options = { noremap = true }
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.keymap.set("i", "jj", "<Esc>", options)
wk.register({
    ["<leader>"] = {
        f = {
            name = "File",
            f = { "<cmd>Telescope find_files<cr>", "Find File" },
            g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
            b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
            o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
            h = { "<cmd>Telescope help_tags<cr>", "Open help tags" },
            m = {
                function()
                    vim.lsp.buf.format { async = true }
                end, "Format"
            }
        },
        t = {
            name = "Tree",
            t = { "<cmd>NvimTreeToggle<cr>", "Toggle Tree" }
        },
        ["/"] = {
            function()
                require("Comment.api").toggle.linewise.current()
            end,
            "toggle comment",
        },
        T = {
             { "<cmd>Telescope colorscheme<cr>", "Change colorscheme" },

        }
    }
})