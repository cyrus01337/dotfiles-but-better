local opt = vim.opt

-- columnstuff
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.termguicolors = true
opt.showmode = false
opt.signcolumn = "yes"
opt.winborder = "rounded"

-- highlight line that cursor is at
opt.cursorline = true

-- indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- navigation
opt.splitright = true
opt.splitbelow = true
opt.mouse = ""
opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

-- searchstuff
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- undo history
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undotree"

-- hard-wrap comments
opt.textwidth = 80
opt.formatoptions = "c"

-- ensure newline at end of file
opt.fileformat = "unix"
opt.fileformats = "unix"
opt.fixendofline = true

-- limelight configuration
vim.g.limelight_conceal_ctermfg = "gray"
vim.g.limelight_conceal_guifg = "DarkGray"
