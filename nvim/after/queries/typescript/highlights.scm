;; extends

(decorator
  [
   (identifier) @attribute
   (call_expression (identifier) @attribute)
  ] (#set! "priority" 130)
)


