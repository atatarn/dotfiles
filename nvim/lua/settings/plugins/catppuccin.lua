return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        vim.cmd([[colorscheme catppuccin-macchiato ]])

        return {
            dim_inactive = {
                enabled = true, -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
            term_colors = true,
        }
    end,
}
