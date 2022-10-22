function! sonictemplate#lang#html#guess() abort
  let [l:m1, l:m2] = ['<\([^ >]\+\)[^>]*>', '</[^>]\+>\zs']
  let l:area = [searchpairpos(l:m1, '\%#', l:m2, 'bnW'), searchpos(l:m2, 'nW')]
  if l:area[0][0] == 0 || l:area[1][0] == 0
    return []
  endif
  let l:lines = getline(l:area[0][0], l:area[1][0])
  if l:area[0][0] == l:area[1][0]
    let l:lines[0] = l:lines[0][l:area[0][1]-1 : l:area[1][1]-1]
  else
    let l:lines[0] = l:lines[0][l:area[0][1]-1 :]
    let l:lines[-1] = l:lines[-1][: l:area[1][1]-1]
  endif
  let l:content = join(l:lines, "\n")
  let l:tag = matchstr(l:content, '^<\zs[^> ]\+\ze.*')
  let l:inner = substitute(matchstr(l:content, '^<[^>]\+>\zs.*\ze</[^>]\+>$'), '[ \t\r\n]', '', 'g')
  if l:tag ==# 'script'
    return {
    \ 'filetype': 'javascript',
    \ 'prefix': len(l:inner) > 0 ? 'snip' : 'base',
    \}
  endif
  if l:tag ==# 'style'
    return {
    \ 'filetype': 'css',
    \ 'prefix': len(l:inner) > 0 ? 'snip' : 'base',
    \}
  endif
  if l:tag ==# 'head'
    return {
    \ 'filter': 'link\|meta'
    \}
  endif
  return []
endfunction
