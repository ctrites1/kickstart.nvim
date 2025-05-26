-- Add these configurations to your existing nvim config

-- ===== ENHANCED INSERT-MODE FORMATTING =====

-- Better auto-indenting options
vim.opt.autoindent = true -- Keep indentation from previous line
vim.opt.smartindent = true -- Smart auto-indenting for C-like programs
vim.opt.cindent = true -- More aggressive C-style indenting

-- Format on type for specific characters
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
  callback = function()
    -- Format on semicolon and closing brace
    vim.keymap.set('i', ';', ';<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
    vim.keymap.set('i', '}', '}<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
  end,
})

-- Auto-format on certain key presses for specific languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'php' },
  callback = function()
    vim.keymap.set('i', ';', ';<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
  end,
})

-- Enhanced format-on-save with faster timeout and better error handling
local conform = require 'conform'
conform.setup {
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 1000, -- Increased timeout
      lsp_format = lsp_format_opt,
      quiet = true, -- Don't show errors in command line
    }
  end,
  -- Add format-on-type for specific file types
  format_after_save = {
    lsp_format = 'fallback',
  },
}

-- ===== ENHANCED LANGUAGE-SPECIFIC AUTOCOMPLETE =====

-- Add more completion sources to nvim-cmp
local cmp = require 'cmp'

-- Enhanced cmp setup with better language-specific sources
cmp.setup {
  sources = cmp.config.sources {
    {
      name = 'nvim_lsp',
      priority = 1000,
      -- More aggressive LSP completions
      keyword_length = 1,
      max_item_count = 50,
    },
    {
      name = 'luasnip',
      priority = 750,
      keyword_length = 2,
    },
    {
      name = 'nvim_lsp_signature_help',
      priority = 800,
    },
    {
      name = 'path',
      priority = 300,
      keyword_length = 2,
    },
    {
      name = 'tailwindcss-colorizer-cmp',
      priority = 200,
    },
  },

  -- Enhanced completion behavior
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
    keyword_length = 1,
  },

  -- Better formatting for completion items
  formatting = {
    format = function(entry, vim_item)
      -- Add source name to completion items
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        path = '[Path]',
        nvim_lsp_signature_help = '[Signature]',
        ['tailwindcss-colorizer-cmp'] = '[Color]',
      })[entry.source.name]
      return vim_item
    end,
  },

  -- Enhanced key mappings for better workflow
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false, -- Only confirm explicitly selected items
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
}

-- File-type specific completion configurations
cmp.setup.filetype('php', {
  sources = cmp.config.sources {
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'path', priority = 300 },
  },
})

cmp.setup.filetype({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }, {
  sources = cmp.config.sources {
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'tailwindcss-colorizer-cmp', priority = 600 },
    { name = 'path', priority = 300 },
  },
})

cmp.setup.filetype('python', {
  sources = cmp.config.sources {
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'path', priority = 300 },
  },
})

-- ===== ENHANCED LSP CONFIGURATION FOR BETTER COMPLETIONS =====

-- Enhanced LSP capabilities for better autocomplete
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enhanced completion capabilities
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

-- ===== AUTO-FORMATTING IMPROVEMENTS =====

-- Better indentation for specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'css', 'scss', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true

    -- Auto-close tags and brackets behavior
    vim.opt_local.matchpairs:append '<:>'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})

-- ===== SNIPPET ENHANCEMENTS =====

-- Load more language-specific snippets
require('luasnip.loaders.from_vscode').lazy_load {
  paths = {
    -- Add custom snippet paths here
    vim.fn.stdpath 'config' .. '/snippets',
  },
}

-- Enhanced snippet configuration
local ls = require 'luasnip'
ls.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}

-- ===== SMART FORMATTING KEYMAPS =====

-- Smart formatting that works in insert mode
vim.keymap.set('i', '<C-f>', '<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { desc = 'Format in insert mode' })

-- Auto-format and continue editing
vim.keymap.set('n', '<leader>F', function()
  vim.lsp.buf.format { async = true }
  vim.cmd 'startinsert'
end, { desc = 'Format and enter insert mode' })

-- ===== ADDITIONAL LANGUAGE-SPECIFIC FEATURES =====

-- Enhanced PHP completion and formatting
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    -- Auto-add PHP opening tag if file is empty
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines == 1 and lines[1] == '' then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { '<?php', '', '' })
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
    end
  end,
})

-- Enhanced JavaScript/TypeScript features
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    -- Auto-import on completion
    vim.keymap.set('n', '<leader>io', '<cmd>TypescriptOrganizeImports<CR>', { buffer = true, desc = 'Organize imports' })
    vim.keymap.set('n', '<leader>ia', '<cmd>TypescriptAddMissingImports<CR>', { buffer = true, desc = 'Add missing imports' })
  end,
})
