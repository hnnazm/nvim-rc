local function LspError()
  local sl = ''

  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    sl = sl .. ""  
    count = #vim.diagnostic.get(0, {
      severity = 1
    })
    sl = sl .. " ".. count
  end
  
  return sl
end

function LspWarn()
  local sl = ''

  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    sl = sl .. "" 
    count = #vim.diagnostic.get(0, {
      severity = 2
    })
    sl = sl .. " ".. count
  end
  
  return sl
end

local function LspInfo()
  local sl = ''

  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    sl = sl .. "" 
    count = #vim.diagnostic.get(0, {
      severity = 3
    })
    sl = sl .. " ".. count
  end

  return sl
end

local function LspHint()
  local sl = ''

  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    sl = sl .. "" 
    count = #vim.diagnostic.get(0, {
      severity = 4
    })
    sl = sl .. " ".. count
  end

  return sl
end

local function highlight(group, fg, bg)
  vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

highlight("StatusLeft", "red", "#32344a")
highlight("StatusMid", "green", "#32344a")
highlight("StatusRight", "blue", "#32344a")


function statusline()
  return table.concat {
    --"%#StatusLeft#",
    "main",
    "%=",
    "%F",
    --"%#StatusMid#",
    " ",
    "%=",
    --"%#StatusRight#",
    LspError(),
    " ",
    LspWarn(),
    " ",
    LspInfo(),
    " ",
    LspHint(),
  }
end

vim.o.statusline = "%!luaeval('statusline()')"
