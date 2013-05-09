function! sonictemplate#lang#perl#guess()
  if expand('%:t') ==# 'Makefile.PL'
    return ['perl', 'make']
  endif
  if expand('%:t:e') ==# 'pl'
    return ['perl', 'script']
  endif
  if expand('%:t:e') ==# 'pm'
    return ['perl', 'package']
  endif
  return []
endfunction
