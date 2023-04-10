vim.g.mapleader = " "

vim.o.hidden = true

vim.opt.clipboard:append "unnamedplus"

vim.opt.expandtab      = true
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.softtabstop    = 2
vim.opt.shiftround     = true

vim.opt.splitbelow     = true
vim.opt.splitright     = true

vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.signcolumn     = "yes"

vim.g.netrw_banner     = 0
vim.g.netrw_alto       = 1
vim.g.netrw_altv       = 1
vim.g.netrw_altfile    = 1

vim.keymap.set("n", "<C-k>", "<Cmd>bprevious<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>bnext<CR>")

vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")
vim.keymap.set("n", "<C-M-h>", "<Cmd>-tabmove<CR>")
vim.keymap.set("n", "<C-M-l>", "<Cmd>+tabmove<CR>")
vim.keymap.set("n", "<C-w>!", "<Cmd>tab split<CR>")

vim.keymap.set("n", "<C-x>t", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<C-x>b", "<Cmd>bp<CR><Cmd>bd #<CR>")

vim.keymap.set("v", "p", [["_dP]])

vim.keymap.set("n", "<BS>", "<Cmd>nohlsearch<CR>")

-- vim.keymap.set("v", "<Leader>x", "<Cmd>'<,'>w !bash<CR>")
vim.keymap.set("v", "<Leader>x", "<Cmd>'<,'>:ToggleTermSendVisualSelection 9<CR>")

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local function RNetrw()
  vim.cmd [[
    if &ft == "netrw"
        if exists("w:netrw_rexlocal")
            Rexplore
        else
            if exists("w:netrw_rexfile")
                exec 'e ' . w:netrw_rexfile
            endif
        endif
    else
        Explore
    endif
  ]]
end

vim.keymap.set("n", "<Leader>g", RNetrw, { noremap = true })

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
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        lazy = false,
        priority = 1000,
        opts = {},
      })

      vim.o.background = "dark"
      vim.cmd([[colorscheme tokyonight-moon]])
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<Leader>/",        [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]],  desc = "Telescope Grep" },
      { "<Leader>b",        [[<Cmd>lua require('telescope.builtin').buffers()<CR>]],    desc = "Telescope Buffers" },
      { "<Leader>f",        [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], desc = "Telescope Files" },
      { "<Leader>h",        [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]],  desc = "Telescope Help" },
      { "<Leader><Leader>", [[<Cmd>lua require('telescope.builtin').resume()<CR>]],     desc = "Telescope Resume" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd([[TSUpdate]])

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vim",
          "lua",
          "vimdoc",
          "bash",
          "css",
          "dockerfile",
          "go",
          "html",
          "javascript",
          "json",
          "markdown",
          "prisma",
          "rust",
          "sql",
          "tsx",
          "typescript"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
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
    version = "1.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    confing = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local check_backspace = function()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
      end

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "cmdline" },
        })
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "cssls",
          "dockerls",
          "gopls",
          "tsserver",
          "lua_ls",
          "pylsp",
          "rust_analyzer",
          "sqlls",
          "html",
          "tailwindcss",
          "vimls"
        },
      })

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set("n", "<space>wl", function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>df", function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("lspconfig").bashls.setup {
        capabilities = capabilities,
      }
      require("lspconfig").cssls.setup {
        capabilities = capabilities,
      }
      require("lspconfig").dockerls.setup {
        capabilities = capabilities,
      }
      require("lspconfig").gopls.setup {
        capabilities = capabilities,
      }
      require("lspconfig").tsserver.setup {
        capabilities = capabilities,
      }
      require("lspconfig").lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            }
          }
        }
      }
      require("lspconfig").pylsp.setup {
        capabilities = capabilities,
      }
      require("lspconfig").rust_analyzer.setup {
        capabilities = capabilities,
      }
      require("lspconfig").sqlls.setup {
        capabilities = capabilities,
      }
      require("lspconfig").html.setup {
        capabilities = capabilities,
      }
      require("lspconfig").astro.setup {
        capabilities = capabilities,
      }
      require("lspconfig").tailwindcss.setup {
        capabilities = capabilities,
      }
      require("lspconfig").svelte.setup {
        capabilities = capabilities,
        settings = {
          plugin = {
            css = {
              globals = true,
            }
          }
        },
      }
      require("lspconfig").vimls.setup {
        capabilities = capabilities,
      }
    end
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true
        },
      })
    end,
  },
  opts = function()
  end
})
