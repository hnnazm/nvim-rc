vim.lsp.enable({
  "bashls",
  "cssls",
  "dockerls",
  "gopls",
  "html",
  "intelephense",
  "lua_ls",
  "markdown_oxide",
  "pylsp",
  "tailwindcss",
  "ts_ls",
  "vimls",
  "vue_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float()
  end
})

vim.diagnostic.config({
  virtual_text = {
    current_line = true,
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  float = {
    border = "single",
    format = function(diagnostic)
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        diagnostic.source,
        diagnostic.code or diagnostic.user_data.lsp.code
      )
    end,
  },
})

-- Floating window utilities (for LSP)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Lazy plugin manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
    end,
    init = function()
      require("gruvbox").setup({
        contrast = "soft", -- can be "hard", "soft" or empty string
        transparent_mode = true,
      })

      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end
  },
  {
    "ibhagwan/fzf-lua",
    build = "./install --all",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<Leader><Leader>f",        "<Cmd> FzfLua files<CR>",        desc = "Fuzzy find files" },
      { "<Leader><Leader>/",        "<Cmd> FzfLua grep<CR>",         desc = "Fuzzy find words" },
      { "<Leader><Leader>b",        "<Cmd> FzfLua buffers<CR>",      desc = "Fuzzy find buffers" },
      { "<Leader><Leader>r",        "<Cmd> FzfLua registers<CR>",    desc = "Fuzzy find registers" },
      { "<Leader><Leader>m",        "<Cmd> FzfLua marks<CR>",        desc = "Fuzzy find marks" },
      { "<Leader><Leader>j",        "<Cmd> FzfLua jumps<CR>",        desc = "Fuzzy find jumps" },
      { "<Leader><Leader>h",        "<Cmd> FzfLua helptags<CR>",     desc = "Fuzzy find help" },
      { "<Leader><Leader>gc",       "<Cmd> FzfLua git_bcommits<CR>", desc = "Fuzzy find branch commits" },
      { "<Leader><Leader><Leader>", "<Cmd> FzfLua resume<CR>",       desc = "Fuzzy find resume" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd([[TSUpdate]])

      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
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
          enable = true
        }
      })
    end
  },
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("copilot_cmp").setup()

      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        Copilot = "",
      }

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "kind", "abbr" },
          format = function(_, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] or ""
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        })
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
})
