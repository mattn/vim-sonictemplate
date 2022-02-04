function! s:handler(item) abort
  call sonictemplate#apply(a:item.items[0], 'n')
endfunction

function! fz#sonictemplate#run() abort
  call fz#run({'type': 'list', 'list': sonictemplate#complete('', '', 0), 'accept': function('s:handler')})
endfunction
