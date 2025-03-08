-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


-- configure Lazy to load plugins from plugins dir and some additional stuff
require("lazy").setup({
  defaults = {
    lazy = true,
    version = "*",
  },
  spec = {
    { import = "settings/plugins" },
  },
  install = {
    colorscheme = { "catppuccin-frappe" },
  },
  checker = { enabled = false },
})

vim.keymap.set("n", "<leader>p", "<cmd>:Lazy<cr>", { desc = "Open Lazy" })

