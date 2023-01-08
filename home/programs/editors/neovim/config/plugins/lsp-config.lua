local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
require("lspconfig.configs")["fennel-ls"] = {
	default_config = {
		cmd = { "fennel-ls" },
		filetypes = { "fennel" },
		root_dir = function(dir)
			return lspconfig.util.find_git_ancestor(dir)
		end,
		settings = {},
	},
}

lspconfig["fennel-ls"].setup(vim.lsp.protocol.make_client_capabilities())

local servers = { "jsonnet_ls", "sumneko_lua", "nil_ls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end
