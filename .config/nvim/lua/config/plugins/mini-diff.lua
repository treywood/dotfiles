-- mini.diff owns all hunk signs: worktree-vs-index by default, and an
-- arbitrary unified diff on the buffers registered by `:RawDiff`.
--
--   :RawDiff                  patch = current buffer (e.g. an open .patch)
--   :RawDiff pr.patch         patch = file
--   :RawDiff !gh pr diff 42   patch = stdout of a shell command
--   :RawDiffClear             put every registered buffer back on the index
--
-- The hunks land on the *real* file buffers, not on the patch: `:RawDiff`
-- reverse-applies the patch to each buffer to recover the "before" text and
-- hands that to mini.diff as the reference. So the buffer has to match the
-- patch's post-image; mismatches are reported and skipped.
--
-- Index diffs get signs. Raw diffs additionally get mini.diff's overlay turned
-- on, since those buffers are for reading a change rather than editing one: the
-- patch's "before" lines are shown inline as virtual lines and changed words
-- are highlighted within a line.
--
-- `]c`/`[c` navigate, `<leader>hp` toggles the overlay, `<leader>hu` resets the
-- hunk under the cursor, `gh`/`gH` are mini.diff's apply/reset operators (`gh`
-- stages, and only against the index). Unstaging and blame are not mini.diff's
-- job -- use fugitive.

local diff = require('mini.diff')

--- Reference ("before") text of each `:RawDiff` buffer, keyed by bufnr.
--- @type table<integer, string>
local refs = {}

diff.setup {
  -- Registered raw diffs win; every other buffer diffs against the git index.
  -- Files git has no index entry for (untracked, ignored, outside a repo) get
  -- no signs, which is mini.diff's default behaviour.
  source = {
    {
      name = 'rawdiff',
      attach = function(buf)
        if not refs[buf] then
          return false
        end
        diff.set_ref_text(buf, refs[buf])
      end,
    },
    diff.gen_source.git(),
  },
  -- Default is 'number' whenever 'number' is set.
  view = { style = 'sign' },
}

-- mini.diff's actions raise an error on a buffer it cannot diff, so every map
-- below checks first rather than turning a stray `]c` into a stack trace. Two
-- states look alike and both happen constantly (patch buffers, untracked files,
-- scratch buffers): no cache at all ("Buffer N is not enabled") and a cache
-- whose source never produced a reference ("Buffer N has no reference text").
local function enabled()
  local data = diff.get_buf_data(0)
  return data ~= nil and data.ref_text ~= nil
end

--- @param what string
local function no_hunks(what)
  vim.notify('No ' .. what .. ' in this buffer', vim.log.levels.WARN)
end

--- @param dir 'next'|'prev'
--- @param key string Built-in diff-mode motion this key normally performs
local function goto_hunk(dir, key)
  if vim.wo.diff then
    -- A diff-mode window (`:Diff`, fugitive): keep the built-in meaning, see
    -- |]c|. mini.diff may also be attached here, but its hunks are against the
    -- index, not against the other side of the split.
    vim.cmd('normal! ' .. key)
  elseif enabled() then
    diff.goto_hunk(dir)
  elseif vim.bo.filetype == 'diff' then
    -- A patch buffer: step between `@@` headers instead.
    vim.fn.search('^@@', dir == 'next' and 'W' or 'bW')
  else
    no_hunks('hunks')
  end
end

vim.keymap.set('n', ']c', function()
  goto_hunk('next', ']c')
end, { desc = 'Next hunk' })
vim.keymap.set('n', '[c', function()
  goto_hunk('prev', '[c')
end, { desc = 'Previous hunk' })
vim.keymap.set('n', '<leader>hp', function()
  if enabled() then
    diff.toggle_overlay(0)
  else
    no_hunks('diff overlay')
  end
end, { desc = 'Toggle diff overlay' })
vim.keymap.set('n', '<leader>hu', function()
  if enabled() then
    -- `gH` (reset operator) over `gh` (hunk range textobject).
    vim.api.nvim_feedkeys(vim.keycode('gHgh'), 'm', false)
  else
    no_hunks('hunks')
  end
end, { desc = 'Reset hunk' })

--- @class RawDiffHunk
--- @field start number First line of the hunk on the patch's new side
--- @field old string[] Lines the hunk replaces (the "before" side)
--- @field new string[] Lines the hunk introduces (the "after" side)

--- Parse a unified diff.
---
--- Hunks are keyed by the post-image path (`+++`), since that is the file they
--- are displayed on; the pre-image path is kept only to name files the patch
--- deletes. Hunk bodies are read by the counts in the `@@` header so that
--- trailing junk (mail signatures in `git format-patch` output, commit
--- messages, `\ No newline at end of file`) cannot leak into a hunk.
---
--- @param lines string[]
--- @return { path: string, old_path: string, hunks: RawDiffHunk[] }[]
local function parse_patch(lines)
  local files = {} --- @type { path: string, old_path: string, hunks: RawDiffHunk[] }[]
  local file = nil --- @type { path: string, old_path: string, hunks: RawDiffHunk[] }?
  local hunk = nil --- @type RawDiffHunk?
  local old_path = '' -- most recent `---`, i.e. the pre-image of the next `+++`
  local old_want, new_want = 0, 0 --- @type number, number

  for _, line in ipairs(lines) do
    -- Inlined rather than a helper so the hunk body only reads lines the `@@`
    -- header promised, and so `hunk` narrows to non-nil below.
    if hunk and (#hunk.old < old_want or #hunk.new < new_want) then
      local tag, text = line:sub(1, 1), line:sub(2)
      if tag == ' ' then
        hunk.old[#hunk.old + 1], hunk.new[#hunk.new + 1] = text, text
      elseif tag == '-' then
        hunk.old[#hunk.old + 1] = text
      elseif tag == '+' then
        hunk.new[#hunk.new + 1] = text
      elseif line == '' then
        -- Some tools strip the leading space of empty context lines.
        hunk.old[#hunk.old + 1], hunk.new[#hunk.new + 1] = '', ''
      end
      -- Anything else (`\ No newline at end of file`) is not hunk content.
    else
      -- Strip the trailing tab-separated timestamp git adds for /dev/null.
      local path = line:match('^%+%+%+ ([^\t]*)')
      local old_count, new_start, new_count = line:match('^@@ %-%d+,?(%d*) %+(%d+),?(%d*) @@')
      if path then
        file = { path = path, old_path = old_path, hunks = {} }
        files[#files + 1] = file
      elseif line:match('^%-%-%- ') then
        old_path = line:match('^%-%-%- ([^\t]*)')
      elseif new_start and file then
        -- The patterns only ever capture digits, so the asserts never fire.
        old_want = old_count == '' and 1 or assert(tonumber(old_count))
        new_want = new_count == '' and 1 or assert(tonumber(new_count))
        hunk = { start = assert(tonumber(new_start)), old = {}, new = {} }
        file.hunks[#file.hunks + 1] = hunk
      end
    end
  end

  return files
end

--- Locate the file a patch path refers to, trying `-p1` before `-p0`.
--- @param path string
--- @param root string
--- @return string?
local function resolve(path, root)
  if path == '' or path == '/dev/null' then
    return nil
  end

  for _, p in ipairs { (path:gsub('^[^/]+/', '')), path } do
    if vim.startswith(p, '/') then
      if vim.uv.fs_stat(p) then
        return vim.fs.normalize(p)
      end
    else
      for _, base in ipairs { root, assert(vim.uv.cwd()) } do
        local full = vim.fs.joinpath(base, p)
        if vim.uv.fs_stat(full) then
          return vim.fs.normalize(full)
        end
      end
    end
  end
end

--- Recover the patch's pre-image by splicing each hunk's "before" lines back
--- into the buffer.
--- @param buf integer
--- @param hunks RawDiffHunk[]
--- @return string? ref Reference text, or nil if the buffer is not the post-image
--- @return integer? line Buffer line the mismatch was found on
local function build_ref(buf, hunks)
  local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local out = {} --- @type string[]
  local cursor = 1 -- next buffer line to copy

  for _, hunk in ipairs(hunks) do
    -- A hunk that adds nothing sits *after* `start` rather than at it.
    local at = #hunk.new == 0 and hunk.start + 1 or hunk.start
    if at < cursor then
      return nil, at -- overlapping or out-of-order hunks
    end

    for i = cursor, at - 1 do
      out[#out + 1] = buf_lines[i]
    end

    for i, line in ipairs(hunk.new) do
      if buf_lines[at + i - 1] ~= line then
        return nil, at + i - 1
      end
    end

    vim.list_extend(out, hunk.old)
    cursor = at + #hunk.new
  end

  for i = cursor, #buf_lines do
    out[#out + 1] = buf_lines[i]
  end

  return table.concat(out, '\n')
end

--- Re-run the source list for a buffer, which is how a buffer moves between
--- the raw-diff source and the git one. Disabling drops the overlay too, so a
--- buffer handed back to the index ends up with plain signs again.
--- @param buf integer
local function reattach(buf)
  diff.disable(buf)
  diff.enable(buf)
  local data = diff.get_buf_data(buf)
  if refs[buf] and data and not data.overlay then
    diff.toggle_overlay(buf)
  end
end

local group = vim.api.nvim_create_augroup('config_rawdiff', { clear = true })

-- Don't hold a whole file's worth of reference text for a buffer that is gone.
vim.api.nvim_create_autocmd('BufWipeout', {
  group = group,
  callback = function(ev)
    refs[ev.buf] = nil
  end,
  desc = 'Forget raw-diff reference text',
})

-- mini.diff re-enables a buffer on `BufEnter` (that is how it recovers from
-- `:edit`), which loses the overlay. Put it back for raw diffs.
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(ev)
    if not refs[ev.buf] then
      return
    end
    vim.schedule(function()
      local data = diff.get_buf_data(ev.buf)
      if refs[ev.buf] and data and not data.overlay then
        diff.toggle_overlay(ev.buf)
      end
    end)
  end,
  desc = 'Keep the overlay on raw-diff buffers',
})

--- @param arg string
--- @return string[]? lines
--- @return string label
local function read_patch(arg)
  if arg == '' then
    local name = vim.api.nvim_buf_get_name(0)
    local label = name == '' and ('buffer ' .. vim.api.nvim_get_current_buf()) or vim.fn.fnamemodify(name, ':~:.')
    return vim.api.nvim_buf_get_lines(0, 0, -1, false), label
  end

  if vim.startswith(arg, '!') then
    local cmd = arg:sub(2)
    local out = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify(
        ('`%s` exited with %d:\n%s'):format(cmd, vim.v.shell_error, table.concat(out, '\n')),
        vim.log.levels.ERROR
      )
      return nil, cmd
    end
    return out, cmd
  end

  local path = vim.fn.expand(arg)
  if vim.fn.filereadable(path) == 0 then
    vim.notify(('not readable: %s'):format(path), vim.log.levels.ERROR)
    return nil, path
  end
  return vim.fn.readfile(path), vim.fn.fnamemodify(path, ':~:.')
end

--- @return string
local function git_root()
  local out = vim.fn.systemlist { 'git', 'rev-parse', '--show-toplevel' }
  if vim.v.shell_error ~= 0 or not out[1] then
    return assert(vim.uv.cwd())
  end
  return out[1]
end

--- @param arg string
local function raw_diff(arg)
  local lines, label = read_patch(arg)
  if not lines then
    return
  end

  local files = parse_patch(lines)
  if #files == 0 then
    vim.notify(('no unified diff found in %s'):format(label), vim.log.levels.WARN)
    return
  end

  local root = git_root()
  local items = {} --- @type table[]
  local skipped = {} --- @type string[]
  local n_files, n_hunks = 0, 0

  for _, file in ipairs(files) do
    local path = resolve(file.path, root)
    if #file.hunks == 0 then
      -- Binary patches, pure renames and mode changes have nothing to show.
    elseif file.path == '/dev/null' then
      -- Nothing left to hang signs on.
      skipped[#skipped + 1] = ('%s (deleted by the patch)'):format(file.old_path)
    elseif not path then
      skipped[#skipped + 1] = ('%s (no such file)'):format(file.path)
    else
      local buf = vim.fn.bufadd(path)
      vim.fn.bufload(buf)

      local ref, line = build_ref(buf, file.hunks)
      if not ref then
        skipped[#skipped + 1] = ('%s (buffer does not match the patch at line %d)'):format(file.path, line)
      else
        refs[buf] = ref
        reattach(buf)
        n_files, n_hunks = n_files + 1, n_hunks + #file.hunks
        for _, hunk in ipairs(file.hunks) do
          items[#items + 1] = {
            filename = path,
            lnum = math.max(hunk.start, 1),
            text = ('-%d +%d'):format(#hunk.old, #hunk.new),
          }
        end
      end
    end
  end

  if #skipped > 0 then
    vim.notify(('RawDiff skipped:\n%s'):format(table.concat(skipped, '\n')), vim.log.levels.WARN)
  end

  if n_files == 0 then
    return
  end

  vim.fn.setqflist({}, ' ', { title = 'RawDiff: ' .. label, items = items })
  vim.cmd.cfirst()
  -- "patch hunks" because mini.diff re-diffs against the reference and may
  -- split or merge them; the quickfix list is the one entry per patch hunk.
  vim.notify(
    ('RawDiff: %d file%s, %d patch hunk%s (:copen for the list, :RawDiffClear to undo)'):format(
      n_files,
      n_files == 1 and '' or 's',
      n_hunks,
      n_hunks == 1 and '' or 's'
    )
  )
end

vim.api.nvim_create_user_command('RawDiff', function(cmd)
  raw_diff(cmd.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Show a raw unified diff as mini.diff hunks (patch: current buffer, {file} or !{cmd})',
})

vim.api.nvim_create_user_command('RawDiffClear', function()
  local bufs = vim.tbl_keys(refs)
  refs = {}
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      reattach(buf)
    end
  end
  vim.notify(('RawDiff: put %d buffer%s back on the git index'):format(#bufs, #bufs == 1 and '' or 's'))
end, { desc = 'Drop all raw diffs and go back to diffing against the index' })
