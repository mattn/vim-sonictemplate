function! sonictemplate#lang#java#util(name)
  if a:name == 'package'
    return 'package foo.bar;'
  endif
  return ''
endfunction
