(import-macros {: =>} :macros)

(local diff_files (require :pickers.diff-files))
(local telescope (require :telescope))
(local luasnip (require :luasnip))

(local Keymaps {})

(local general-maps {:n {:<C-e> ":Telescope oldfiles cwd_only=true<CR>"
                         :<C-p> ":Telescope git_files<CR>"
                         :<C-f> telescope.extensions.live_grep_args.live_grep_args
                         :<C-b> ":Telescope buffers<CR>"
                         :<C-y> diff_files
                         :- ":NvimTreeToggle<CR>"
                         :+ ":NvimTreeFindFileToggle<CR>"
                         :<leader>tn ":TestNearest<CR>"
                         :<leader>tf ":TestFile<CR>"
                         :<leader>tt ":TestLast<CR>"
                         :<leader>W ":%bd!<CR>"
                         :<leader>w ":%bd!|e#|bd!<CR>"
                         "]c" "<cmd>Gitsigns next_hunk<CR>"
                         "[c" "<cmd>Gitsigns prev_hunk<CR>"
                         :<leader>hp "<cmd>Gitsigns preview_hunk<CR>"
                         :<leader>hu "<cmd>Gitsigns reset_hunk<CR>"
                         :<leader>cn ":cnext<CR>"
                         :<leader>cN ":cprevious<CR>"
                         :<leader>gy ":GBrowse<CR>"
                         :<leader>s "<Plug>(leap-forward-to)"
                         :<leader>S "<Plug>(leap-backward-to)"}
                     :i {:<C-j> (=> (luasnip:change_choice 1))
                         :<C-Space>c "<Plug>(sq-connect-insert-customer-id)"
                         :<C-Space>m "<Plug>(sq-connect-insert-merchant-id)"
                         :<C-Space>l "<Plug>(sq-connect-insert-location-id)"}
                     :v {:<C-Space>c "<Plug>(sq-connect-insert-customer-id)"
                         :<C-Space>m "<Plug>(sq-connect-insert-merchant-id)"
                         :<C-Space>l "<Plug>(sq-connect-insert-location-id)"
                         :<leader>gy ":'<,'>GBrowse!<CR>"}
                     :s {:<C-Space>c "<Plug>(sq-connect-insert-customer-id)"
                         :<C-Space>m "<Plug>(sq-connect-insert-merchant-id)"
                         :<C-Space>l "<Plug>(sq-connect-insert-location-id)"}
                     :t {:<Esc> "<C-\\><C-n>"}
                     "" {:n "<Plug>(is-n)zzzv"
                         :N "<Plug>(is-N)zzzv"
                         :* "<Plug>(is-*)"
                         "#" "<Plug>(is-#)"}})

(local lsp-maps
       {:n {:K vim.lsp.buf.hover
            :gD vim.lsp.buf.declaration
            :gd ":Telescope lsp_definitions<CR>"
            :gi ":Telescope lsp_implementations<CR>"
            :gr ":Telescope lsp_references<CR>"
            :<leader>a vim.lsp.buf.code_action
            :<leader>e vim.diagnostic.open_float
            :<leader>rn vim.lsp.buf.rename
            "[d" vim.diagnostic.goto_prev
            "]d" vim.diagnostic.goto_next
            :<C-j> ":Telescope lsp_document_symbols<CR>"}})

(fn set-maps [mode-maps opts]
  (each [mode maps (pairs mode-maps)]
    (each [lhs rhs (pairs maps)]
      (vim.keymap.set mode lhs rhs opts))))

(fn Keymaps.setup []
  (set-maps general-maps {:silent true}))

(fn Keymaps.setup-lsp [bufnr]
  (set-maps lsp-maps {:noremap true :silent true :buffer bufnr}))

:return

Keymaps
