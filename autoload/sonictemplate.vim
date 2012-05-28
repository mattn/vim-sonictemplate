"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 28-May-2012.

let s:save_cpo = &cpo
set cpo&vim

let s:tmpldir = []
if exists('g:sonictemplate_vim_template_dir')
  if type(g:sonictemplate_vim_template_dir) == 3
    let s:tmpldir += map(g:sonictemplate_vim_template_dir, 'fnamemodify(expand(v:val), ":p")')
  else
    call add(s:tmpldir, fnamemodify(expand(g:sonictemplate_vim_template_dir), ":p"))
  endif
endif
call add(s:tmpldir, expand('<sfile>:p:h:h') . '/template/')

function! sonictemplate#select(mode) abort
  let name = input(':Template ', '', 'customlist,sonictemplate#complete')
  if name == ''
    return
  endif
  call sonictemplate#apply(name, a:mode)
endfunction

function! sonictemplate#complete(lead, cmdline, curpos) abort
  let ft = &ft
  let tmp = []
  for tmpldir in s:tmpldir
    let tmp += map(split(globpath(join([tmpldir, ft], '/'), (search('[^ \t]', 'wn') ? 'snip-' : 'base-') . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
  endfor
  if len(tmp) == 0
    let ft = tolower(synIDattr(synID(line("."), col("."), 1), "name"))
    if len(ft) > 0
      for tmpldir in s:tmpldir
        let tmp += map(split(globpath(join([tmpldir, ft], '/'), (search('[^ \t]', 'wn') ? 'snip-' : 'base-') . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
      endfor
    endif
  endif
  let candidate = []
  for c in tmp
    if index(candidate, c) == -1
      call add(candidate, c)
    endif
  endfor
  return candidate
endfunction

function! sonictemplate#apply(name, mode) abort
  let name = matchstr(a:name, '\S\+')
  let buffer_is_not_empty = search('[^ \t]', 'wn')
  let fs = []
  for tmpldir in s:tmpldir
    let ft = &ft
    let fsl = split(globpath(join([tmpldir, ft], '/'), (search('[^ \t]', 'wn') ? 'snip-' : 'base-') . name . '.*'), "\n")
    if len(fsl) == 0
      let ft = tolower(synIDattr(synID(line("."), col("."), 1), "name"))
      if len(ft) > 0
        let fsl = split(globpath(join([tmpldir, ft], '/'), (search('[^ \t]', 'wn') ? 'snip-' : 'base-') . name . '.*'), "\n")
      endif
    endif
    let fs += fsl
  endfor
  if len(fs) == 0
    echomsg 'Template '.name.' is not exists.'
    return
  endif
  let f = fs[0]
  if !filereadable(f)
    echomsg 'Template '.name.' is not exists.'
    return
  endif
  let c = join(readfile(f, "b"), "\n")
  let c = substitute(c, '{{_name_}}', expand('%:t:r:'), 'g')
  let tmp = c
  let mx = '{{_input_:\(.\{-}\)}}'
  let vars = []
  while 1
    let match = matchstr(tmp, mx)
    if len(match) == 0
      break
    endif
    let var = substitute(match, mx, '\1', 'ig')
    if index(vars, var) == -1
      call add(vars, var)
    endif
    let tmp = tmp[stridx(tmp, match) + len(match):]
  endwhile
  for var in vars
    let val = input(var . ":")
    let c = substitute(c, '\V{{_input_:'.var.'}}', '\=val', 'g')
  endfor
  sandbox let c = substitute(c, '{{_if_:\(.\{-}\);\(.\{-}\)\(;\(.\{-}\)\)\{-}}}', '\=eval(submatch(1))?submatch(2):submatch(4)', 'g')
  sandbox let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  if len(c) == 0
    return
  endif
  if !buffer_is_not_empty
    if &expandtab || &tabstop != &shiftwidth
      let c = substitute(c, "\t", repeat(' ', &shiftwidth), 'g')
    endif
    silent! %d _
    silent! put = c
    silent! normal! ggdd
  else
    if c[len(c)-1] == "\n"
      let c = c[:-2]
    endif
    let line = getline('.')
    let indent = matchstr(line, '^\(\s*\)')
    if line =~ '^\s*$' && line('.') != line('$')
      silent! normal dd
    endif
    let c = indent . substitute(c, "\n", "\n".indent, 'g')
    if len(indent) && (&expandtab || &tabstop != &shiftwidth || indent =~ '^ \+$')
      let c = substitute(c, "\t", repeat(' ', min([len(indent), &shiftwidth])), 'g')
    endif
    silent! put! = c
  endif
  if stridx(c, '{{_cursor_}}') != -1
    if a:mode == 'n'
      silent! call search('\zs{{_cursor_}}', 'w')
      silent! foldopen
      silent! exe "normal ".repeat("x", 12)
    else
      silent! call search('{{_cursor_}}\zs', 'w')
      silent! foldopen
      call feedkeys(repeat("\<bs>", 12))
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
