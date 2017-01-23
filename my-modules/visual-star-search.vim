" copied from https://github.com/bronson/vim-visual-star-search/blob/master/plugin/visual-star-search.vim
" keep it that way because of unwanted key maps
function! VisualStarSearchSet(cmdtype,...)
  let temp = @"
  normal! gvy
  if !a:0 || a:1 != 'raw'
    let @" = escape(@", a:cmdtype.'\*')
  endif
  let @/ = substitute(@", '\n', '\\n', 'g')
  let @/ = substitute(@/, '\[', '\\[', 'g')
  let @/ = substitute(@/, '\~', '\\~', 'g')
  let @" = temp
endfunction

" vim: set et ts=2 sts=2 sw=2 :
