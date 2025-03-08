-- https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent
vim.cmd("filetype plugin indent on")

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Is this needed?
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Is this needed?
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- vim.opt.autochdir = true

-- Save undo history, backup settings etc
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup//"
vim.opt.directory = os.getenv("HOME") .. "/.local/share/nvim/swap//"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--vim.schedule(function()
--  vim.opt.clipboard = 'unnamedplus'
--end)
-- Actually, this hack-ish(?) way to intergrate win32yank works pretty good in WSL
-- keymaps below used to be the case, but vim.opt.clipboard seems to just work fine for now
-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("v", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
        ["+"] = "win32yank.exe -o --crlf",
        ["*"] = "win32yank.exe -o --crlf",
    },
    cache_enable = 0,
}

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "auto:4"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { lead = "·", tab = "-> ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
--vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- the following used to be set, not sure if still needed
-- vim.opt.isfname:append("@-@")

-- misc stuff
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- wrap - "break" line in two to fit the screen width
vim.opt.wrap = true

-- searching opts
-- hlsearch used to be false, let's try it enabled
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- sessions
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
