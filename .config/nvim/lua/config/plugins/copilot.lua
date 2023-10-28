local brew_prefix = vim.fn.system('brew --prefix'):gsub('%s+', '')

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = {
    copilot_node_command = brew_prefix .. '/bin/node',
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<C-Space>',
        next = '<C-k>',
        prev = '<C-j>',
      },
    },
    panel = { enabled = false },
  },
}
