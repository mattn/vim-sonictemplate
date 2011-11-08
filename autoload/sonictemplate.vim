"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 08-Nov-2011.

let s:save_cpo = &cpo
set cpo&vim

if exists('g:sonictemplate_vim_template_dir')
  let s:tmpldir = g:sonictemplate_vim_template_dir
else
  let s:tmpldir = expand('<sfile>:p:h:h') . '/template/'
endif

function! sonictemplate#select(mode) abort
  let name = input(':Template ', '', 'customlist,sonictemplate#complete')
  if name == ''
    return
  endif
  call sonictemplate#apply(name, a:mode)
endfunction

function! sonictemplate#complete(lead, cmdline, curpos) abort
  if search('[^ \t]', 'wn')
    return map(split(globpath(join([s:tmpldir, &ft], '/'), 'snip-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
  else
    return map(split(globpath(join([s:tmpldir, &ft], '/'), 'base-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
  endif
endfunction

function! sonictemplate#apply(name, mode) abort
  let buffer_is_not_empty = search('[^ \t]', 'wn')
  if search('[^ \t]', 'wn')
    let fs = split(globpath(join([s:tmpldir, &ft], '/'), 'snip-' . a:name . '.*'), "\n")
  else
    let fs = split(globpath(join([s:tmpldir, &ft], '/'), 'base-' . a:name . '.*'), "\n")
  endif
  if len(fs) == 0
    echomsg 'Template '.a:name.' is not exists.'
    return
  endif
  let f = fs[0]
  if !filereadable(f)
    echomsg 'Template '.a:name.' is not exists.'
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
    if len(indent) && (&expandtab || indent =~ '^ \+$')
      let c = substitute(c, "\t", repeat(' ', min([len(indent), &tabstop])), 'g')
    endif
    silent! put! = c
  endif
  if stridx(c, '{{_cursor_}}') != -1
    if a:mode == 'n'
      silent! call search('\zs{{_cursor_}}', 'w')
      silent! exe "normal ".repeat("x", 12)
    else
      silent! call search('{{_cursor_}}\zs', 'w')
      call feedkeys(repeat("\<bs>", 12))
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
