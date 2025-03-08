-- See `:help gitsigns` to understand what the configuration keys do
return { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "┃" },
            untracked = { text = "┆" },
        },
        signs_staged = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "┃" },
            untracked = { text = "┆" },
        },
        signs_staged_enable = true,
    },
}
