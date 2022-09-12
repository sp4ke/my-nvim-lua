local opt = vim.opt
local g = vim.g
local config = require("core.utils").load_config()

g.vim_version = vim.version().minor
g.nvchad_theme = config.ui.theme
g.toggle_theme_icon = "   "
g.transparency = config.ui.transparency
g.theme_switcher_loaded = false
-- g.fg_man_folding_enable = true -- enable folding for man pages


if vim.fn.executable("sh") then opt.shell = vim.fn.exepath("sh") end

-- use filetype.lua instead of filetype.vim. it's enabled by default in neovim 0.8 (nightly)
if g.vim_version < 8 then
  g.did_load_filetypes = 0
  g.do_filetype_lua = 1
end

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.title = true
opt.clipboard = "unnamed"
opt.cul = true -- cursor line
opt.colorcolumn = "80"
opt.rulerformat = "%30(%=:b%n%y%m%r%w %l,%c%V %P%)" -- NvChad has custom ruler !

-- Indenting
opt.expandtab = true -- Tabs are spaces, not tabs
opt.shiftwidth = 2 -- use indents of 2 spaces
opt.smartindent = true -- smart indent when starting new lines
opt.tabstop = 2 -- number of spaces when tab pressed
opt.softtabstop = 2 -- Let backspace delete indent
-- http://vim.wikia.com/wiki/Converting_tabs_to_spaces
opt.tabpagemax = 10

opt.fillchars = { eob = "∼" }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.cpoptions:append ">" --  When appending to registers use newline

-- GUI
opt.mousehide = true

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"
opt.viewoptions="folds,cursor"

-- . # and - are end of word designators
opt.iskeyword:remove(".")
opt.iskeyword:remove("#")
opt.iskeyword:remove("-")

--
-- folding with tree sitter
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
--
opt.foldminlines = 2
opt.foldlevelstart = 0
opt.conceallevel=1 -- how to show text with :syn-conceal syntax

opt.list = true -- show tabs,trailing spaces and non-breakable spaces
opt.listchars = "tab: ,trail:,extends:#,nbsp:⋅,eol:↴" -- Highlight problematic whitespace
opt.diffopt:append("vertical")
opt.completeopt = "menu,menuone,noselect"
opt.wrap = false
opt.formatoptions:append("b") -- Auto-wrap text based on textwidt
opt.matchpairs:append("<:>")


-- Lines to scroll when cursor leaves screen
opt.scrolljump=5
opt.scrolloff=3

-- Allow :find to work on all subdirectories
-- this only works when the original dir path is not changed
opt.path:append("**")


-- netrw file explorer (if it's used)
g.netrw_silent = 1
g.netrw_liststyle=3 -- Display more details with files
g.netrw_banner = 0 -- Remove banner at top
g.netrw_browse_split = 4 -- Open files in vertical split
g.netrw_winsize = 20 -- width of the window (25%)


opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- backups
opt.backup = true
opt.backupcopy = "yes"
opt.backupdir = vim.fn.expand("~/.share/nvim/backups")
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,resize,winpos"
g.sp4ke_bookmark_dir = vim.fn.stdpath("data") .. '/bookmarks'

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = ","

-- disable some builtin vim plugins
local default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(default_plugins) do
  g["loaded_" .. plugin] = 1
end

local default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

for _, provider in ipairs(default_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
