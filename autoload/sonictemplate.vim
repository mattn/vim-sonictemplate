"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 08-May-2013.

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
    return ''
  endif
  call sonictemplate#apply(name, a:mode, 0)
  return ''
endfunction

function! sonictemplate#select_intelligent(mode) abort
  let name = input(':Template ', '', 'customlist,sonictemplate#complete_intelligent')
  if name == ''
    return ''
  endif
  call sonictemplate#apply(name, a:mode, 1)
  return ''
endfunction

function! sonictemplate#get_filetype()
  let c = col('.')
  if c == col('$')
    let c -= 1
  endif
  let ft = tolower(synIDattr(synID(line("."), c, 1), "name"))
  if ft =~ '^css\w'
    let ft = 'css'
  elseif ft =~ '^html\w'
    let ft = 'html'
  elseif ft =~ '^javaScript'
    let ft = 'javascript'
  elseif ft =~ '^xml\w'
    let ft = 'xml'
  endif
  return ft
endfunction

function! s:get_candidate(fts, lead)
  let tmp = []
  let prefix = search('[^ \t]', 'wn') ? 'snip-' : 'base-'
  for tmpldir in s:tmpldir
    for ft in a:fts
      let tmp += map(split(globpath(join([tmpldir, ft], '/'), prefix . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
      if len(tmp) > 0
        break
      endif
    endfor
  endfor
  for tmpldir in s:tmpldir
    let tmp += map(split(globpath(join([tmpldir, '_'], '/'), prefix . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
  endfor
  let candidate = []
  for c in tmp
    if index(candidate, c) == -1
      call add(candidate, c)
    endif
  endfor
  let filter = s:getopt('filter')
  if filter == ''
    try
      let filter = sonictemplate#lang#{&ft!=""?&ft:"_"}#guess()
    catch
    endtry
  endif
  if filter != ''
    let [lhs, rhs] = [[], []]
    for c in candidate
      if stridx(c, filter) == 0
        call add(lhs, c)
      else
        call add(rhs, c)
      endif
    endfor
    let candidate = lhs + rhs
  endif
  return candidate
endfunction
 
function! sonictemplate#complete(lead, cmdline, curpos) abort
  return s:get_candidate([&ft, sonictemplate#get_filetype()], a:lead)
endfunction

function! sonictemplate#complete_intelligent(lead, cmdline, curpos) abort
  return s:get_candidate([sonictemplate#get_filetype(), &ft], a:lead)
endfunction

function! s:setopt(k, v)
  if !exists('b:sonictemplate')
    let b:sonictemplate = {}
  endif
  let b:sonictemplate[a:k] = a:v
endfunction

function! s:getopt(k)
  if !exists('b:sonictemplate') || !has_key(b:sonictemplate, a:k)
    return ''
  endif
  return b:sonictemplate[a:k]
endfunction

let s:vars = {}

function! sonictemplate#getvar(name)
  return has_key(s:var, a:name) ? s:var[a:name] : ''
endfunction

function! sonictemplate#apply(name, mode, ...) abort
  let name = matchstr(a:name, '\S\+')
  let buffer_is_not_empty = search('[^ \t]', 'wn')
  let fs = []
  if get(a:000, 0, 0)
    let fts = [sonictemplate#get_filetype(), &ft, '_']
  else
    let fts = [&ft, sonictemplate#get_filetype(), '_']
  endif
  let prefix = search('[^ \t]', 'wn') ? 'snip-' : 'base-'
  for tmpldir in s:tmpldir
    for ft in fts
      if len(ft) > 0
        let fs += split(globpath(join([tmpldir, ft], '/'), prefix . name . '.*'), "\n")
      endif
    endfor
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
  let c = join(readfile(f), "\n")
  let c = substitute(c, '{{_name_}}', expand('%:t:r:'), 'g')
  let tmp = c
  let mx = '{{_input_:\(.\{-}\)}}'
  if prefix == 'base-'
    let s:var = {}
  endif
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
    let c = substitute(c, '\V{{\(_input_\|_var_\):'.var.'}}', '\=val', 'g')
    let s:var[var] = val
  endfor
  let mx = '{{_define_:\([^:]\+\):\(.\{-}\)}}\s*'
  while 1
    let match = matchstr(c, mx)
    if len(match) == 0
      break
    endif
    let var = substitute(match, mx, '\1', 'ig')
    let val = eval(substitute(match, mx, '\2', 'ig'))
    let c = substitute(c, mx, '', 'g')
    let c = substitute(c, '\V{{_var_:'.var.'}}', '\=val', 'g')
    let s:var[var] = val
  endwhile
  sandbox let c = substitute(c, '{{_if_:\(.\{-}\);\(.\{-}\)\(;\(.\{-}\)\)\{-}}}', '\=eval(submatch(1))?submatch(2):submatch(4)', 'g')
  sandbox let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  if len(c) == 0
    return
  endif
  let mx = '{{_filter_:\(\w\+\)}}\s*'
  let bf = matchstr(c, mx)
  if len(bf) > 0
    call s:setopt('filter', substitute(bf, mx, '\1', ''))
    let c = substitute(c, mx, '', 'g')
  endif

  if !buffer_is_not_empty
    let c = substitute(c, '{{_inline_}}\s*', '', 'g')
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
    if stridx(c, '{{_inline_}}') != -1
      let c = substitute(c, '{{_inline_}}', '', 'g')
      let c = join(split(c, "\n"), "")
      silent! exe "normal! a\<c-r>=c\<cr>"
      return
    else
      let line = getline('.')
      let indent = matchstr(line, '^\(\s*\)')
      if line !~ '^\s*$'
        let lhs = col('.') > 1 ? line[:col('.')-2] : ""
        let rhs = line[len(lhs):]
        let lhs = lhs[len(indent):]
        let c = lhs . c . rhs
      endif
      silent! normal dd
      let c = indent . substitute(substitute(c, "\n", "\n".indent, 'g'), "\n".indent."\n", "\n\n", 'g')
      if len(indent) && (&expandtab || &tabstop != &shiftwidth || indent =~ '^ \+$')
        let c = substitute(c, "\t", repeat(' ', min([len(indent), &shiftwidth])), 'g')
      elseif &expandtab || &tabstop != &shiftwidth
        let c = substitute(c, "\t", repeat(' ', &shiftwidth), 'g')
      endif
      silent! put! =c
    endif
  endif
  if stridx(c, '{{_cursor_}}') != -1
    if a:mode == 'n'
      silent! call search('\zs{{_cursor_}}', 'w')
      silent! foldopen
      silent! normal! 12"_x
    else
      silent! call search('{{_cursor_}}\zs', 'w')
      silent! foldopen
      silent! call feedkeys(repeat("\<bs>", 12))
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
