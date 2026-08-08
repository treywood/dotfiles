local parsers = { 'vim', 'lua', 'query', 'python', 'bash', 'json', 'markdown', 'markdown_inline' }

vim.treesitter.language.register('proto', 'protobuf')

-- (#heredoc-lang! @tag ["fallback"]) -- resolve a heredoc tag to a parser name.
--
-- Used by queries/dockerfile/injections.scm so `RUN ruby -e <<ruby` highlights
-- its body as ruby. The dockerfile grammar parses the heredoc body into a
-- separate heredoc_block sibling rather than leaving it inside the shell
-- fragment, so the injected bash tree never sees a heredoc_body and bash's own
-- tag-based injection can't fire -- the language has to be picked here instead.
--
-- Mirrors nvim's own resolve_lang: normalize, try the parser name, then the
-- filetype->parser registry. Unresolvable tags (EOF, END) use the fallback, or
-- inject nothing when none is given.
local function has_parser(lang)
  return vim._ts_has_language(lang) or #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) > 0
end

local function resolve_heredoc_lang(tag)
  local alias = tag:gsub('%s+', ''):lower():gsub('%-', '_')
  if alias:match('[%w_]+') ~= alias then return nil end
  if has_parser(alias) then return alias end
  local lang = vim.treesitter.language.get_lang(alias)
  if lang and has_parser(lang) then return lang end
  return nil
end

vim.treesitter.query.add_directive('heredoc-lang!', function(match, _, bufnr, pred, metadata)
  local nodes = match[pred[2]]
  local node = type(nodes) == 'table' and nodes[1] or nodes
  if not node then return end
  metadata['injection.language'] = resolve_heredoc_lang(vim.treesitter.get_node_text(node, bufnr) or '') or pred[3]
end, { force = true })

local treesitter = require('nvim-treesitter')
treesitter.setup()
treesitter.install(parsers)

local group = vim.api.nvim_create_augroup('config_treesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

require('nvim-treesitter-textobjects').setup {
  select = { lookahead = true },
  move = { set_jumps = true },
}

local select = require('nvim-treesitter-textobjects.select')
vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ak', function() select.select_textobject('@block.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ik', function() select.select_textobject('@block.inner', 'textobjects') end)

local move = require('nvim-treesitter-textobjects.move')
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']F', function() move.goto_next_end('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[F', function() move.goto_previous_end('@function.outer', 'textobjects') end)

require('treesitter-context').setup {
  patterns = {
    ruby = { 'do_block' },
  },
}
