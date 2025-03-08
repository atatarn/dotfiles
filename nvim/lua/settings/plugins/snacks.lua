return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        lazygit = {
            enabled = true,
            configure = true,
        },
    },
    keys = {
        {
            "<leader>gg",
            function()
                Snacks.lazygit.open()
            end,
            desc = "Lazygit",
        },
        {
            "<leader>gl",
            function()
                Snacks.lazygit.log_file()
            end,
            desc = "Lazygit Log File",
        },
        {
            "<leader>nh",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "[N]otifications [H]istory",
        },
    },
}
