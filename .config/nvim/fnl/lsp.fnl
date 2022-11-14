(import-macros {: au! : => : dig!} :macros)

(vim.diagnostic.config {:virtual_text false})
(set vim.g.Illuminate_delay 500)

; setup nvim-cmp
(local cmp (require :cmp))
(local luasnip (require :luasnip))
(local lspkind (require :lspkind))

(fn has-words-before []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)
        fst (. (vim.api.nvim_buf_get_lines 0 (- line 1) line true) 1)
        fst-space (string.match (fst:sub col col) "%s")]
    (and (not= col 0) (= nil fst-space))))

(cmp.setup {:snippet {:expand (fn [args]
                                (luasnip.lsp_expand args.body))}
            :mapping (cmp.mapping.preset.insert {:<C-b> (cmp.mapping (cmp.mapping.scroll_docs -4)
                                                                     [:i :c])
                                                 :<C-f> (cmp.mapping (cmp.mapping.scroll_docs 4)
                                                                     [:i :c])
                                                 :<C-Space> (cmp.mapping (cmp.mapping.complete)
                                                                         [:i
                                                                          :c])
                                                 :<C-y> cmp.config.disable
                                                 :<C-e> (cmp.mapping {:i (cmp.mapping.abort)
                                                                      :c (cmp.mapping.close)})
                                                 :<Tab> (cmp.mapping (fn [fallback]
                                                                       (if (cmp.visible)
                                                                           (cmp.select_next_item)
                                                                           (luasnip.expand_or_jumpable)
                                                                           (luasnip.expand_or_jump)
                                                                           (has-words-before)
                                                                           (cmp.complete)
                                                                           (fallback)))
                                                                     [:i :s])
                                                 :<S-Tab> (cmp.mapping (fn [fallback]
                                                                         (if (cmp.visible)
                                                                             (cmp.select_prev_item)
                                                                             (luasnip.jumpable -1)
                                                                             (luasnip.jump -1)
                                                                             (fallback)))
                                                                       [:i :s])
                                                 :<CR> (cmp.mapping.confirm {:select false})})
            :sources (cmp.config.sources [{:name :nvim_lsp}
                                          {:name :luasnip}
                                          {:name :buffer}])
            :formatting {:format (lspkind.cmp_format {:mode :symbol_text})}})

(cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)
                        :sources [{:name :buffer}]})

(cmp.setup.cmdline ":"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :path}
                                                  {:name :cmdline}])})

(cmp.setup.filetype :http {:sources (cmp.config.sources [{:name :luasnip}])})

(let [lsp-kinds (dig! (require :cmp.types) :lsp :CompletionItemKind)
      entry_filter (fn [entry]
                     (let [kind (. lsp-kinds (entry:get_kind))]
                       (= kind :Folder)))]
  (cmp.setup.filetype :TelescopePrompt
                      {:enabled true
                       :completion {:autocomplete false}
                       :sources (cmp.config.sources [{:name :path
                                                      : entry_filter}])}))

(let [(have-servers? servers) (pcall require :lsp-servers)]
  (when have-servers?
    (let [nvim-lsp (require :lspconfig)
          capabilities ((. (require :cmp_nvim_lsp) :default_capabilities))]
      (set capabilities.textDocument.completion.completionItem.snippetSupport
           true)

      (fn on-attach [client bufnr]
        ((. (require :keymaps) :setup-lsp) bufnr)
        ((. (require :illuminate) :on_attach) client)
        (set client.server_capabilities.documentFormattingProvider false)
        (set client.server_capabilities.documentRangeFormattingProvider false))

      (each [_ lsp (ipairs servers)]
        (var lsp-name lsp)
        (var config {:on_attach on-attach
                     : capabilities
                     :flags {:debounce_text_changes 150}})
        (when (= (type lsp) :table)
          (set lsp-name (table.remove lsp 1))
          (set config (vim.tbl_deep_extend :force config lsp)))
        ((dig! nvim-lsp lsp-name :setup) config)))))

(let [(have-sources? sources) (pcall require :null-ls-sources)]
  (when have-sources?
    (local null-ls (require :null-ls))
    (null-ls.setup {:debug true
                    : sources
                    :on_attach (fn [client bufnr]
                                 (when client.server_capabilities.documentFormattingProvider
                                   (au! :BufWritePre
                                        {:buffer bufnr
                                         :callback (=> (vim.lsp.buf.format {:async false}))})))})))

((. (require :fidget) :setup) {:text {:spinner :dots_snake}})
