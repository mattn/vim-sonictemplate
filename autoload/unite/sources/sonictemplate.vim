" File:    sonictemplate.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: BSD style license

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#sonictemplate#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
\ 'name' : 'sonictemplate',
\ 'description' : 'disp templates for sonictemplate',
\}

function! s:source.gather_candidates(args, context)"{{{
  call unite#print_message('[sonictemplate]')
  return s:uniq(map(
\     sonictemplate#complete("", "", 0), '{
\     "word"   : s:to_template_name(v:val),
\     "source" : s:source.name,
\     "kind"   : s:source.name,
\     "action__mode" : len(a:args) > 0 ? args[0] : "n",
\     "action__name" : s:to_template_name(v:val),
\     "action__path" : v:val,
\   }'
\ ))
endfunction"}}}

" local functions {{{
function! s:uniq(candidates)
  let has = {}
  let uniq_list = []
  for candidate in a:candidates
    let name = candidate.action__name
    if exists(printf("has['%s']", name))
      continue
    endif
    let has[name] = 1
    call add(uniq_list, candidate)
  endfor
  return uniq_list
endfunction

function! s:to_template_name(path)
  return substitute(fnamemodify(a:path, ':t:r'), '^\%(base\|snip\)-', '', '')
endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
