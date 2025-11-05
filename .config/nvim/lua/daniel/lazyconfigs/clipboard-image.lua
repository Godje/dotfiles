return {
  'dfendr/clipboard-image.nvim',
  event = 'VimEnter',
  config = function()
    require('clipboard-image.init').setup {
      default = {
        img_dir = function()
          return (vim.fn.expand '%:p:h') .. '/' .. (vim.fn.expand '%:t:r') .. '_imgs'
        end,
        img_dir_txt = function()
          return (vim.fn.expand '%:t:r') .. '_imgs'
        end,
        img_name = function()
          return (os.date '%Y-%m-%d-%H-%M-%S') .. '_pasted'
        end,
      },
    }
  end,
}
