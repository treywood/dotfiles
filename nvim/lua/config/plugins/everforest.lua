return {
  'sainnhe/everforest',
  config = function()
    vim.o.background = 'dark'

    vim.g.everforest_background = 'hard'
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_diagnostic_text_highlight = 1

    vim.cmd('colorscheme everforest')

    vim.api.nvim_set_hl(0, 'Gray', { fg = '#a7b0a4' })
    vim.api.nvim_set_hl(0, 'GreenBold', { fg = '#a7c080', bold = true })

    vim.api.nvim_set_hl(0, '@parameter', { link = 'Gray' })
    vim.api.nvim_set_hl(0, '@operator', { link = 'Gray' })
    vim.api.nvim_set_hl(0, '@field', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@property', { link = '@field' })

    vim.api.nvim_set_hl(0, '@symbol.ruby', { link = 'Orange' })
    vim.api.nvim_set_hl(0, '@label.ruby', { link = '@variable' })

    vim.api.nvim_set_hl(0, '@field.yaml', { link = 'Orange' })
    vim.api.nvim_set_hl(0, 'yamlBlockMappingKey', { link = 'Orange' })
    vim.api.nvim_set_hl(0, 'yamlPlainScalar', { link = 'String' })
    vim.api.nvim_set_hl(0, 'yamlBlockCollectionItemStart', { link = 'Gray' })

    vim.api.nvim_set_hl(0, '@label.json', { link = 'Orange' })
    vim.api.nvim_set_hl(0, '@string.json', { link = '@string' })

    vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GreenSign' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'OrangeSign' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'RedSign' })

    vim.api.nvim_set_hl(0, 'MiniStarterHeader', { link = 'Green' })
    vim.api.nvim_set_hl(0, 'MiniStarterSection', { link = 'Red' })
    vim.api.nvim_set_hl(0, 'MiniStarterItem', { link = 'Gray' })
    vim.api.nvim_set_hl(0, 'MiniStarterItemBullet', { link = 'GreenBold' })
    vim.api.nvim_set_hl(0, 'MiniStarterItemPrefix', { link = 'GreenBold' })
    vim.api.nvim_set_hl(0, 'MiniStarterQuery', { link = 'Orange' })
    vim.api.nvim_set_hl(0, 'MiniStarterFooter', { link = 'Gray' })

    vim.api.nvim_set_hl(0, 'DevIconRb', { link = 'Red' })

    vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { link = 'Orange' })
    vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', { link = 'Yellow' })

    vim.cmd([[
      hi ErrorText gui=none |
      hi WarningText gui=none |
      hi HintText gui=none |
      hi InfoText gui=none 
    ]])
  end,
}
