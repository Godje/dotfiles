require 'options'
require 'keymaps'

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { '*.c', '*.cpp', '*.h' },
  command = 'setlocal tabstop=4',
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.js*', '*.ts*' },
  callback = function()
    vim.keymap.set('i', '<C-l>', 'console.log()<Esc>i', {
      buffer = 0,
      silent = true,
    })
  end,
})

-- Markdown file autocommands
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.md' },
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.wrap = true
    -- navigation local noremaps
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = 0,
        silent = true,
      })
    end

    map('n', '<Up>', 'gk')
    map('n', '<Down>', 'gj')
    map('n', '<Home>', 'g<Home>')
    map('n', '<End>', 'g<End>')
    map('n', 'j', 'gj')
    map('n', 'k', 'gk')
    map('i', '<Up>', '<C-o>gk')
    map('i', '<Down>', '<C-o>gj')
    map('i', '<Home>', '<C-o>g<Home>')
    map('i', '<End>', '<C-o>g<End>')

    -- bold, italic, and teleports
    map('i', '\\b', '**** <++><Esc>F*hi')
    map('i', '\\i', '** <++><Esc>F*i')
    map('i', '\\<Space>', '<Esc>/<++><CR>v3l"_di')
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  require 'daniel.lazyconfigs.which-key',
  require 'daniel.lazyconfigs.telescope-nvim',
  require 'daniel.lazyconfigs.nvim-cmp',
  require 'daniel.lazyconfigs.nvim-lspconfig',
  require 'daniel.lazyconfigs.conform-nvim',
  require 'daniel.lazyconfigs.nvim-treesitter',
  require 'daniel.lazyconfigs.clipboard-image',
  require 'daniel.lazyconfigs.colorscheme',
  require 'daniel.lazyconfigs.mini-nvim',

  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
