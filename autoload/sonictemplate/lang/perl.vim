function! sonictemplate#lang#perl#guess() abort
  if expand('%:t') ==# 'Makefile.PL'
    return {
    \ 'filter': 'make',
    \}
  endif
  if expand('%:t:e') ==# 'pl'
    return {
    \ 'filter': 'script',
    \}
  endif
  if expand('%:t:e') ==# 'pm'
    return {
    \ 'filter': 'package',
    \}
  endif
  return []
endfunction
