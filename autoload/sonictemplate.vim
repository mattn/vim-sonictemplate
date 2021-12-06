"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 21-Jan-2020.

let s:save_cpo = &cpo
set cpo&vim

let s:tmpldir = []
if exists('g:sonictemplate_vim_template_dir')
  if type(g:sonictemplate_vim_template_dir) == 3
    let s:tmpldir += map(g:sonictemplate_vim_template_dir, 'fnamemodify(expand(v:val), ":p")')
  else
    call add(s:tmpldir, fnamemodify(expand(g:sonictemplate_vim_template_dir), ':p'))
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

function! sonictemplate#get_filetype() abort
  let c = col('.')
  if c == col('$')
    let c -= 1
  endif
  let ft = tolower(synIDattr(synID(line('.'), c, 1), 'name'))
  if ft =~# '^css\w'
    let ft = 'css'
  elseif ft =~# '^html\w'
    let ft = 'html'
  elseif ft =~# '^javaScript'
    let ft = 'javascript'
  elseif ft =~# '^xml\w'
    let ft = 'xml'
  endif
  return ft
endfunction

function! s:get_candidate(fts, lead) abort
  let fts = a:fts
  let filter = ''
  if getcmdwintype() ==# ''
    let prefix = search('[^ \t]', 'wn') ? 'snip' : 'base'
  else
    let prefix = 'base'
    for line in getbufline(bufnr('#'), 1, '$')
      if match(line, '[^ \t]') != -1
        let prefix = 'snip'
        break
      endif
    endfor
  endif
  try
    let ft = s:get_filetype()
    let cxt = sonictemplate#lang#{ft !=# '' ? ft : '_'}#guess()
    if has_key(cxt, 'prefix')
      let prefix = cxt['prefix']
      call s:setopt('prefix', cxt['prefix'])
    endif
    if has_key(cxt, 'filter')
      let filter = cxt['filter']
    endif
    if has_key(cxt, 'filetype')
      let fts = [cxt['filetype']]
      call s:setopt('filetype', cxt['filetype'])
    else
      call s:setopt('prefix', '')
      call s:setopt('filetype', '')
    endif
  catch
  endtry
  let tmp = []
  if prefix ==# 'base'
    for tmpldir in s:tmpldir
      let tmp += map(split(globpath(join([tmpldir, ft], '/'), 'file-' . expand('%:t:r') . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]')
    endfor
    if s:get_raw_filetype() == ''
      for tmpldir in s:tmpldir
        let tmp += sort(map(split(globpath(join([tmpldir, '_'], '/'), 'file-' . expand('%:t:r') . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'))
      endfor
    endif
  endif
  for tmpldir in s:tmpldir
    for ft in fts
      let tmp += sort(map(split(globpath(join([tmpldir, ft], '/'), prefix . '-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'))
    endfor
  endfor
  for tmpldir in s:tmpldir
    let tmp += sort(map(split(globpath(join([tmpldir, '_'], '/'), prefix . '-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'))
  endfor
  let candidate = []
  for c in tmp
    if index(candidate, c) == -1
      call add(candidate, c)
    endif
  endfor
  if filter == ''
    let filter = s:getopt('filter')
  endif
  if filter != ''
    let [lhs, rhs] = [[], []]
    for c in candidate
      let ms = matchstr(c, filter)
      if ms != '' && matchstr(c, ms) == 0
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
  return s:get_candidate([s:get_raw_filetype(), s:get_filetype(), sonictemplate#get_filetype()], a:lead)
endfunction

function! sonictemplate#complete_intelligent(lead, cmdline, curpos) abort
  return s:get_candidate([sonictemplate#get_filetype(), s:get_raw_filetype(), s:get_filetype()], a:lead)
endfunction

function! s:setopt(k, v) abort
  if !exists('b:sonictemplate')
    let b:sonictemplate = {}
  endif
  let b:sonictemplate[a:k] = a:v
endfunction

function! s:getopt(k) abort
  if !exists('b:sonictemplate') || !has_key(b:sonictemplate, a:k)
    return ''
  endif
  return b:sonictemplate[a:k]
endfunction

let s:vars = {}

function! s:get_filetype() abort
  return matchstr(s:get_raw_filetype(), '^\([^.]\)\+')
endfunction

function! s:get_raw_filetype() abort
  return getcmdwintype() ==# '' ? &ft : getbufvar('#', '&ft')
endfunction

function! sonictemplate#getvar(name) abort
  let ft = s:get_filetype()
  let ft = ft != '' ? ft : '_'
  if !has_key(s:vars, ft)
    return ''
  endif
  return has_key(s:vars[ft], a:name) ? s:vars[ft][a:name] : ''
endfunction

function! s:dir() abort
  let l:name = expand('%:p:h:t:r')
  if empty(l:name)
    let l:name = fnamemodify(getcwd(), ':t')
  endif
  return substitute(l:name, '[^a-zA-Z0-9]', '_', 'g')
endfunction

function! s:name(default) abort
  let l:name = expand('%:t:r')
  if empty(l:name)
    let l:name = a:default
  endif
  return substitute(l:name, '[^a-zA-Z0-9]', '_', 'g')
endfunction

function! sonictemplate#apply(name, mode, ...) abort
  let name = matchstr(a:name, '\S\+')
  let buffer_is_not_empty = search('[^ \t]', 'wn')
  let fs = []
  let prefix = s:getopt('prefix')
  if prefix == ''
    let prefix = search('[^ \t]', 'wn') ? 'snip' : 'base'
  endif
  let ft = s:getopt('filetype')
  if ft == ''
    if get(a:000, 0, 0)
      let fts = [sonictemplate#get_filetype(), s:get_raw_filetype(), s:get_filetype(), '_']
    else
      let fts = [s:get_raw_filetype(), s:get_filetype(), sonictemplate#get_filetype(), '_']
    endif
  else
    let fts = [ft]
  endif
  if prefix ==# 'base'
    for tmpldir in s:tmpldir
      for ft in fts
        let fs += sort(split(globpath(join([tmpldir, ft], '/'), 'file-' . name . '.*'), "\n"))
      endfor
      for ft in fts
        let fs += sort(split(globpath(join([tmpldir, '_'], '/'), 'file-' . name . '.*'), "\n"))
      endfor
    endfor
  endif
  if len(fs) == 0
    for tmpldir in s:tmpldir
      for ft in fts
        if len(ft) > 0
          let fs += sort(split(globpath(join([tmpldir, ft], '/'), prefix . '-' . name . '.*'), "\n"))
        endif
      endfor
    endfor
  endif
  if len(fs) == 0
    echomsg 'Template '.name.' is not exists.'
    return
  endif
  let f = fs[0]
  if !filereadable(f)
    echomsg 'Template '.name.' is not exists.'
    return
  endif
  let ft = s:get_filetype()
  let ft = ft != '' ? ft : '_'
  let c = join(readfile(f), "\n")
  let c = substitute(c, '{{_dir_}}', s:dir(), 'g')
  let c = substitute(c, '{{_name_}}', s:name('Main'), 'g')
  let c = substitute(c, '{{_name_:\([^}]\+\)}}', '\=s:name(submatch(1))', 'g')
  let tmp = c
  let mx = '{{_input_:\(.\{-}\)}}'
  if !has_key(s:vars, ft)
    let s:vars[ft] = {}
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
  let gvars = has_key(g:, 'sonictemplate_vim_vars') && type(g:sonictemplate_vim_vars) == 4 ? g:sonictemplate_vim_vars : {}
  for var in vars
    if exists('V')
      unlet V
    endif
    if has_key(gvars, s:get_raw_filetype()) && type(gvars[s:get_raw_filetype()]) == 4 && has_key(gvars[s:get_raw_filetype()], var)
      let V = gvars[s:get_raw_filetype()][var]
      if type(V) == 1 | let val = V | else | let val = string(V) | endif
    elseif has_key(gvars, '_') && type(gvars['_']) == 4 && has_key(gvars['_'], var)
      let V = gvars['_'][var]
      if type(V) == 1 | let val = V | else | let val = string(V) | endif
    else
      let val = input(var . ': ')
    endif
    let c = substitute(c, '\V{{\(_input_\|_var_\):'.var.'}}', '\=val', 'g')
    let s:vars[ft][var] = val
  endfor
  let mx = '{{_define_:\([^:]\+\):\(.\{-}\)}}\s*'
  while 1
    let match = matchstr(c, mx)
    if len(match) == 0
      break
    endif
    let var = substitute(match, mx, '\1', 'ig')
    let val = eval(substitute(match, mx, '\2', 'ig'))
    let c = substitute(c, '{{_define_:' . var . ':\(.\{-}\)}}\s*', '', 'g')
    let c = substitute(c, '\V{{_var_:'.var.'}}', '\=val', 'g')
    let s:vars[ft][var] = val
  endwhile
  sandbox let c = substitute(c, '{{_if_:\(.\{-}\);\(.\{-}\)\(;\(.\{-}\)\)\{-}}}', '\=eval(submatch(1))?submatch(2):submatch(4)', 'g')
  sandbox let c = substitute(c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  silent! let c = substitute(c, '{{_lang_util_:\(.\{-}\)}}', '\=sonictemplate#lang#{ft}#util(submatch(1))', 'g')
  if len(c) == 0
    return
  endif
  let mx = '{{_filter_:\([a-zA-Z0-9_-]\+\)}}\s*'
  let bf = matchstr(c, mx)
  if len(bf) > 0
    call s:setopt('filter', substitute(bf, mx, '\1', ''))
    let c = substitute(c, mx, '', 'g')
  endif

  if !buffer_is_not_empty
    let c = substitute(c, '{{_inline_}}\s*', '', 'g')
    if &expandtab || (&shiftwidth && &tabstop != &shiftwidth)
      let c = substitute(c, "\t", repeat(' ', shiftwidth()), 'g')
    endif
    silent! %d _
    silent! put = c
    silent! normal! gg"_dd
  else
    if c[len(c)-1] ==# "\n"
      let c = c[:-2]
    endif
    if stridx(c, '{{_inline_}}') != -1
      let c = substitute(c, '{{_inline_}}', '', 'g')
      let c = join(split(c, "\n"), '')
      let oldindentexpr = &indentexpr
      let &indentexpr = ''
      noautocmd silent! exe "normal! a\<c-r>=c\<cr>"
      let &indentexpr = oldindentexpr
      return
    else
      let line = getline('.')
      let indent = matchstr(line, '^\(\s*\)')
      if line !~# '^\s*$'
        let lhs = col('.') > 1 ? line[:col('.')-2] : ''
        let rhs = line[len(lhs):]
        let lhs = lhs[len(indent):]
        let c = lhs . c . rhs
      endif
      let c = indent . substitute(substitute(c, "\n", "\n".indent, 'g'), "\n".indent."\n", "\n\n", 'g')
      if len(indent) && (&expandtab || (&shiftwidth && &tabstop != &shiftwidth) || indent =~ '^ \+$')
        let c = substitute(c, "\t", repeat(' ', min([len(indent), shiftwidth()])), 'g')
      elseif &expandtab || (&shiftwidth && &tabstop != &shiftwidth)
        let c = substitute(c, "\t", repeat(' ', shiftwidth()), 'g')
      endif
      if line('.') < line('$')
        silent! normal! "_dd
      endif
      silent! put! =c
    endif
  endif
  if stridx(c, '{{_cursor_}}') != -1
    silent! call search('\zs{{_cursor_}}', 'w')
    silent! foldopen
    let curpos = getpos('.')
    silent! normal! "_da}
    call setpos('.', curpos)
  endif
endfunction

let s:pat = {}

function! sonictemplate#postfix() abort
  call sonictemplate#load_postfix()
  if !has_key(s:pat, s:get_raw_filetype())
    return ''
  endif
  let line = getline('.')[:col('.')]
  let rest = getline('.')[col('.')-1:]
  let line = escape(line, '\&')
  for k in keys(s:pat[s:get_raw_filetype()])
    let pos = matchstrpos(line, k)
    let m = matchstr(line, k)
    if len(m) > 0
      let ml = matchlist(line, k)
      let line = line[pos[1]-1]
      let c = join(s:pat[s:get_raw_filetype()][k], "\n")
      for i in range(1, 9)
        let c = substitute(c, '{{$' . i . '}}', ml[i], 'g')
      endfor
      let indent = matchstr(line, '^\(\s*\)')
      let c .= rest
      if c =~# "\n"
        let c = indent . substitute(substitute(c, "\n", "\n".indent, 'g'), "\n".indent."\n", "\n\n", 'g')
        if len(indent) && (&expandtab || (&shiftwidth && &tabstop != &shiftwidth) || indent =~ '^ \+$')
          let c = substitute(c, "\t", repeat(' ', min([len(indent), shiftwidth()])), 'g')
        elseif &expandtab || (&shiftwidth && &tabstop != &shiftwidth)
          let c = substitute(c, "\t", repeat(' ', shiftwidth()), 'g')
        endif
        call setline('.', line)
        if line('.') < line('$')
          silent! normal! dd
        endif
        silent! put! =c
      else
        call setline('.', line)
        let oldindentexpr = &indentexpr
        let &indentexpr = ''
        noautocmd silent! exe "normal! a\<c-r>=c\<cr>"
        let &indentexpr = oldindentexpr
      endif
      if stridx(c, '{{_cursor_}}') != -1
        silent! call search('\zs{{_cursor_}}', 'w')
        silent! foldopen
        let curpos = getpos('.')
        silent! normal! "_da}
        call setpos('.', curpos)
      endif
      break
    endif
  endfor
  return ''
endfunction

function! sonictemplate#load_postfix() abort
  let ft = s:get_raw_filetype()
  if has_key(s:pat, ft)
    return
  endif
  let tmp = []
  for tmpldir in reverse(s:tmpldir)
    let tmp += split(globpath(join([tmpldir, ft], '/'), 'pattern.stpl'), "\n")
  endfor
  if len(tmp) == 0
    return
  endif
  let s:pat[ft] = {}
  for f in tmp
    let k = ''
    let l = []
    for line in add(readfile(f), '__END__')
      if line == ''
        continue
      elseif line !~# '^\t'
        if k != ''
          let s:pat[ft][k] = l
        endif
        let k = line
        let l = []
      else
        call add(l, line[1:])
      endif
    endfor
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
