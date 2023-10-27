return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = {
    copilot_node_command = '/opt/homebrew/bin/node',
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
