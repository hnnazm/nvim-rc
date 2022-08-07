local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "go",
    "rust",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "python",
    "json",
    "lua",
    "sql",
  },
  ignore_install = {},
  auto_install = true,
  sync_install = true,    -- set to true for containerization
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
    disable = {}
  },
  additional_vim_regex_highlighting = false,
}
