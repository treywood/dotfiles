; Replaces (not extends) the upstream nvim-treesitter dockerfile injections.
; Deliberately NOT in after/ and deliberately without a `;; extends` modeline:
; nvim treats the first non-extending file on the rtp as the base query and
; drops the rest, and ~/.config/nvim sorts ahead of ~/.local/share/nvim/site.
; An `;; extends` file would keep upstream's blanket `heredoc_block -> bash`
; rule and double-inject every tagged heredoc.
;
; The only change from upstream is the heredoc handling: upstream hardcodes
; bash, we use the heredoc tag as the language (see the `heredoc-lang!`
; directive in lua/config/plugins/treesitter.lua).

((comment) @injection.content
  (#set! injection.language "comment"))

((shell_command
  (shell_fragment) @injection.content)
  (#set! injection.language "bash")
  (#set! injection.combined))

; RUN <<ruby ... ruby   -> ruby
; RUN <<EOF ... EOF     -> bash (fallback arg), matching upstream behaviour
((run_instruction
  (heredoc_block
    (heredoc_line)+ @injection.content
    (heredoc_end) @_tag))
  (#heredoc-lang! @_tag "bash")
  (#set! injection.include-children)
  (#set! injection.combined))

; COPY <<json /app/c.json -> json. No fallback: an untagged COPY heredoc is
; file content, not shell, so it should stay unhighlighted.
((copy_instruction
  (heredoc_block
    (heredoc_line)+ @injection.content
    (heredoc_end) @_tag))
  (#heredoc-lang! @_tag)
  (#set! injection.include-children)
  (#set! injection.combined))
