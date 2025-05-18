require("nvchad.configs.lspconfig").defaults()

local servers = {
	"cssls",
	"html",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"golangci_lint_ls",
}

vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers 

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

local ooo = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  -- map HERE
  vim.keymap.set("n", "gd", "<cmd> Telescope<cr>", { buffer = bufnr })
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = ooo,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end
