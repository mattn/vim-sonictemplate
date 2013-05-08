function! sonictemplate#lang#perl#guess()
  if expand('%:t') ==# 'Makefile.PL'
    return 'make'
  endif
  if expand('%:t:e') ==# 'pl'
    return 'script'
  endif
  if expand('%:t:e') ==# 'pm'
    return 'package'
  endif
  return ''
endfunction
