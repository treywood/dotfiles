if !exists('g:test#java#bazeltest#file_pattern')
  let g:test#java#bazeltest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#bazeltest#test_file(file) abort
  if exists('g:test#java#runner') && g:test#java#runner == 'bazeltest'
    return 1
  elseif exists('g:test#java#runner') && g:test#java#runner != 'bazeltest'
    return 0
  endif
  return a:file =~? g:test#java#bazeltest#file_pattern
endfunction

function! test#java#bazeltest#build_position(type, position) abort
  let l:module_info = s:get_bazel_module(a:position['file'])
  let l:modulename = join(l:module_info, ':')
  if a:type ==# 'nearest'
    let l:classname = substitute(l:module_info[1], '/', '.', 'g')
    let l:name = s:nearest_test(a:position, l:classname)
    if !empty(l:name)
      return ['--test_filter="' . l:name . '"', l:modulename, '--verbose_failures']
    else
      return [l:modulename]
    endif
  elseif a:type ==# 'file'
    return [l:modulename]
  else
    return [l:modulename]
  endif
endfunction

function! s:get_bazel_module(filepath)
  let l:file_dir = fnamemodify(a:filepath, ':.')
  let l:project_root = fnamemodify(l:file_dir, ':h')

  while !filereadable(l:project_root.'/WORKSPACE') && !filereadable(l:project_root.'/BUILD')
    let l:project_root = fnamemodify(l:project_root, ':h')
    if l:project_root == '/'
      let l:project_root = l:file_dir
      break
    endif
  endwhile

  return [l:project_root, fnamemodify(l:file_dir, ':s#' . l:project_root . '/##:r')]
endfunction

function! s:nearest_test(position, classname) abort
  let l:name = test#base#nearest_test(a:position, g:test#java#patterns)
  let l:test_separator = "#"
  let l:test = join(l:name['test'] , l:test_separator)
  if empty(l:test)
      return a:classname
  endif
  return a:classname . l:test_separator . l:test . '$'
endfunction

function! test#java#bazeltest#executable()
  return 'bazel test'
endfunction

function! test#java#bazeltest#build_args(args, color) abort
  return a:args
endfunction
