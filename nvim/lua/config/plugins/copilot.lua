return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = {
    copilot_node_command = '/opt/homebrew/bin/node',
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<C-l>',
        next = '<C-n>',
        prev = '<C-p>',
      },
    },
    panel = { enabled = false },
  },
}
