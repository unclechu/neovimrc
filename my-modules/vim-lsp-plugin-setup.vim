" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

" This module provides a setup for vim-lsp plugin.
" These mappings are in conflict with with ones set in a Lua module
" (“lsp-setup.lua”) that uses native Neovim LSP support. Call mappings set for
" either one, not both at the same time.
" If you are going to use vim-lsp plugin in your project just call
" “SetVimLspMaps” command.

" Options for vim-lsp plugin
let g:lsp_signs_enabled = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlight_references_enabled = 1

" Setup key mappings for vim-lsp plugin
function! SetVimLspMaps()
	" vim-lsp (first “l” is for Lsp)
	"" Make sure no standard maps are invoked when a sequence is incomplete
	nn <space>l <nop>
	"" ‘h’ is for Hierarchy (Add…; …Incoming; …Outgoing)
	nn <space>lh <nop>
	nn <space>lha :LspAddTreeCallHierarchyIncoming<cr>
	nn <space>lhi :LspCallHierarchyIncoming<cr>
	nn <space>lho :LspCallHierarchyOutgoing<cr>
	"" (Action; Lens)
	nn <space>la :LspCodeAction<cr>
	nn <space>lA :LspCodeActionSync<cr>
	nn <space>ll :LspCodeLens<cr>
	"" (DeClaration; DefiNition)
	nn <space>ld <nop>
	nn <space>ldc :LspDeclaration<cr>
	nn <space>ldf :LspDefinition<cr>
	"" ‘d’ is for docuMent
	"" (Diagnostics; Format; Range…; Word, like for LspWorkspaceSymbol;
	"" …sEarch; fOld)
	nn <space>lm <nop>
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
	nn <space>ln <nop>
	nn <space>lnd :LspNextDiagnostic<cr>
	nn <space>lne :LspNextError<cr>
	nn <space>lnr :LspNextReference<cr>
	nn <space>lnw :LspNextWarning<cr>
	"" ‘k’ is for peeK (deClaration; deFinition; Implementation; Type…)
	nn <space>lk <nop>
	nn <space>lkc :LspPeekDeclaration<cr>
	nn <space>lkf :LspPeekDefinition<cr>
	nn <space>lki :LspPeekImplementation<cr>
	nn <space>lkt :LspPeekTypeDefinition<cr>
	"" ’p‘ is for Previous (Diagnostic; Error; Reference; Warning)
	nn <space>lp <nop>
	nn <space>lpd :LspPreviousDiagnostic<cr>
	nn <space>lpe :LspPreviousError<cr>
	nn <space>lpr :LspPreviousReference<cr>
	nn <space>lpw :LspPreviousWarning<cr>
	"" (ReFerence; ReName)
	nn <space>lr <nop>
	nn <space>lrf :LspReferences<cr>
	nn <space>lrn :LspRename<cr>
	"" ’s‘ is for Status
	nn <space>ls :LspStatus<cr>
	"" ‘t’ is for Type (Definition; Hierarchy)
	nn <space>lt <nop>
	nn <space>ltd :LspTypeDefinition<cr>
	nn <space>lth :LspTypeHierarchy<cr>
	"" (Workspace… or Word; …sEarch)
	nn <space>lw :LspWorkspaceSymbol<cr>
	nn <space>le :LspWorkspaceSymbolSearch<cr>
	"" ’g‘ is for siGnature
	nn <space>lg :LspSignatureHelp<cr>
	"" ‘q’ is for Quit I would say. ’q‘ is just common for Vim.
	"" This helps to fix hanged up LSP program.
	nn <space>lq :LspStopServer<cr>
	" These are rather for debugging, no need for hot keys for them
	" :LspSemanticTokenModifiers
	" :LspSemanticTokenTypes
endfunction

command! SetVimLspMaps call SetVimLspMaps()

" vim: set noet :
