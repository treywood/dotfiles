(import-macros {: opt!} :macros)

:return

[:elmls
 (opt! :emmet_ls {:filetypes [:html :css]})
 :gopls
 :hhvm
 :hls
 :kotlin_language_server
 :metals
 (opt! :omnisharp {:cmd [:dotnet :/Library/OmniSharp/OmniSharp.dll]})
 :rust_analyzer
 :solargraph
 :sumneko_lua
 :tsserver
 :vuels]
