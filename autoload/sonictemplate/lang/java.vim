function! sonictemplate#lang#java#util(name) abort
  if a:name ==# 'package'
    let l:fn = expand('%:p:h')
    let l:fn = l:fn[len(s:project_root())+1 :]
    let l:fn = substitute(l:fn, '[\\/]', '.', 'g')
    let l:fn = substitute(l:fn, '^\(src\.main\.java\.\|src\.\)', '', '')
    if l:fn !=# ''
      return 'package ' . l:fn . ';'
    endif
  endif
  return ''
endfunction

function! s:project_root() abort
  let l:pwd = getcwd()
  let l:elems = split(substitute(l:pwd, '\\', '/', 'g'), '/', 1)
  let l:is_unc = len(l:elems) > 2 && (has('win32') || has('win64')) && l:elems[0:1] ==# ['', '']
  while len(l:elems)
    let l:path = join(l:elems, '/')
    for l:vcs in ['.rootdir', '.git', '.hg', '.svn', 'bzr', '_darcs', 'build.xml', '.project', 'build.gradle', 'pom.xml']
      if filereadable(l:path . '/' . l:vcs) || isdirectory(l:path . '/' . l:vcs)
        return l:path
      endif
    endfor
    let l:elems = l:elems[:-2]
    if l:is_unc && len(l:elems) <= 3
      break
    endif
  endwhile
  return l:pwd
endfunction
