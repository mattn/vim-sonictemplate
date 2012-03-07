" File:    sonictemplate
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
  return map(sonictemplate#templates(), '{
\   "word"   : s:to_template_name(v:val),
\   "source" : s:source.name,
\   "kind"   : s:source.name,
\   "action__mode" : len(a:args) > 0 ? args[0] : "n"
\ }')
endfunction"}}}

" local functions {{{
function! s:to_template_name(path)
  return substitute(fnamemodify(a:path, ':t:r'), '^\%(base\|snip\)-', '', '')
endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
