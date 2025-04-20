return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
    },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Laravel' },
    config = function()
      require('laravel').setup()

      -- Laravel specific keymaps
      -- vim.keymap.set('n', '<leader>la', ':Laravel artisan<CR>')
      -- vim.keymap.set('n', '<leader>lr', ':Laravel routes<CR>')
      -- vim.keymap.set('n', '<leader>lm', ':Laravel models<CR>')
    end,
  },
  {
    'jwalton512/vim-blade',
    ft = 'blade',
    dependencies = {
      'sheerun/vim-polyglot',
    },
  },
  {
    'gbprod/phpactor.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
    ft = 'php',
  },
}
