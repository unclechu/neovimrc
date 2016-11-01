" http://hackage.haskell.org/package/haskdogs
" Cyclic tag navigation {{{
let s:rt_cw = ''
function! s:RT()
    let l:cw = expand('<cword>')
    try
        if l:cw != s:rt_cw
            execute 'tag ' . l:cw
            call search(l:cw,'c',line('.'))
        else
            try
                execute 'tnext'
            catch /.*/
                execute 'trewind'
            endtry
            call search(l:cw,'c',line('.'))
        endif
        let s:rt_cw = l:cw
    catch /.*/
        echo "no tags on " . l:cw
    endtry
endfunction
noremap <C-]> :call <SID>RT()<CR>
" }}}
