local function hl_links(table)
  for hl_group, target in pairs(table) do
    vim.api.nvim_set_hl(0, hl_group, { link = target })
  end
end

return {
  'sainnhe/everforest',
  priority = 1000,
  config = function()
    vim.o.background = 'dark'

    vim.g.everforest_background = 'hard'
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_diagnostic_text_highlight = 1

    vim.cmd('colorscheme everforest')

    vim.api.nvim_set_hl(0, 'Gray', { fg = '#a7b0a4' })
    vim.api.nvim_set_hl(0, 'GreenBold', { fg = '#a7c080', bold = true })

    hl_links {
      ['@parameter'] = 'Gray',
      ['@operator'] = 'Gray',
      ['@field'] = '@variable',
      ['@property'] = '@field',
      ['@lsp.type.property'] = '@property',
      ['@enumMember'] = '@field',
      ['@macro'] = '@function',
      ['@lsp.type.namespace'] = '@type',
      ['@lsp.type.parameter'] = '@identifier',
      ['@lsp.typemod.parameter.declaration'] = '@parameter',
      ['@identifier'] = 'Fg',

      -- ruby
      ['@symbol.ruby'] = 'Orange',
      ['@label.ruby'] = '@variable',

      -- go
      goTSProperty = '@field',
      goTSConstBuiltin = '@constant.builtin',

      -- yaml
      ['@field.yaml'] = 'Orange',
      yamlBlockMappingKey = 'Orange',
      yamlPlainScalar = 'String',
      yamlFlowString = 'String',
      yamlFlowStringDelimiter = 'String',
      yamlBlockCollectionItemStart = 'Gray',

      -- json
      ['@label.json'] = 'Orange',
      ['@string.json'] = '@string',

      GitSignsAdd = 'GreenSign',
      GitSignsChange = 'OrangeSign',
      GitSignsDelete = 'RedSign',

      MiniStarterHeader = 'Green',
      MiniStarterSection = 'Red',
      MiniStarterItem = 'Gray',
      MiniStarterItemBullet = 'GreenBold',
      MiniStarterItemPrefix = 'GreenBold',
      MiniStarterQuery = 'Orange',
      MiniStarterFooter = 'Gray',

      DevIconRb = 'Red',
    }

    vim.cmd([[
      hi ErrorText gui=none |
      hi WarningText gui=none |
      hi HintText gui=none |
      hi InfoText gui=none 
    ]])
  end,
}
