local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local diff_files = function(opts)
  opts = opts or {}
  local base_branch = opts.base_branch or 'master'
  pickers.new(opts, {
    prompt_title = 'Git Diff Files',
    finder = finders.new_oneshot_job { 'git', 'diff', base_branch, '--name-only' },
    sorter = conf.file_sorter(opts),
    previewer = conf.file_previewer(opts),
  }):find()
end

return diff_files
