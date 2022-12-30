" custom maps
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

let mapleader = ','

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nn <leader>bl :ls<CR>:b<space>
nn <leader>bd :ls<CR>:bd<space>
nn <leader>bD :ls<CR>:bd!<space>
nn <leader>bp :b#<CR>
nn <leader>bo :bro o<cr>

nn <leader>r :noh<CR>
nn <leader>R :let @/ = ''<CR>:ec 'Reset search'<CR>

" like 'vip' but 'viz' for a fold (see help for [z and ]z)
xn iz <esc>[zV]z

" Heal vim inperfection
" (fixes syntax highlighting glitches I see pretty often in Haskell files)
nn <leader><cr> :syn sync fromstart<cr>

" 'cr' means 'config reload'
nn <leader>cr :so $MYVIMRC<CR>


" CtrlSpace panel open
nn <C-Space> :CtrlSpace<CR>


" FZF

" fuzzy search for a file
fu! g:FuzzyFileMaps()
	nn        <A-p> :tabnew<CR>:Files!<CR>
	nn        <C-p> :Files<CR>
	nn <space><C-p> :Files!<CR>
endf

" fuzzy search by files from index of current git repo by default
fu! g:FuzzyGitFileMaps()
	nn        <A-p> :tabnew<CR>:GitFiles!<CR>
	nn        <C-p> :GitFiles<CR>
	nn <space><C-p> :GitFiles!<CR>
endf

" regular files search by default
cal FuzzyFileMaps()

" to always have refular files search shortcut,
" even when 'FuzzyGitFileMaps' is called.
nn <leader>ff :Files<CR>
nn  <space>ff :Files!<CR>

" fuzzy commands and commands history
nn         : :Commands<CR>
nm         Ö :
nn  <space>: :Commands!<CR>
nm  <space>Ö <space>:
nn <leader>; :History:<CR>
nm <leader>ö <leader>;
nn  <space>; :History!:<CR>
nm  <space>ö <space>;

" fuzzy buffers, windows and mru
nn <leader><space>   :Buffers<CR>
nn <leader>f<space>  :Buffers!<CR>
nn <leader><leader>  :Windows<CR>
nn <leader>f<leader> :Windows!<CR>
nn <space><leader>   :History<CR>
nn <space>f<leader>  :History!<CR>

" fuzzy search over lines.
" lines of all buffers
nn <leader>sa  :Lines<CR>
xn <leader>sa  <Esc>:Lines <C-r>=GetSelectedText()<CR>
nn <leader>swa :Lines <C-r>=expand('<cword>')<CR><CR>
" fullscreen lines of all buffers
nn  <space>sa  :Lines!<CR>
xn  <space>sa  <Esc>:Lines! <C-r>=GetSelectedText()<CR>
nn  <space>swa :Lines! <C-r>=expand('<cword>')<CR><CR>
" current buffer lines
nn <leader>sl  :BLines<CR>
xn <leader>sl  <Esc>:BLines <C-r>=GetSelectedText()<CR>
nn <leader>swl <Esc>:BLines <C-r>=expand('<cword>')<CR><CR>
" fullscreen current buffer lines
nn  <space>sl  :BLines!<CR>
xn  <space>sl  :BLines! <C-r>=GetSelectedText()<CR>
nn  <space>swl :BLines! <C-r>=expand('<cword>')<CR><CR>

" fuzzy marks
nn <leader>sm :Marks<CR>
nn  <space>sm :Marks!<CR>

" a bit more comfortable to type shorthand for “:update”
nn <leader>sv :up<cr>

" fuzzy search history
nn <leader>/ :History/<CR>
nn  <space>/ :History!/<CR>

" fuzzy git status files
nn <leader>fg :GFiles?<CR>
nn  <space>fg :GFiles!?<CR>

" fuzzy search by help tags
nn <leader>H :Helptags<CR>
nn  <space>H :Helptags!<CR>

nn <leader>fv :Lf<CR>

nn <leader>f <Nop>
nn  <space>f <Nop>

" Make Hoogle search easier (because I use it very often)
nn <leader>go :FuzzyHoogle<space>
nn  <space>go :FuzzyHoogle!<space>
xn <leader>go <Esc>:FuzzyHoogle <C-r>= GetSelectedText()<CR>
xn  <space>go <Esc>:FuzzyHoogle! <C-r>=GetSelectedText()<CR>
xm <leader>gO <leader>go<CR>
xm  <space>gO <space>go<CR>
nn <leader>gO <Nop>
nn  <space>gO <Nop>
nn <leader>gw :FuzzyHoogle <C-r>= expand('<cword>')<CR><CR>
nn  <space>gw :FuzzyHoogle! <C-r>=expand('<cword>')<CR><CR>

" escapes pipe symbol for `:GitGrep`
fu! s:escgg(x)
	retu substitute(a:x, ' |', ' \\|', 'g')
endf

" git-grep shortcuts (kinda like CtrlSF maps but with 'g' instead of 's').
" <leader> for regular window, <space> for fullscreen mode.
" 'i' in key map is for case-insensitive flag.
" regular grep
nn <leader>gf  :GitGrep -F |  nn <space>gf  :GitGrep! -F<space>
nn <leader>gif :GitGrep -iF | nn <space>gif :GitGrep! -iF<space>
" grep by visually selected text
xn <leader>gf  <Esc>:GitGrep -F <C-r>=  <SID>escgg(GetSelectedText())<CR>
xn  <space>gf  <Esc>:GitGrep! -F <C-r>= <SID>escgg(GetSelectedText())<CR>
xn <leader>gif <Esc>:GitGrep -iF <C-r>= <SID>escgg(GetSelectedText())<CR>
xn  <space>gif <Esc>:GitGrep! -iF <C-r>=<SID>escgg(GetSelectedText())<CR>
" grep by word under cusror
no <leader>gn  :GitGrep -F <C-r>=  <SID>escgg(expand('<cword>'))<CR>
no  <space>gn  :GitGrep! -F <C-r>= <SID>escgg(expand('<cword>'))<CR>
no <leader>gin :GitGrep -iF <C-r>= <SID>escgg(expand('<cword>'))<CR>
no  <space>gin :GitGrep! -iF <C-r>=<SID>escgg(expand('<cword>'))<CR>
" grep by currently highlighted search string.
" '-E' by default, because usually it's a highlighted word, like '\<word\>'.
nn <leader>gp  :GitGrep -E <C-r>=  <SID>escgg(@/)<CR>
nn  <space>gp  :GitGrep! -E <C-r>= <SID>escgg(@/)<CR>
nn <leader>gip :GitGrep -iE <C-r>= <SID>escgg(@/)<CR>
nn  <space>gip :GitGrep! -iE <C-r>=<SID>escgg(@/)<CR>
" shortcuts to grep immediately, without previewing command
xm <leader>gF  <leader>gf<CR>|  xm <space>gF  <space>gf<CR>
xm <leader>giF <leader>gif<CR>| xm <space>giF <space>gif<CR>
nm <leader>gN  <leader>gn<CR>|  nm <space>gN  <space>gn<CR>
nm <leader>giN <leader>gin<CR>| nm <space>giN <space>gin<CR>
nm <leader>gP  <leader>gp<CR>|  nm <space>gP  <space>gp<CR>
nm <leader>giP <leader>gip<CR>| nm <space>giP <space>gip<CR>
" no mess caused by pressing wrong keys
nn <leader>g  <Nop>| xn <leader>g  <Nop>
nn <leader>gi <Nop>| xn <leader>gi <Nop>
nn  <space>g  <Nop>| xn  <space>g  <Nop>
nn  <space>gi <Nop>| xn  <space>gi <Nop>

ino <expr> <c-x><c-f> fzf#vim#complete#path("find . \| sed '1d;s:^..::'")
ino <expr> <c-x><c-j> fzf#vim#complete#path('ag --hidden -l -g ""')
im <c-x><c-k> <plug>(fzf-complete-word)
im <c-x><c-l> <plug>(fzf-complete-line)
im <c-x><c-h> <plug>(fzf-complete-buffer-line)

" nnoremap <leader>n :NERDTreeMirrorToggle<CR>
nn <leader>n  :NERDTreeToggle<CR>
nn <leader>N  :NERDTreeToggle<CR><C-w>p
nn <leader>fn :NERDTreeFind<CR>
nn <leader>fo :NERDTreeFind<CR><C-w>p
nn <leader>fb :NERDTreeFind<CR><C-w>p:TagbarOpen<CR>
nn <leader>t  :TagbarToggle<CR>
nn <leader>u  :GundoToggle<CR>


" GitGutter keys
no <leader>gg :GitGutterAll<CR>
nn <leader>gv :GitGutterPreviewHunk<CR>
nn <Leader>ga :GitGutterStageHunk<CR>
nn <Leader>gr :GitGutterUndoHunk<CR>
nm [c         <Plug>(GitGutterPrevHunk)
nm [C         <Plug>(GitGutterPrevHunk)
nm ]c         <Plug>(GitGutterNextHunk)
nm ]C         <Plug>(GitGutterNextHunk)

" git status in new tab
nn <leader>gs :tabnew %<CR>:Git<CR><C-w>o
nn <leader>gS :Git<CR><C-w>o

" modes togglers
nn <leader>mw :WrapToggle<CR>
nn <leader>mp :PasteToggle<CR>
nn <leader>ml :ListToggle<CR>
nn <leader>mn :RelativeNumberToggle<CR>
nn <leader>m] :DelimitMateSwitch<CR>
nn <leader>mg :GitGutterToggle<CR>
nn <leader>mc :AutoClearSpacesAtEOFToggle<CR>
nn <leader>mt :AutoTrimSpacesAtEOFToggle<CR>

" some buffer configs
nn <leader>ft :se ft=
nn <leader>fl :se fdl=
nn <leader>fm :se fdm=


" prevent triggering `s` when `<leader>s` is pressed
" but next symbol not in time.
" can't use `<Nop>` because it affects pressing this second time,
" maybe it's some bug of neovim or something, when i press `<leader>s` wait some
" time and again `<leader>s` then `s` is triggered, strange. that's why it
" solved by these hacks.
nn <leader>s  <Esc>|      nn <space>s  <Esc>
nn <leader>sw <Esc>|      nn <space>sw <Esc>
xn <leader>s  <C-g><C-g>| xn <space>s  <C-g><C-g>
xn <leader>sw <C-g><C-g>| xn <space>sw <C-g><C-g>

" some windows things
nn <leader>sww :9999winc < \| se wiw=
nn <leader>swh :9999winc - \| se wh=
nn  <space>sww :se wfw \| 9999winc < \| se wiw=
nn  <space>swh :se wfh \| 9999winc - \| se wh=


" Neomake
nn <leader>si :NeomakeInfo<CR>
nn <leader>sc :Neomake<CR>
" ALE
nn <leader>de :ALEEnable<cr>
nn <leader>dd :ALEDisable<cr>
nn <leader>di :ALEInfo<cr>
nn <leader>da :ALEDetail<cr>
nn <leader>dn :ALENext<cr>
nn <leader>dp :ALEPrevious<cr>
nn <leader>df :ALEFirst<cr>
nn <leader>dl :ALELast<cr>
nn <leader>dh :ALEHover<cr>
nn <leader>dc :ALEComplete<cr>
nn <leader>dx :ALEFix<cr>
nn <leader>dr :ALERename<cr>
nn <leader>dg :ALEGoToDefinition<cr>
" vim-lsp (first “l” is for Lsp)
"" ‘h’ is for Hierarchy (Add…; …Incoming; …Outgoing)
nn <space>lha :LspAddTreeCallHierarchyIncoming<cr>
nn <space>lhi :LspCallHierarchyIncoming<cr>
nn <space>lho :LspCallHierarchyOutgoing<cr>
"" (Action; Lens)
nn <space>la :LspCodeAction<cr>
nn <space>lA :LspCodeActionSync<cr>
nn <space>ll :LspCodeLens<cr>
"" (DeClaration; DefiNition)
nn <space>ldc :LspDeclaration<cr>
nn <space>ldf :LspDefinition<cr>
"" ‘d’ is for docuMent
"" (Diagnostics; Format; Range…; Word, like for LspWorkspaceSymbol;
"" …sEarch; fOld)
nn <space>lmd :LspDocumentDiagnostics<cr>
nn <space>lmf :LspDocumentFormat<cr>
nn <space>lmF :LspDocumentFormatSync<cr>
nn <space>lmr :LspDocumentRangeFormat<cr>
nn <space>lmR :LspDocumentRangeFormatSync<cr>
nn <space>lmw :LspDocumentSymbol<cr>
nn <space>lme :LspDocumentSymbolSearch<cr>
nn <space>lmo :LspDocumentFold<cr>
nn <space>lmO :LspDocumentFoldSync<cr>
"" ‘v’ is for hoVer
nn <space>lv :LspHover<cr>
"" ‘i’ is for Implementation
nn <space>li :LspImplementation<cr>
"" ’n‘ is Next (Diagnostic; Error; Reference; Warning)
nn <space>lnd :LspNextDiagnostic<cr>
nn <space>lne :LspNextError<cr>
nn <space>lnr :LspNextReference<cr>
nn <space>lnw :LspNextWarning<cr>
"" ‘k’ is for peeK (deClaration; deFinition; Implementation; Type…)
nn <space>lkc :LspPeekDeclaration<cr>
nn <space>lkf :LspPeekDefinition<cr>
nn <space>lki :LspPeekImplementation<cr>
nn <space>lkt :LspPeekTypeDefinition<cr>
"" ’p‘ is for Previous (Diagnostic; Error; Reference; Warning)
nn <space>lpd :LspPreviousDiagnostic<cr>
nn <space>lpe :LspPreviousError<cr>
nn <space>lpr :LspPreviousReference<cr>
nn <space>lpw :LspPreviousWarning<cr>
"" (ReFerence; ReName)
nn <space>lrf :LspReferences<cr>
nn <space>lrn :LspRename<cr>
"" ’s‘ is for Status
nn <space>ls :LspStatus<cr>
"" ‘t’ is for Type (Definition; Hierarchy)
nn <space>ltd :LspTypeDefinition<cr>
nn <space>lth :LspTypeHierarchy<cr>
"" (Workspace… or Word; …sEarch)
nn <space>lw :LspWorkspaceSymbol<cr>
nn <space>le :LspWorkspaceSymbolSearch<cr>
"" ’g‘ is for siGnature
nn <space>lg :LspSignatureHelp<cr>
"" ‘Q’ is for Quit I would say. ’q‘ is just common for Vim.
"" This helps to fix hanged up LSP program.
nn <space>lQ :LspStopServer<cr>
" These are rather for debugging, no need for hot keys for them
" :LspSemanticTokenModifiers
" :LspSemanticTokenTypes


" show hint
nn <leader>sh :ShowHint<CR>


" EasyAlign
xm <Enter> <Plug>(EasyAlign)
nm ga <Plug>(EasyAlign)
" short EasyAlign aliases
xn <leader>:  :EasyAlign/:/<CR>
xn <leader>g: :EasyAlign : {'lm':0,'stl':0}<CR>
" haskell record syntax (align by '=' inside braces)
xn <leader>=  :EasyAlign/\({.*\\|,.*\)\@<==/<CR>
" haskell alone '='
xn <space>=   :EasyAlign/ = /{'lm':0,'rm':0}<CR>
nn <leader>a  :EasyAlign
xn <leader>a  :EasyAlign
xn <leader>A  :EasyAlign/  /{'lm':0,'rm':0}
	\<left><left><left><left><left><left><left><left><left>
	\<left><left><left><left><left><left><left><left>


" CtrlSF bindings
nm <leader>sf <Plug>CtrlSFPrompt
xm <leader>sf <Plug>CtrlSFVwordPath
xm <leader>sF <Plug>CtrlSFVwordExec
nm <leader>sn <Plug>CtrlSFCwordPath
nm <leader>sN <Plug>CtrlSFCwordExec
nm <leader>sp <Plug>CtrlSFPwordPath
nm <leader>sP <Plug>CtrlSFPwordExec
nn <leader>so :CtrlSFOpen<CR>
nn <leader>st :CtrlSFToggle<CR>


" EasyMotion bindings (<Space> for overwin-mode, <Leader> for current window)

"  L----  ('L' - with <leader> or ' ' - without it)
" QWerty  (uppercase means it have map)
" SS----  ('S' - overwin with <space>)

" move anywhere ('q' means 'quick (move)')
nm q          <Plug>(easymotion-bd-w)
xm q          <Plug>(easymotion-bd-w)
nm <Space>q   <Plug>(easymotion-overwin-w)
" doesn't make sense with 'overwin' mode
xm <Space>q   <Nop>
" some plugins uses 'q' map to close window.
" by using 'g' prefix we still able to call easymotion.
nm <leader>gq <Plug>(easymotion-bd-w)
xm <leader>gq <Plug>(easymotion-bd-w)

" move to place with specific symbols
nm <leader>w  <Plug>(easymotion-bd-f2)
xm <leader>w  <Plug>(easymotion-bd-f2)
nm <Space>w   <Plug>(easymotion-overwin-f2)
" doesn't make sense with 'overwin' mode
xm <Space>w   <Nop>

" just another hook as `<leader>e` but for single symbol
nm <leader>e  <Plug>(easymotion-bd-f)
xm <leader>e  <Plug>(easymotion-bd-f)
nm <Space>e   <Plug>(easymotion-overwin-f)
" doesn't make sense with 'overwin' mode
xm <Space>e   <Nop>

" LL-L  ('L' - with <leader> or ' ' - without it)
" ZXcV  (uppercase means it have map)
" -S--  ('S' - overwin with <space>)

" move over the line
nm <leader>z <Plug>(easymotion-lineanywhere)
xm <leader>z <Plug>(easymotion-lineanywhere)

" move between lines
" (also between empty lines with indentation)
nm <leader>x <Plug>(easymotion-bd-jk)
xm <leader>x <Plug>(easymotion-bd-jk)
nm <Space>x  <Plug>(easymotion-overwin-line)
xm <Space>x  <Nop>

" turn on visual mode and select to specific place
nm <leader>v v<Plug>(easymotion-bd-w)
nm <leader>V V<Plug>(easymotion-bd-jk)

" move by direction
nm <leader>l <Plug>(easymotion-lineforward)
xm <leader>l <Plug>(easymotion-lineforward)
nm <leader>h <Plug>(easymotion-linebackward)
xm <leader>h <Plug>(easymotion-linebackward)
nm <leader>j <Plug>(easymotion-j)
xm <leader>j <Plug>(easymotion-j)
nm <leader>k <Plug>(easymotion-k)
xm <leader>k <Plug>(easymotion-k)

" search (with 'incsearch' plugin)
nm g/        <Plug>(incsearch-easymotion-/)
nm g?        <Plug>(incsearch-easymotion-?)
nm <leader>? <Plug>(incsearch-easymotion-stay)
nm <space>g/ <Plug>(incsearch-easymotion-stay)


" quickhl
nm <Space>m <Plug>(quickhl-manual-this)
xm <Space>m <Plug>(quickhl-manual-this)
nm <Space>M <Plug>(quickhl-manual-reset)
xm <Space>M <Plug>(quickhl-manual-reset)
nm <Space>n <Plug>(quickhl-cword-toggle)


" venter
nn <leader>gz :VenterToggle<cr>
nn <leader>gx :let venter_width=80 \| VenterResize
	\<left><left><left><left><left><left><left><left><left><left>
	\<left><left><left><left><left>
nn <leader>gX :unlet venter_width \| VenterResize<cr>


" remove word selection symbols after paste from search
nm  <leader>c/  ds\ds>
" plugs to prevent mess about triggering default 'p' or 'P'
map <leader>p   <Nop>
map <leader>P   <Nop>
" paste searched word and clean it
map <leader>p/  '/phds\ds>
map <leader>P/  '/Phds\ds>
nm  <leader>po  <A-.>jP
nm  <leader>pO  <A-,>kP

" another alias to system X clipboard
no '<Space>  "+
map ä<Space> '<Space>
no <Space>'  "*
map <Space>ä <Space>'
" yank from tmux buffer
no <leader>' :let @@=system('tmux showb')<CR>
map <leader>ä <leader>'
" yank from tmux buffer and replace visual selection
xn <leader>' <Esc>:let @@=system('tmux showb')<CR>gvp
xm <leader>ä <leader>'
" yank from specific tmux buffer (TODO use fzf for it)
no <leader>" :
	\!tmux list-b<CR>:let @@=system('tmux showb -b buffer0')<Left><Left>
map <leader>ä <leader>"
" yank from specific tmux buffer and replace visual selection
xn <leader>" <Esc>:echoe 'NOT YET IMPLEMENTED'<CR>gv
xm <leader>Ä <leader>"
" send to tmux clipboard buffer
no '<leader> :cal system('tmux setb -- '.shellescape(@"))<CR>
map ä<leader> '<leader>
" yank visual selection and send it to tmux clipboard buffer
xn '<leader> y:cal system('tmux setb -- '.shellescape(@"))<CR>
xm ä<leader> '<leader>
" send to tmux clipboard buffer specific register
no "<leader> :cal system('tmux setb -- '.shellescape(@))<Left><Left>
map Ä<leader> "<leader>
" yank visual selection and send it to tmux clipboard buffer
xn "<leader> <Esc>:echoe 'NOT YET IMPLEMENTED'<CR>gv
xm Ä<leader> "<leader>
" another alias to 'last yank' register
no <A-y> "0

fu! s:copy_many_lines_as_one(sys_clipboard)
	let l:view = winsaveview() | let l:buf = a:sys_clipboard ? '"+' : ''
	exe 'norm! gvJgv'.l:buf.'yu'
	cal winrestview(l:view)
endf

" copy multiple selected lines as one single line
xn <leader>y <Esc>:cal <SID>copy_many_lines_as_one(0)<CR>
" copy multiple selected lines as one single line to system clipboard
xn <leader>Y <Esc>:cal <SID>copy_many_lines_as_one(1)<CR>


" forward version of <C-h>
no! <C-l> <Del>


" colorscheme stuff
no <leader>ss <Esc>:se bg=
no <leader>sb :BackgroundToggle<CR>
no <leader>sB :GruvboxContrastRotate<CR>

nn gy Y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:ec<CR>
nn gY Y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:ec<CR>
xn gy y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:ec<CR>
xn gY y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:ec<CR>

" walking between windows (hjkl)
nn <C-h>     :winc h<CR>
xn <C-h>     <Esc>:winc h<CR>
nn <C-j>     :winc j<CR>
xn <C-j>     <Esc>:winc j<CR>
nn <C-k>     :winc k<CR>
xn <C-k>     <Esc>:winc k<CR>
nn <C-l>     :winc l<CR>
xn <C-l>     <Esc>:winc l<CR>
" walking between windows (arrow keys)
nn <C-Left>  :winc h<CR>
xn <C-Left>  <Esc>:winc h<CR>
nn <C-Right> :winc l<CR>
xn <C-Right> <Esc>:winc l<CR>
nn <C-Up>    :winc k<CR>
xn <C-Up>    <Esc>:winc k<CR>
nn <C-Down>  :winc j<CR>
xn <C-Down>  <Esc>:winc j<CR>
" windows size minimization/maximization/normalization
nn <A-=>     :winc =<CR>
nn <A-->     :winc _<CR>
nn <A-\>     :winc \|<CR>
" for finnish layout
nn <A-/>     :winc \|<CR>

" scrolling windows by alt+arrow keys in any direction
nn <A-Left>  zh
xn <A-Left>  zh
nn <A-Right> zl
xn <A-Right> zl
nn <A-Up>    <C-y>
xn <A-Up>    <C-y>
nn <A-Down>  <C-e>
xn <A-Down>  <C-e>

" resizing windows by alt+shift+arrow keys
nn <A-S-Left>  :winc <<CR>
xn <A-S-Left>  <Esc>:winc <<CR>
nn <A-S-Right> :winc ><CR>
xn <A-S-Right> <Esc>:winc ><CR>
nn <A-S-Up>    :winc +<CR>
xn <A-S-Up>    <Esc>:winc +<CR>
nn <A-S-Down>  :winc -<CR>
xn <A-S-Down>  <Esc>:winc -<CR>

" zoom buffer hack ('fz' means 'full size')
nn <leader>fz :999winc ><CR>:999winc +<CR>
xn <leader>fz <Esc>:999winc ><CR>:999winc +<CR>gv

" moving between history in command mode
cno <C-p> <Up>
cno <C-n> <Down>

" moving tabs
nn <C-S-PageUp>   :tabm-1<CR>
nn <C-S-PageDown> :tabm+1<CR>

" jump by half of screen by pageup/pagedown
nm <PageUp>     <C-u>
nm <PageDown>   <C-d>
xm <PageUp>     <C-u>
xm <PageDown>   <C-d>
" default jump by pageup/pagedown with shift prefix
nm <S-PageUp>   <C-b>
nm <S-PageDown> <C-f>
xm <S-PageUp>   <C-b>
xm <S-PageDown> <C-f>

" get rid off randomly turning ex-mode on
nm Q     <Nop>
nm gQ    <Nop>
nm <A-Q> <Nop>
im <A-Q> <Nop>

" remap macros key under leader
" default 'q' remapped to easymotion call
no <leader>q q

xn   <Tab> <Esc>
snor <Tab> <Esc>
tno  <Leader><Tab> <C-\><C-n>
tno  <Leader><Esc> <C-\><C-n>

" thanks to Minoru for the advice to swap ; and :
no ; :
map ö ;

" thanks to r3lgar for the advice (swap default <leader> and comma)
no \ ;
no \| ,

" because working with clipboard registers is more important
no ' "
map ä '
no " '
map Ä "
no "" ''
map ÄÄ ""
nn '' :reg<CR>
nm ää ''

" custom behavior of big R in visual mode
xn R r<Space>R

" break line but keep same column position for rest of the line
fu! s:split_next_line(new_col_offset, stay)
	let l:pos=getcurpos() | let l:line=getline('.') | let l:vc=virtcol('$')
	if l:pos[4] >= l:vc
		pu=repeat(' ', l:pos[4] - 1 + a:new_col_offset)
		cal setline(l:pos[1], l:line[:l:pos[2]])
	el
		pu=repeat(' ', l:pos[4] - 1 + a:new_col_offset) . l:line[l:pos[2] - 1:]
		cal setline(l:pos[1], l:line[:l:pos[2] - 2])
	en
	if a:stay
		cal setpos('.', l:pos)
	elsei l:pos[4] >= l:vc
		let l:pos[1] += 1 | let l:pos[2] = l:pos[4] + a:new_col_offset
		let l:pos[3] = 0 | unlet l:pos[4] | cal setpos('.', l:pos)
	en
endf
ino <A-CR> <C-o>:cal <SID>split_next_line( 0, 0)<CR>
" cannot map <S-CR> to make <A-S-CR> alternative
" imap <A-S-CR> <C-o>:cal <SID>split_next_line(-1, 0)<CR>
ino <A-'>  <C-o>:cal <SID>split_next_line( 0, 1)<CR>
im  <A-ä>  <A-'>
ino <A-">  <C-o>:cal <SID>split_next_line(-1, 1)<CR>
im  <A-Ä>  <A-">
fu! s:split_prev_line(new_col_offset, stay)
	let l:pos=getcurpos() | let l:line=getline('.') | let l:vc=virtcol('$')
	if l:pos[4] >= l:vc
		pu!=repeat(' ', l:pos[4] - 1 + a:new_col_offset)
		cal setline(l:pos[1] + 1, l:line[:l:pos[2]])
	el
		pu!=repeat(' ', l:pos[4] - 1 + a:new_col_offset) . l:line[l:pos[2] - 1:]
		cal setline(l:pos[1] + 1, l:line[:l:pos[2] - 2])
	en
	if a:stay
		let l:pos[1] += 1 | cal setpos('.', l:pos)
	elsei l:pos[4] >= l:vc
		let l:pos[2] = l:pos[4] + a:new_col_offset | let l:pos[3] = 0
		unlet l:pos[4] | cal setpos('.', l:pos)
	en
endf
ino <A-\>  <C-o>:cal <SID>split_prev_line( 0, 0)<CR>
ino <A-\|> <C-o>:cal <SID>split_prev_line(-1, 0)<CR>
ino <A-]>  <C-o>:cal <SID>split_prev_line( 0, 1)<CR>
ino <A-}>  <C-o>:cal <SID>split_prev_line(-1, 1)<CR>

fu! s:new_line_after()
	let l:x = getpos('.') | pu='' | cal setpos('.', l:x)
endf
nn <A-.> :cal <SID>new_line_after()<CR>
nn <A->> :pu=''<CR>
fu! s:new_line_before()
	let l:x = getpos('.') | pu!='' | let l:x[1] += 1 | cal setpos('.', l:x)
endf
nn <A-,> :cal <SID>new_line_before()<CR>
nn <A-<> :pu!=''<CR>
nm <leader>o <A-.>ji
nm <leader>O <A-,>ki

" add space without moving cursor
im <A-Space> <Space><Left>


" custom numbers line keys

nn ! #:ShowSearchIndex<CR>
nn g! :se hls<CR>:let @/='\V\<'.expand('<cword>').'\>'<CR>:ShowSearchIndex<CR>
xn ! :<C-u>cal VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>:ShowSearchIndex<CR>
xn g! :<C-u>se hls<CR>gv:<C-u>cal VisualStarSearchSet('?')<CR>:ShowSearchIndex<CR>
nn @ *:ShowSearchIndex<CR>
nn g@ :se hls<CR>:let @/='\V\<'.expand('<cword>').'\>'<CR>:ShowSearchIndex<CR>
xn @ :<C-u>cal VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>:ShowSearchIndex<CR>
xn g@ :<C-u>se hls<CR>gv:<C-u>cal VisualStarSearchSet('/')<CR>:ShowSearchIndex<CR>
" no ! #
" no @ *

" '(ba)ng'
no <leader>ba !
xn <leader>ba !
" '(b)ang(b)ang'
no <leader>bb !!
xn <leader>bb !!

" begin/end of line ignoring indentation and trailing whitespaces
no  #  ^
no  £  ^
no g# g^
no g£ g^
no  $ g_
no g$ g$

" default behavior of %
" noremap %

" noremap ^ 0
" we already have 0, I never use this key (^) this way
" let's remap it to '|' that in case was remapped too
no  ^ \|
no g^ g0

" opposite to 0
no  &  $
no g& g$

" macros call
no  *  @
no g* g@

" swapping j/k with gj/gk
nn  j gj
xn  j gj
nn  k gk
xn  k gk
nn gj  j
xn gj  j
nn gk  k
xn gk  k

" relative tabnext by default
nn gt :<C-u>exe join(repeat(['tabnext'], v:count1), '\|')<CR>
xn gt :<C-u>exe join(repeat(['tabnext'], v:count1), '\|')<CR>
" original behavior via <leader> key
nn <leader>gt gt
xn <leader>gt gt

" additional move over cursor history (as alternative to ^O/^I).
" moving over changelist (see :changes).
nn <A-o> g;
nn <A-i> g,

" navigating by tabs
nm <A-f> gt
nm <A-b> gT
nm <A-1> 1,gt
nm <A-2> 2,gt
nm <A-3> 3,gt
nm <A-4> 4,gt
nm <A-5> 5,gt
nm <A-6> 6,gt
nm <A-7> 7,gt
nm <A-8> 8,gt
nm <A-9> 9,gt
nm <A-0> 10,gt

" default maps disabled for plugin
cno <expr> <CR> '<CR>' . (getcmdtype() =~ '[/?]' ? ':ShowSearchIndex<CR>' : '')
nn n n:ShowSearchIndex<CR>
nn N N:ShowSearchIndex<CR>

nn <A-t> :tabe<CR>
nn <A-w> :tabc<CR>

" quick hook for 'IndentText'
xn <A-i>   ym0gvc<Esc>`0:cal<space>IndentText()<CR>
xn <A-S-i> ym0gvI<Esc>`0:cal<space>IndentText()<CR>
" FIXME it executes the function but also triggers default `b` action
" xn <expr> <A-b> IndentTextBlock()
xn <A-b> :<C-u>cal IndentTextBlock()<CR>

" pasting from default buffer in insert/cmdline mode
no! <A-p> <C-r>"
no! <A-y> <C-r>0

" escaping last input in insert mode
" (keep in mind that it's not just an input but all pressed keys sequence)
ino <A-e> <Esc>ui<C-r>=substitute(@.,'.','\\&','g')<CR>

" to create short aliases for tTfF jumps to unicode symbols
fu! s:UnicodeJumpsShortcuts(ascii, uni)
	for mpfx in ['n', 'x']
		for apfx in ['', 'd', 'c']
			exe l:mpfx.'no '.l:apfx.'t<A-'.a:ascii.'> '.l:apfx.'t'.a:uni
			exe l:mpfx.'no '.l:apfx.'T<A-'.a:ascii.'> '.l:apfx.'T'.a:uni
			exe l:mpfx.'no '.l:apfx.'f<A-'.a:ascii.'> '.l:apfx.'f'.a:uni
			exe l:mpfx.'no '.l:apfx.'F<A-'.a:ascii.'> '.l:apfx.'F'.a:uni
		endfo
	endfo
endf

" based on snippets for Haskell
cal s:UnicodeJumpsShortcuts(';', '∷')
cal s:UnicodeJumpsShortcuts(':', '∷')
cal s:UnicodeJumpsShortcuts('<', '←')
cal s:UnicodeJumpsShortcuts('>', '→')
cal s:UnicodeJumpsShortcuts('[', '⇐')
cal s:UnicodeJumpsShortcuts(']', '⇒')
cal s:UnicodeJumpsShortcuts('.', '∘')
cal s:UnicodeJumpsShortcuts(',', '•')
cal s:UnicodeJumpsShortcuts('A', '∀')
cal s:UnicodeJumpsShortcuts('a', '∧') " 'a' for 'and'
cal s:UnicodeJumpsShortcuts('o', '∨') " 'o' for 'or'
cal s:UnicodeJumpsShortcuts('=', '≡')
cal s:UnicodeJumpsShortcuts('-', '≠')
cal s:UnicodeJumpsShortcuts('_', '≢')
cal s:UnicodeJumpsShortcuts('l', '≤') " 'l' for 'less'
cal s:UnicodeJumpsShortcuts('g', '≥') " 'g' for 'greater'
cal s:UnicodeJumpsShortcuts('+', '⧺')
cal s:UnicodeJumpsShortcuts('*', '⋅')
cal s:UnicodeJumpsShortcuts('x', '×')
cal s:UnicodeJumpsShortcuts('/', '÷')
cal s:UnicodeJumpsShortcuts('e', '∈')
cal s:UnicodeJumpsShortcuts('E', '∉')
cal s:UnicodeJumpsShortcuts('3', '∋')
cal s:UnicodeJumpsShortcuts('#', '∌')
cal s:UnicodeJumpsShortcuts('Z', 'ℤ')
cal s:UnicodeJumpsShortcuts('N', 'ℕ')
cal s:UnicodeJumpsShortcuts('Q', 'ℚ')
cal s:UnicodeJumpsShortcuts('R', 'ℝ')
cal s:UnicodeJumpsShortcuts('B', '𝔹')
cal s:UnicodeJumpsShortcuts('P', 'π')
cal s:UnicodeJumpsShortcuts('8', '∞')
cal s:UnicodeJumpsShortcuts('d', '…') " 'd' for 'dots'
cal s:UnicodeJumpsShortcuts('{', '«')
cal s:UnicodeJumpsShortcuts('}', '»')
cal s:UnicodeJumpsShortcuts('v', '⋄')
cal s:UnicodeJumpsShortcuts('r', '◇') " 'r' for 'rhombus'


" UltiSnips map without conflicts
" with own <Tab> maps for visual and select modes.
if !exists('plug_home') || (has('python3') || has('python'))
	" FIXME for js/ts snippets UltiSnips#SnippetsInCurrentScope() returns empty
	"       dictionary if a snippet doesn't have space character before while
	"       UltiSnips#ExpandSnippet() correctly expands such a snippet
	fu! s:IsSnippetExpandable()
		retu !(
			\ col('.') <= 1
			\ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
			\ || empty(UltiSnips#SnippetsInCurrentScope())
			\ )
	endf

	ino <expr> <Tab> <SID>IsSnippetExpandable()
		\ ? '<C-R>=UltiSnips#ExpandSnippet()<CR>' : '<Tab>'

	" FIXME fix the issue with UltiSnips#SnippetsInCurrentScope() and you wont
	"       need this hack to force expanding anymore
	ino <C-x><Tab> <C-R>=UltiSnips#ExpandSnippet()<CR>
en
