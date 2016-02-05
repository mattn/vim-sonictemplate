function! sonictemplate#lang#java#util(name) abort
  if a:name == 'package'
    let fn = expand('%:p:h')
    let fn = fn[len(s:project_root())+1:]
    let fn = substitute(fn, '[\\/]', '.', 'g')
    let fn = substitute(fn, '^\(src\.main\.java\.\|src\.\)', '', '')
    if fn != ""
      return 'package ' . fn . ';'
    endif
  endif
  return ''
endfunction

function! s:project_root() abort
  let pwd = getcwd()
  let elems = split(substitute(pwd, '\\', '/', 'g'), '/', 1)
  let is_unc = len(elems) > 2 && (has('win32') || has('win64')) && elems[0:1] == ['', '']
  while len(elems)
    let path = join(elems, '/')
    for vcs in ['.rootdir', '.git', '.hg', '.svn', 'bzr', '_darcs', 'build.xml', '.project', 'build.gradle', 'pom.xml']
      if filereadable(path.'/'.vcs) || isdirectory(path.'/'.vcs)
        return path
      endif
    endfor
    let elems = elems[:-2]
    if is_unc && len(elems) <= 3
      break
    endif
  endwhile
  return pwd
endfunction
