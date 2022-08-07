vim.opt.backup          = false
vim.opt.clipboard       = "unnamedplus"
vim.opt.backspace       = { "indent", "eol", "start" }
vim.opt.autowrite       = true
vim.opt.history         = 200
vim.opt.confirm         = true
vim.opt.laststatus      = 3
vim.opt.showcmd         = true
vim.opt.hidden          = true
vim.opt.wrapscan        = false
vim.opt.wildmenu        = true
vim.opt.wildmode        = { "longest", "full" }
vim.opt.cmdheight       = 2
vim.opt.completeopt     = { "menuone", "noselect" }
vim.opt.conceallevel    = 0
vim.opt.fileencoding    = "utf-16"
vim.opt.hlsearch        = true
vim.opt.ignorecase      = true
vim.opt.mouse           = "a"
vim.opt.showmode        = false
vim.opt.showtabline     = 2
vim.opt.smartcase       = true
vim.opt.smartindent     = true
vim.opt.swapfile        = false
-- vim.opt.termguicolors   = false

vim.opt.ttimeout        = true
vim.opt.ttimeoutlen     = 1
vim.opt.timeout         = true
vim.opt.timeoutlen      = 500


vim.opt.undofile        = true
vim.opt.updatetime      = 300
vim.opt.writebackup     = false

vim.opt.textwidth       = 0
vim.opt.number          = true
vim.opt.relativenumber  = true
vim.opt.signcolumn      = "yes"
vim.opt.ruler           = false
vim.opt.list            = false
vim.opt.showbreak       = "↪"
vim.cmd [[ set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨ ]]
vim.opt.pumheight       = 10
vim.opt.cursorline      = false
vim.opt.cursorcolumn    = false
vim.opt.wrap            = true
vim.opt.scrolloff       = 8
vim.opt.sidescrolloff   = 8

vim.opt.numberwidth     = 4
vim.opt.expandtab       = true
vim.opt.shiftwidth      = 2
vim.opt.tabstop         = 2
vim.opt.softtabstop     = 2
vim.opt.shiftround      = true

vim.opt.showtabline     = 2
vim.opt.switchbuf       = "useopen"

vim.opt.splitbelow      = true
vim.opt.splitright      = true

vim.opt.guifont         = "FiraCode Nerd Font Mono:h14"

vim.opt.shortmess:append "c"

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work

vim.cmd [[
  if exists("g:neovide")
    let g:neovide_input_macos_alt_is_meta=v:true
    let g:neovide_cursor_vfx_mode = ""
    let g:neovide_cursor_animation_length=0

    execute('cd $HOME')
  endif
]]

