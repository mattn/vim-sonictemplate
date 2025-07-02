function! sonictemplate#lang#cs#util(name) abort
  if a:name ==# 'namespace'
    return s:namespace()
  elseif a:name ==# 'class'
    return s:classname()
  endif
  return ''
endfunction

" Infer namespace from project file location,
" <RootNamespace>, and directory structure.
" /A.csproj, /B.cs                        → A
" /A.csproj, /B/C.cs                      → A.B
" /A.csproj (RootNamespace=Root), /B/C.cs → Root.B
" /A/B.cs                                 → A
" /A.cs                                   → cwd + :t
function! s:namespace() abort
  const file_path = bufname()->fnamemodify(':p')
  const dir_path = file_path->isdirectory()
        \ ? file_path
        \ : file_path->fnamemodify(':h')
  const csproj_path = dir_path->s:find_csproj()
  if csproj_path->empty()
    if dir_path ==# getcwd()
      " :. doesn't modify when text equals to cwd
      return dir_path->fnamemodify(':t')
    endif
    return dir_path->fnamemodify(':.')->s:to_ns()
  endif
  const root_namespace = csproj_path->s:root_namespace()
  const sub_namespace = csproj_path->s:sub_namespace(dir_path)
  return [root_namespace, sub_namespace]
        \ ->filter({ _, s -> !s->empty() })
        \ ->join('.')
endfunction

function! s:classname() abort
  return expand('%:t:r')
endfunction

function! s:find_csproj(path) abort
  if a:path ==# '/'
    return ''
  endif
  if a:path->isdirectory()
    for file in a:path->readdir({ name -> name->fnamemodify(':e') ==# 'csproj' })
      return [a:path, file]->join('/')
    endfor
  endif
  return a:path->fnamemodify(':h')->s:find_csproj()
endfunction

function! s:root_namespace(csproj_path) abort
  const content = a:csproj_path->readfile()->join('\n')
  const match = content->matchstr('\v\<RootNamespace[^>]*\>\zs[^<]+\ze\<\/RootNamespace\>')
  if !match->empty()
    return match
  endif
  return a:csproj_path->fnamemodify(':t:r')
endfunction

function! s:sub_namespace(csproj_path, file_path) abort
  const csproj_dir = a:csproj_path->fnamemodify(':h')
  const is_included = a:file_path[:(csproj_dir->len() - 1)] ==# csproj_dir
  if is_included
    const sub_path = a:file_path[csproj_dir->len():]
    return sub_path->s:to_ns()
  endif
  return a:file_path->fnamemodify(':.')->s:to_ns()
endfunction

function! s:to_ns(path) abort
  return a:path->substitute('\(^\W\+\|\W\+$\)', '', 'g')->substitute('[/\]\+', '.', 'g')
endfunction
