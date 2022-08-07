local status_ok, nvim_lsp = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "config.lsp.handlers".setup()

local servers = {
  'tsserver',
  'eslint',
  'ccls',
  'html',
  'cssls',
  'rust_analyzer',
  'jedi_language_server',
  'gopls',
}

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities = require "config.lsp.handlers".capabilities,
        on_attach = require "config.lsp.handlers".on_attach
    }
end


