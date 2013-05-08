function! sonictemplate#lang#perl#guess()
  if expand('%:t') == 'Makefile.PL'
    return 'make'
  endif
  return ''
endfunction
