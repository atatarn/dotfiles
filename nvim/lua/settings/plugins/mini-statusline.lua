-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md

return {
    'echasnovski/mini.statusline',
    version = '*',
    lazy = false,
    opts = function(_, opts)
        local statusline = require("mini.statusline")
        statusline.section_location = function()
            return '%2l:%-2v'
        end

        return {
            use_icons = vim.g.have_nerd_font,
        }
    end
}
