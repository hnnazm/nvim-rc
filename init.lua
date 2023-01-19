vim.o.hidden                = true
vim.opt.confirm             = true
vim.o.showtabline           = 2
vim.o.switchbuf             = "usetab,newtab"

vim.o.clipboard             = "unnamedplus"

vim.o.background            = dark

vim.o.number                = true
vim.o.relativenumber        = true
vim.o.numberwidth           = 4

vim.o.showcmd               = true
vim.o.showmode              = false
vim.o.cursorline            = true
vim.o.cursorcolumn          = true

vim.o.wrap                  = false

vim.o.foldmethod            = "expr"
vim.o.foldexpr              = vim.cmd("call nvim_treesitter#foldexpr()")
vim.o.foldenable            = false

vim.opt.splitbelow          = true
vim.opt.splitright          = true

vim.o.expandtab             = true
vim.o.shiftwidth            = 2
vim.o.tabstop               = 2
vim.o.softtabstop           = 2
vim.o.shiftround            = true

vim.o.hlsearch              = true
vim.o.incsearch             = true
vim.o.wrapscan              = false

vim.o.ttimeout              = true
vim.o.ttimeoutlen           = 300
vim.o.timeout               = true
vim.o.timeoutlen            = 500

vim.g.mapleader             = " "
vim.g.localmapleader        = "\\"

vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "j", "gj")

vim.keymap.set("n", "<Leader>ff", "<Cmd>Lex!<CR>")
vim.keymap.set("n", "<Leader>fb", "<Cmd>buffers<CR>:sbuffer ")

vim.keymap.set("n", "<C-k>", "<Cmd>bprevious<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>bnext<CR>")

vim.keymap.set("n", "<Tab>", "<Cmd>buffer #<CR>")

vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")

vim.keymap.set("n", "<C-x>t", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<C-x>b", "<Cmd>bp<CR><Cmd>bd #<CR>")

vim.keymap.set("v", "p", [["_dP]])

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

vim.g.netrw_banner          = 0
vim.g.netrw_banner          = 0
vim.g.netrw_winsize         = 30
vim.g.netrw_wiw             = 1
vim.g.netrw_usetab          = 1
vim.g.netrw_browse_split    = 0
vim.g.netrw_alto            = 1
vim.g.netrw_altv            = 1
vim.g.netrw_liststyle       = 3
vim.g.netrw_altfile         = 1
vim.g.netrw_cursor          = 4
vim.g.netrw_keepdir         = 1
vim.g.netrw_dirhistmax      = 0
vim.g.netrw_browsex_viewer  = "open"
vim.g.netrw_sort_by         = "exten"
vim.g.netrw_sort_direction  = "reverse"
vim.g.netrw_sort_options    = "i"
-- vim.g.netrw_list_hide = netrw_gitignore#Hide()
-- vim.g.netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
-- let g:netrw_chgwin = 2

vim.keymap.set("n", "<LocalLeader>s", "<Cmd>w<CR><Cmd>source %<CR>")

vim.cmd[[colorscheme habamax]]

vim.o.statusline = statusline
vim.o.laststatus = 3
vim.o.showmode = 0

local function update_statusline()
  local function git_branch()
    local branch = vim.api.nvim_call_function("system", {"git rev-parse --abbrev-ref HEAD 2>/dev/null"})
    if branch == "" then
      return ""
    else
      return "[" .. branch .. "]"
    end
  end

  local cwd = vim.fn.getcwd()
  local filename = vim.fn.expand("%:t")
  local git_info = git_branch()

  local statusline = git_info .. " " .. "%=" .. filename .. "%=" .. " " .. cwd 

  vim.o.statusline = statusline
end
local StatusLine = vim.api.nvim_create_augroup("StatusLine", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  group = StatusLine,
  callback = update_statusline
})

local VisualRuler = vim.api.nvim_create_augroup("VisualRuler", { clear = true })
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  group = VisualRuler,
  command = "set nocursorline nocursorcolumn",
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  group = crosshair,
  command = "set cursorline cursorcolumn",
})

local Netrw = vim.api.nvim_create_augroup('Netrw', { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd" }, {
  pattern = "NetrwTreeListing",
  group = Netrw,
  callback = function()
    vim.o.cursorline   = false
    vim.o.cursorcolumn = false

    vim.keymap.set("n", "<LocalLeader><LocalLeader>", "<Plug>NetrwShrink")
  end,
})

require'nvim-treesitter.configs'.setup {
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
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}

vim.opt.shortmess:append "c"
vim.opt.path:append { string.format("%s/**", vim.fn.getcwd()), }
vim.opt.wildignore:append { "*/node_modules/*" }
