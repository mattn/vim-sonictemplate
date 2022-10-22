" File:    sonictemplate.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: BSD style license

let s:save_cpo = &cpoptions
set cpoptions&vim

function! unite#sources#sonictemplate#define() abort "{{{
  return s:source
endfunction "}}}

let s:source = {
\ 'name' : 'sonictemplate',
\ 'description' : 'disp templates for sonictemplate',
\}

function! s:source.gather_candidates(args, context) abort "{{{
  call unite#print_message('[sonictemplate]')
  return s:uniq(map(
\     sonictemplate#complete('', '', 0), '{
\     "word"   : s:to_template_name(v:val),
\     "source" : s:source.name,
\     "kind"   : s:source.name,
\     "action__mode" : len(a:args) > 0 ? a:args[0] : "n",
\     "action__name" : s:to_template_name(v:val),
\     "action__path" : v:val,
\   }'
\ ))
endfunction "}}}

" local functions {{{
function! s:uniq(candidates) abort
  let l:has = {}
  let l:uniq_list = []
  for l:candidate in a:candidates
    let l:name = l:candidate.action__name
    if exists(printf("has['%s']", l:name))
      continue
    endif
    let l:has[l:name] = 1
    call add(l:uniq_list, l:candidate)
  endfor
  return l:uniq_list
endfunction

function! s:to_template_name(path) abort
  return substitute(fnamemodify(a:path, ':t:r'), '^\%(base\|snip\)-', '', '')
endfunction
" }}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
" __END__
