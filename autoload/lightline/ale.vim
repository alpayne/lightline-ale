let s:indicator_infos = get(g:, 'lightline#ale#indicator_infos', 'I: ')
let s:indicator_warnings = get(g:, 'lightline#ale#indicator_warnings', 'W: ')
let s:indicator_errors = get(g:, 'lightline#ale#indicator_errors', 'E: ')
let s:indicator_ok = get(g:, 'lightline#ale#indicator_ok', 'OK')
let s:indicator_checking = get(g:, 'lightline#ale#indicator_checking', 'Linting...')
let s:merge_info_to_warning = get(g:, 'lightline#ale#merge_info_to_warning', 0)


""""""""""""""""""""""
" Lightline components

function! lightline#ale#infos() abort
  if !lightline#ale#linted() || s:merge_info_to_warning == 1
    return ''
  endif
  let l:counts = ale#statusline#Count(bufnr(''))
  return l:counts.info == 0 ? '' : printf(s:indicator_infos . '%d', l:counts.info)
endfunction

function! lightline#ale#warnings() abort
  if !lightline#ale#linted()
    return ''
  endif
  let l:counts = ale#statusline#Count(bufnr(''))
  if s:merge_info_to_warning == 1
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:all_non_errors == 0 ? '' : printf(s:indicator_warnings . '%d', all_non_errors)
  else
    let l:all_warnings = l:counts.warning + l:counts.style_warning
    return l:all_warnings == 0 ? '' : printf(s:indicator_warnings . '%d', all_warnings)
  endif
endfunction

function! lightline#ale#errors() abort
  if !lightline#ale#linted()
    return ''
  endif
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:all_errors == 0 ? '' : printf(s:indicator_errors . '%d', all_errors)
endfunction

function! lightline#ale#ok() abort
  if !lightline#ale#linted()
    return ''
  endif
  let l:counts = ale#statusline#Count(bufnr(''))
  return l:counts.total == 0 ? s:indicator_ok : ''
endfunction

function! lightline#ale#checking() abort
  return ale#engine#IsCheckingBuffer(bufnr('')) ? s:indicator_checking : ''
endfunction


""""""""""""""""""
" Helper functions

function! lightline#ale#linted() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_enabled', 1)
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
    \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction
