-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote

return {
    'echasnovski/mini.ai',
    version = '*',
    event = "VeryLazy",
    opts = {
        n_lines = 500
    }
}

