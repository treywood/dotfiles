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
      ['@conditional.ternary'] = 'Gray',
      ['@enumMember'] = '@field',
      ['@field'] = '@variable',
      ['@identifier'] = 'Fg',
      ['@lsp.type.namespace'] = '@type',
      ['@lsp.type.property'] = '@property',
      ['@lsp.type.parameter'] = '@identifier',
      ['@lsp.typemod.parameter.declaration'] = '@parameter',
      ['@macro'] = '@function',
      ['@operator'] = 'Gray',
      ['@parameter'] = 'Gray',
      ['@variable.parameter'] = '@parameter',
      ['@property'] = '@field',
      ['@type.qualifier'] = '@keyword',
      ['@variable.member'] = '@variable',

      -- ruby
      ['@label.ruby'] = '@variable',
      ['@symbol.ruby'] = 'Orange',
      ['@string.special.symbol.ruby'] = 'Orange',
      ['@constant.ruby'] = '@type',

      -- go
      goTSConstBuiltin = '@constant.builtin',
      goTSProperty = '@field',

      -- yaml
      ['@field.yaml'] = 'Orange',
      ['@property.yaml'] = 'Orange',
      ['@string.yaml'] = '@string',
      yamlBlockCollectionItemStart = 'Gray',
      yamlBlockMappingKey = 'Orange',
      yamlFlowString = 'String',
      yamlFlowStringDelimiter = 'String',
      yamlPlainScalar = 'String',

      -- json
      ['@label.json'] = 'Orange',
      ['@string.json'] = '@string',
      jsonKeyword = 'Orange',
      jsonString = '@string',

      -- java
      ['@attribute.java'] = 'Orange',
      ['@keyword.operator.java'] = '@keyword',
      ['@constant.java'] = 'Red',

      -- rust
      ['@lsp.type.operator.rust'] = '@punctuation.delimiter.rust',

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
