(local null-ls (require :null-ls))
(local helpers (require :null-ls.helpers))

(local formatter-stylish_haskell
       {:name :stylish-haskell
        :filetypes [:haskell]
        :method null-ls.methods.FORMATTING
        :generator (helpers.formatter_factory {:command :stylish-haskell
                                               :to_stdin true
                                               :from_stderr true})})

(local formatter-scalariform
       {:name :scalariform
        :filetypes [:scala :sbt]
        :method null-ls.methods.FORMATTING
        :generator (helpers.formatter_factory {:command :scalariform
                                               :args [:--stdin]
                                               :to_stdin true})})

(local formatter-hackfmt
       {:name :hackfmt
        :filetypes [:hack :php]
        :method null-ls.methods.FORMATTING
        :generator (helpers.formatter_factory {:command :hackfmt
                                               :to_stdin true})})

:return

[;; formatters
 null-ls.builtins.formatting.elm_format
 ; null-ls.builtins.formatting.fnlfmt
 null-ls.builtins.formatting.gofmt
 null-ls.builtins.formatting.rufo
 null-ls.builtins.formatting.rustfmt
 null-ls.builtins.formatting.stylua
 formatter-hackfmt
 formatter-scalariform
 formatter-stylish_haskell]
