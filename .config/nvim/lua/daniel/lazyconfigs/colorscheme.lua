-- Colorschemes:
return {
  'ribru17/bamboo.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('bamboo').setup {
      -- optional configuration here
    }
    require('bamboo').load()
  end,
}
-- {
--   'catppuccin/nvim',
--   lazy = false,
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   init = function()
--     vim.cmd.colorscheme 'catppuccin-macchiato'
--
--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- },
