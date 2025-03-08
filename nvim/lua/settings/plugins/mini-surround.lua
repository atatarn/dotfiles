-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
return {
    'echasnovski/mini.surround',
    version = '*',
    event = "VeryLazy",
    opts = {}
}
