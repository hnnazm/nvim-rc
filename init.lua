vim.g.mapleader  = " "

vim.o.compatible = false
vim.o.hidden     = true
vim.o.confirm    = true

vim.opt.clipboard:append "unnamedplus"

vim.opt.expandtab          = true
vim.opt.shiftwidth         = 2
vim.opt.tabstop            = 2
vim.opt.softtabstop        = 2
vim.opt.shiftround         = true

vim.opt.splitbelow         = true
vim.opt.splitright         = true

vim.opt.scrolloff          = 10
vim.opt.sidescroll         = 10
vim.opt.sidescrolloff      = 10

vim.opt.number             = true
vim.opt.relativenumber     = true

vim.opt.signcolumn         = "yes"

vim.g.netrw_banner         = 0
vim.g.netrw_winsize        = 30
vim.g.netrw_wiw            = 30
vim.g.netrw_usetab         = 1
vim.g.netrw_browse_split   = 4
vim.g.netrw_liststyle      = 3
vim.g.netrw_altfile        = 1
vim.g.netrw_keepdir        = 1
vim.g.netrw_dirhistmax     = 0
vim.g.netrw_browsex_viewer = "open"
vim.g.netrw_sort_by        = "exten"
vim.g.netrw_sort_direction = "normal"
vim.g.netrw_sort_options   = "i"
vim.cmd [[
let g:netrw_list_hide       = netrw_gitignore#Hide()
let g:netrw_list_hide       = '\(^\|\s\s\)\zs\.\S\+'
]]

vim.keymap.set("n", "<Leader>f", "<Plug>NetrwShrink")
vim.keymap.set("n", "<Leader>f", "<Cmd>Lex!<CR>")

vim.cmd [[
function! VisualRuler()
  set cursorcolumn! cursorline!
endfunction
]]

vim.keymap.set("n", "<LocalLeader>r", "<Cmd>call VisualRuler()<CR>")
vim.keymap.set("n", "<LocalLeader>w", "<Cmd>set wrap!<CR>")

vim.keymap.set("n", "<C-k>", "<Cmd>bprevious<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>bnext<CR>")
vim.keymap.set("n", "<C-x><C-b>", "<Cmd>bprevious<CR><Cmd>bdelete #<CR>")

vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")
vim.keymap.set("n", "<C-x><C-t>", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<Esc>h", "<Cmd>-tabmove<CR>")
vim.keymap.set("n", "<Esc>l", "<Cmd>+tabmove<CR>")
vim.keymap.set("n", "<C-w><C-e>", "<Cmd>tab split<CR>")

vim.keymap.set("n", "<C-x>t", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<C-x>b", "<Cmd>bp<CR><Cmd>bd #<CR>")

vim.keymap.set("n", "<Leader>o", ":<C-u>find ")
vim.keymap.set("n", "<Leader>i", ":<C-u>buffer ")

vim.keymap.set("v", "p", [["_dP]])

vim.keymap.set("n", "<BS>", "<Cmd>nohlsearch<CR>")

vim.keymap.set("n", "<Leader>co", "<Cmd>copen<CR>")
vim.keymap.set("n", "<Leader>cc", "<Cmd>cclose<CR>")
vim.keymap.set("n", "<C-n>", "<Cmd>cnext<CR>")
vim.keymap.set("n", "<C-p>", "<Cmd>cprevious<CR>")

vim.keymap.set("v", "<Leader>x", [[:<C-U>execute ":'<,'>w !bash"<CR>]])

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

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
          additional_vim_regex_highlighting = { 'markdown' },
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
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local enabled_servers = {
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
        "volar",
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = enabled_servers,
      })

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist)

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
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
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

      -- loop all lsp servers and setup capabilities
      -- allow for custom setup for each lsp server
      for _, server in ipairs(enabled_servers) do
        local config = require("lspconfig")[server]
        if config then
          config.setup {
            capabilities = capabilities,
          }
        end
      end

      require("lspconfig").volar.setup {
        capabilities = capabilities,
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
        filetypes = {
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "json"
        }
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
    end
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
  opts = function()
  end
})

vim.cmd [[
function! SetNewPath()
  let l:new_path = '.,' . $PWD . '/**,' . ',,'
  execute 'set path=' . l:new_path
endfunction

" Call the function when Vim starts
autocmd VimEnter * call SetNewPath()
]]

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --no-heading"
  vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

local function copy_file_path()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    print('No file path available')
    return
  end
  vim.fn.setreg('+', file_path)  -- Copy to system clipboard
  print('Copied: ' .. file_path)
end

local function change_to_file_dir()
  local file_dir = vim.fn.expand('%:p:h')
  if file_dir == '' then
    print('No directory available')
    return
  end
  vim.cmd('lcd ' .. vim.fn.fnameescape(file_dir))  -- Change local working directory
  print('Changed directory to: ' .. file_dir)
end

vim.api.nvim_create_user_command('CopyFilePath', copy_file_path, {})
vim.api.nvim_create_user_command('ChangeToFileDir', change_to_file_dir, {})

vim.keymap.set('n', '<leader>cc', copy_file_path, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cd', change_to_file_dir, { noremap = true, silent = true })
