au! BufEnter <buffer> setlocal cursorline guicursor+=a:Cursor/lCursor
      \ | hi Cursor blend=100

au! BufLeave <buffer> hi Cursor blend=0

