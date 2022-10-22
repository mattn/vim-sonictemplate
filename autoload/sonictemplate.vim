"=============================================================================
" sonictemplate.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 21-Jan-2020.

let s:save_cpo = &cpo
set cpo&vim

let s:tmpldir = []
if exists('g:sonictemplate_vim_template_dir')
  if type(g:sonictemplate_vim_template_dir) ==# 3
    let s:tmpldir += map(g:sonictemplate_vim_template_dir, 'fnamemodify(expand(v:val), ":p")')
  else
    call add(s:tmpldir, fnamemodify(expand(g:sonictemplate_vim_template_dir), ':p'))
  endif
endif
call add(s:tmpldir, expand('<sfile>:p:h:h') . '/template/')

function! sonictemplate#select(mode) abort
  let l:fn = a:mode =~# '[vV]' ? 'customlist,sonictemplate#complete_wrap' : 'customlist,sonictemplate#complete'
  let l:name = input(':Template ', '', fn)
  if l:name ==# ''
    return ''
  endif
  call sonictemplate#apply(l:name, a:mode, 0)
  return ''
endfunction

function! sonictemplate#select_intelligent(mode) abort
  let l:fn = a:mode =~# '[vV]' ? 'customlist,sonictemplate#complete_intelligent_wrap' : 'customlist,sonictemplate#complete_intelligent'
  let l:name = input(':Template ', '', l:fn)
  if l:name ==# ''
    return ''
  endif
  call sonictemplate#apply(l:name, a:mode, 1)
  return ''
endfunction

function! sonictemplate#get_filetype() abort
  let l:c = col('.')
  if l:c ==# col('$')
    let l:c -= 1
  endif
  let l:ft = tolower(synIDattr(synID(line('.'), l:c, 1), 'name'))
  if l:ft =~# '^css\w'
    let l:ft = 'css'
  elseif l:ft =~# '^html\w'
    let l:ft = 'html'
  elseif l:ft =~# '^javaScript'
    let l:ft = 'javascript'
  elseif l:ft =~# '^xml\w'
    let l:ft = 'xml'
  endif
  return l:ft
endfunction

function! s:load_meta(path, type, def) abort
  let l:path = a:path . '/meta.json'
  let l:meta = filereadable(l:path) ? json_decode(join(readfile(l:path), "\n")) : {}
  return has_key(l:meta, a:type) ? l:meta[a:type] : a:def
endfunction

function! s:sort(prefer, lhs, rhs) abort
  if !empty(a:prefer)
    let [l:lhso, l:rhso] = [9999, 9999]
    for l:i in range(len(a:prefer))
      if l:lhso == 9999 && a:lhs =~ a:prefer[l:i]
        let l:lhso = l:i
      endif
      if l:rhso == 9999 && a:rhs =~ a:prefer[l:i]
        let l:rhso = l:i
      endif
    endfor
    if l:lhso != l:rhso
      return l:lhso ># l:rhso ? 1 : -1
    endif
  endif
  return a:lhs ==# a:rhs ? 0 : a:lhs ># a:rhs ? 1 : -1
endfunction

function! s:get_candidate(fts, lead, mode) abort
  let l:fts = a:fts
  let l:filter = ''
  if a:mode =~# '[vV]'
    let l:prefix = 'wrap'
  else
    if getcmdwintype() ==# ''
      let l:prefix = search('[^ \t]', 'wn') ? 'snip' : 'base'
    else
      let l:prefix = 'base'
      for l:line in getbufline(bufnr('#'), 1, '$')
        if match(l:line, '[^ \t]') != -1
          let l:prefix = 'snip'
          break
        endif
      endfor
    endif
  endif
  try
    let l:ft = s:get_filetype()
    let l:cxt = sonictemplate#lang#{l:ft !=# '' ? l:ft : '_'}#guess()
    if has_key(l:cxt, 'prefix')
      let l:prefix = l:cxt['prefix']
      call s:setopt('prefix', l:cxt['prefix'])
    endif
    if has_key(l:cxt, 'filter')
      let l:filter = l:cxt['filter']
    endif
    if has_key(l:cxt, 'filetype')
      let l:fts = [l:cxt['filetype']]
      call s:setopt('filetype', l:cxt['filetype'])
    else
      call s:setopt('prefix', '')
      call s:setopt('filetype', '')
    endif
  catch
  endtry
  let l:tmp = []
  if l:prefix ==# 'base'
    for l:tmpldir in s:tmpldir
      let l:path = join([l:tmpldir, l:ft], '/')
      let l:prefer = s:load_meta(l:path, 'prefer-file', [])
      let l:tmp += sort(map(split(globpath(join([l:tmpldir, l:ft], '/'), 'file-' . expand('%:t:r') . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'), function('s:sort', [l:prefer]))
    endfor
    let l:ft = s:get_raw_filetype()
    if l:ft ==# '' || l:ft ==# 'text'
      for l:tmpldir in s:tmpldir
        let l:path = join([tmpldir, '_'], '/')
        let l:prefer = s:load_meta(l:path, 'prefer-file', [])
        let l:tmp += sort(map(split(globpath(l:path, 'file-' . expand('%:t:r') . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'), function('s:sort', [l:prefer]))
      endfor
    endif
  endif
  for l:tmpldir in s:tmpldir
    for l:ft in l:fts
      let l:path = join([l:tmpldir, l:ft], '/')
      let l:prefer = s:load_meta(l:path, 'prefer-' . l:prefix, [])
      let l:tmp += sort(map(split(globpath(l:path, l:prefix . '-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'), function('s:sort', [l:prefer]))
    endfor
  endfor
  for l:tmpldir in s:tmpldir
    let l:path = join([l:tmpldir, '_'], '/')
    let l:prefer = s:load_meta(l:path, 'prefer-' . l:prefix, [])
    let l:tmp += sort(map(split(globpath(l:path, l:prefix . '-' . a:lead . '*.*'), "\n"), 'fnamemodify(v:val, ":t:r")[5:]'), function('s:sort', [l:prefer]))
  endfor
  let l:candidate = []
  for l:c in l:tmp
    if index(l:candidate, l:c) ==# -1
      call add(l:candidate, l:c)
    endif
  endfor
  if l:filter ==# ''
    let l:filter = s:getopt('filter')
  endif
  if l:filter !=# ''
    let [l:lhs, l:rhs] = [[], []]
    for l:c in l:candidate
      let l:ms = matchstr(l:c, l:filter)
      if l:ms !=# '' && matchstr(l:c, l:ms) ==# 0
        call add(l:lhs, l:c)
      else
        call add(l:rhs, l:c)
      endif
    endfor
    let l:candidate = l:lhs + l:rhs
  endif
  return l:candidate
endfunction

function! sonictemplate#complete_wrap(lead, cmdline, curpos) abort
  return s:get_candidate([s:get_raw_filetype(), s:get_filetype(), sonictemplate#get_filetype()], a:lead, 'v')
endfunction

function! sonictemplate#complete(lead, cmdline, curpos) abort
  return s:get_candidate([s:get_raw_filetype(), s:get_filetype(), sonictemplate#get_filetype()], a:lead, '')
endfunction

function! sonictemplate#complete_intelligent_wrap(lead, cmdline, curpos) abort
  return s:get_candidate([sonictemplate#get_filetype(), s:get_raw_filetype(), s:get_filetype()], a:lead, 'v')
endfunction

function! sonictemplate#complete_intelligent(lead, cmdline, curpos) abort
  return s:get_candidate([sonictemplate#get_filetype(), s:get_raw_filetype(), s:get_filetype()], a:lead, '')
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
  let l:ft = s:get_filetype()
  let l:ft = l:ft !=# '' ? l:ft : '_'
  if !has_key(s:vars, l:ft)
    return ''
  endif
  return has_key(s:vars[l:ft], a:name) ? s:vars[l:ft][a:name] : ''
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
  let l:name = matchstr(a:name, '\S\+')
  let l:buffer_is_not_empty = search('[^ \t]', 'wn')
  let l:fs = []
  if a:mode =~# '[vV]'
    let l:prefix = 'wrap'
  else
    let l:prefix = s:getopt('prefix')
    if l:prefix ==# ''
      let l:prefix = search('[^ \t]', 'wn') ? 'snip' : 'base'
    endif
  endif
  let l:ft = s:getopt('filetype')
  if l:ft ==# ''
    if get(a:000, 0, 0)
      let l:fts = [sonictemplate#get_filetype(), s:get_raw_filetype(), s:get_filetype(), '_']
    else
      let l:fts = [s:get_raw_filetype(), s:get_filetype(), sonictemplate#get_filetype(), '_']
    endif
  else
    let l:fts = [l:ft]
  endif
  if l:prefix ==# 'base'
    for l:tmpldir in s:tmpldir
      for l:ft in l:fts
        let l:path = join([l:tmpldir, l:ft], '/')
        let l:prefer = s:load_meta(l:path, 'prefer-file', [])
        let l:fs += sort(split(globpath(l:path, 'file-' . l:name . '.*'), "\n"), function('s:sort', [l:prefer]))
      endfor
      let l:path = join([l:tmpldir, '_'], '/')
      let l:prefer = s:load_meta(l:path, 'prefer-file', [])
      let l:fs += sort(split(globpath(l:path, 'file-' . l:name . '.*'), "\n"), function('s:sort', [l:prefer]))
    endfor
  endif
  if len(l:fs) ==# 0
    for l:tmpldir in s:tmpldir
      for l:ft in l:fts
        if len(l:ft) > 0
          let l:path = join([l:tmpldir, l:ft], '/')
          let l:prefer = s:load_meta(l:path, 'prefer-' . l:prefix, [])
          let l:fs += sort(split(globpath(l:path, l:prefix . '-' . l:name . '.*'), "\n"), function('s:sort', [l:prefer]))
        endif
      endfor
    endfor
  endif
  if len(l:fs) ==# 0
    echomsg 'Template ' . l:name . ' is not exists.'
    return
  endif
  let l:f = l:fs[0]
  if !filereadable(l:f)
    echomsg 'Template ' . l:name . ' is not exists.'
    return
  endif

  let l:wrap = ''
  if a:mode =~# '[vV]'
    let l:save_regcont = @"
    let l:save_regtype = getregtype('"')
    silent! normal! gvc
    let l:wrap = @"
    call setreg('"', l:save_regcont, l:save_regtype)
  endif

  let l:ft = s:get_filetype()
  let l:ft = l:ft !=# '' ? l:ft : '_'
  let l:c = join(readfile(l:f), "\n")
  let l:c = substitute(l:c, '{{_dir_}}', s:dir(), 'g')
  let l:c = substitute(l:c, '{{_name_}}', s:name('Main'), 'g')
  let l:c = substitute(l:c, '{{_name_:\([^}]\+\)}}', '\=s:name(submatch(1))', 'g')
  let l:c = substitute(l:c, '{{_wrap_}}', l:wrap, 'g')
  let l:tmp = l:c
  let l:mx = '{{_input_:\(.\{-}\)}}'
  if !has_key(s:vars, l:ft)
    let s:vars[l:ft] = {}
  endif
  let l:vars = []
  while 1
    let l:match = matchstr(l:tmp, l:mx)
    if len(l:match) ==# 0
      break
    endif
    let l:var = substitute(l:match, l:mx, '\1', 'ig')
    if index(l:vars, l:var) ==# -1
      call add(l:vars, l:var)
    endif
    let l:tmp = l:tmp[stridx(l:tmp, l:match) + len(l:match):]
  endwhile
  let l:gvars = has_key(g:, 'sonictemplate_vim_vars') && type(g:sonictemplate_vim_vars) ==# 4 ? g:sonictemplate_vim_vars : {}
  for l:var in l:vars
    if exists('l:V')
      unlet l:V
    endif
    let l:tok = split(l:var, '^[^:]\+\zs:', 1)
    let [l:name, l:defval] = len(l:tok) ==# 2 ? [l:tok[0], l:tok[1]] : [l:tok[0], '']
    if has_key(l:gvars, s:get_raw_filetype()) && type(l:gvars[s:get_raw_filetype()]) ==# 4 && has_key(l:gvars[s:get_raw_filetype()], l:name)
      let l:V = l:gvars[s:get_raw_filetype()][l:name]
      if type(l:V) ==# 1 | let l:val = l:V | else | let l:val = string(l:V) | endif
    elseif has_key(l:gvars, '_') && type(l:gvars['_']) ==# 4 && has_key(l:gvars['_'], l:name)
      let l:V = l:gvars['_'][l:name]
      if type(l:V) ==# 1 | let l:val = l:V | else | let l:val = string(l:V) | endif
    else
      let l:val = input(l:name . ': ', l:defval)
    endif
    let l:c = substitute(l:c, '\V{{\(_input_\|_var_\):' . l:name . '\(:\[^}]\+\)\{-}}}', '\=l:val', 'g')
    let s:vars[l:ft][l:name] = l:val
  endfor
  let l:mx = '{{_define_:\([^:]\+\):\(.\{-}\)}}\s*'
  while 1
    let l:match = matchstr(l:c, l:mx)
    if len(l:match) ==# 0
      break
    endif
    let l:var = substitute(l:match, l:mx, '\1', 'ig')
    let l:val = eval(substitute(l:match, l:mx, '\2', 'ig'))
    let l:c = substitute(l:c, '{{_define_:' . l:var . ':\(.\{-}\)}}\s*', '', 'g')
    let l:c = substitute(l:c, '\V{{_var_:' . l:var . '}}', '\=l:val', 'g')
    let s:vars[l:ft][l:var] = l:val
  endwhile
  sandbox let l:c = substitute(l:c, '{{_if_:\(.\{-}\);\(.\{-}\)\(;\(.\{-}\)\)\{-}}}', '\=eval(submatch(1))?submatch(2):submatch(4)', 'g')
  sandbox let l:c = substitute(l:c, '{{_expr_:\(.\{-}\)}}', '\=eval(submatch(1))', 'g')
  silent! let l:c = substitute(l:c, '{{_lang_util_:\(.\{-}\)}}', '\=sonictemplate#lang#{l:ft}#util(submatch(1))', 'g')
  if len(l:c) == 0
    return
  endif
  let l:mx = '{{_filter_:\([a-zA-Z0-9_-]\+\)}}\s*'
  let l:bf = matchstr(l:c, l:mx)
  if len(l:bf) ># 0
    call s:setopt('filter', substitute(l:bf, l:mx, '\1', ''))
    let l:c = substitute(l:c, l:mx, '', 'g')
  endif

  if !l:buffer_is_not_empty
    let l:c = substitute(l:c, '{{_inline_}}\s*', '', 'g')
    if &expandtab || (&shiftwidth && &tabstop != &shiftwidth)
      let l:c = substitute(l:c, "\t", repeat(' ', shiftwidth()), 'g')
    endif
    silent! %d _
    silent! put = l:c
    silent! normal! gg"_dd
  else
    if l:c[len(l:c)-1] ==# "\n"
      let l:c = l:c[:-2]
    endif
    if stridx(l:c, '{{_inline_}}') != -1
      let l:c = substitute(l:c, '{{_inline_}}', '', 'g')
      let l:c = join(split(l:c, "\n"), '')
      let l:oldindentexpr = &indentexpr
      let &indentexpr = ''
      noautocmd silent! exe "normal! a\<c-r>=c\<cr>"
      let &indentexpr = l:oldindentexpr
      return
    else
      let l:line = getline('.')
      let l:indent = matchstr(l:line, '^\(\s*\)')
      if l:line !~# '^\s*$'
        let l:lhs = col('.') > 1 ? l:line[:col('.')-2] : ''
        let l:rhs = l:line[len(l:lhs):]
        let l:lhs = l:lhs[len(l:indent):]
        let l:c = l:lhs . l:c . l:rhs
      endif
      let l:c = l:indent . substitute(substitute(l:c, "\n", "\n" . l:indent, 'g'), "\n" . l:indent . "\n", "\n\n", 'g')
      if len(l:indent) && (&expandtab || (&shiftwidth && &tabstop !=# &shiftwidth) || l:indent =~# '^ \+$')
        let l:c = substitute(l:c, "\t", repeat(' ', min([len(l:indent), shiftwidth()])), 'g')
      elseif &expandtab || (&shiftwidth && &tabstop !=# &shiftwidth)
        let l:c = substitute(l:c, "\t", repeat(' ', shiftwidth()), 'g')
      endif
      if line('.') <# line('$')
        silent! normal! "_dd
      endif
      silent! put! =l:c
    endif
  endif
  if stridx(l:c, '{{_cursor_}}') !=# -1
    silent! call search('\zs{{_cursor_}}', 'w')
    silent! foldopen
    let l:curpos = getpos('.')
    silent! normal! "_da}
    call setpos('.', l:curpos)
  endif
endfunction

let s:pat = {}

function! sonictemplate#postfix() abort
  call sonictemplate#load_postfix()
  if !has_key(s:pat, s:get_raw_filetype())
    return ''
  endif
  let l:line = getline('.')[:col('.')]
  let l:rest = getline('.')[col('.')-1:]
  let l:line = escape(l:line, '\&')
  for l:k in keys(s:pat[s:get_raw_filetype()])
    let l:pos = matchstrpos(l:line, l:k)
    let l:m = matchstr(l:line, l:k)
    if len(l:m) ># 0
      let l:ml = matchlist(l:line, l:k)
      let l:line = strpart(l:line, 0, l:pos[1])
      let l:c = join(s:pat[s:get_raw_filetype()][l:k], "\n")
      for l:i in range(1, 9)
        let l:c = substitute(l:c, '{{$' . l:i . '}}', l:ml[l:i], 'g')
      endfor
      let l:indent = matchstr(l:line, '^\(\s*\)')
      let l:c .= l:rest
      if l:c =~# "\n"
        let l:c = l:indent . substitute(substitute(l:c, "\n", "\n" . l:indent, 'g'), "\n" . l:indent . "\n", "\n\n", 'g')
        if len(l:indent) && (&expandtab || (&shiftwidth && &tabstop !=# &shiftwidth) || l:indent =~# '^ \+$')
          let l:c = substitute(l:c, "\t", repeat(' ', min([len(l:indent), shiftwidth()])), 'g')
        elseif &expandtab || (&shiftwidth && &tabstop !=# &shiftwidth)
          let l:c = substitute(l:c, "\t", repeat(' ', shiftwidth()), 'g')
        endif
        call setline('.', l:line)
        if line('.') <# line('$')
          silent! normal! dd
        endif
        silent! put! =l:c
      else
        call setline('.', l:line)
        let l:oldindentexpr = &indentexpr
        let &indentexpr = ''
        noautocmd silent! exe "normal! a\<c-r>=c\<cr>"
        let &indentexpr = l:oldindentexpr
      endif
      if stridx(l:c, '{{_cursor_}}') !=# -1
        silent! call search('\zs{{_cursor_}}', 'w')
        silent! foldopen
        let l:curpos = getpos('.')
        silent! normal! "_da}
        call setpos('.', l:curpos)
      endif
      break
    endif
  endfor
  return ''
endfunction

function! sonictemplate#load_postfix() abort
  let l:ft = s:get_raw_filetype()
  if has_key(s:pat, l:ft)
    return
  endif
  let l:tmp = []
  for l:tmpldir in reverse(s:tmpldir)
    let l:tmp += split(globpath(join([l:tmpldir, l:ft], '/'), 'pattern.stpl'), "\n")
  endfor
  if len(l:tmp) ==# 0
    return
  endif
  let s:pat[l:ft] = {}
  for l:f in l:tmp
    let l:k = ''
    let l:l = []
    for l:line in add(readfile(l:f), '__END__')
      if l:line ==# ''
        continue
      elseif l:line !~# '^\t'
        if l:k !=# ''
          let s:pat[l:ft][l:k] = l:l
        endif
        let l:k = l:line
        let l:l = []
      else
        call add(l:l, l:line[1:])
      endif
    endfor
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
