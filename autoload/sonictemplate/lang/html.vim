function! sonictemplate#lang#html#guess()
  let [m1, m2] = ['<\([^ >]\+\)[^>]*>', '</[^>]\+>\zs']
  let area = [searchpairpos(m1, '\%#', m2, 'bnW'), searchpos(m2, 'nW')]
  if area[0][0] == 0 || area[1][0] == 0
    return []
  endif
  let lines = getline(area[0][0], area[1][0])
  if area[0][0] == area[1][0]
    let lines[0] = lines[0][area[0][1]-1:area[1][1]-1]
  else
    let lines[0] = lines[0][area[0][1]-1:]
    let lines[-1] = lines[-1][:area[1][1]-1]
  endif
  let content = join(lines, "\n")
  let tag = matchstr(content, '^<\zs[^> ]\+\ze.*')
  let inner = substitute(matchstr(content, '^<[^>]\+>\zs.*\ze</[^>]\+>$'), '[ \t\r\n]', '', 'g')
  if tag == 'script'
    return {
    \ 'filetype': 'javascript',
    \ 'prefix': len(inner) > 0 ? 'snip' : 'base',
    \}
  endif
  if tag == 'style'
    return {
    \ 'filetype': 'css',
    \ 'prefix': len(inner) > 0 ? 'snip' : 'base',
    \}
  endif
  if tag == 'head'
    return {
    \ 'filter': 'link\|meta'
    \}
  endif
  return []
endfunction
