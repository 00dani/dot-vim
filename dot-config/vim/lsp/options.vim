vim9script

export const lspOptions = {
	aleSupport: true,
	autoComplete: false, # I prefer manual tab completion using MUcomplete
	ignoreMissingServer: true,
}

def ServerHas(feature: string): bool
	return lsp#buffer#CurbufGetServer(feature) != {}
enddef

export def SetBufferOptions(): void
	if ServerHas('documentFormatting')
		setlocal formatexpr=lsp#lsp#FormatExpr()
	endif

	if ServerHas('hover')
		setlocal keywordprg=:LspHover
	endif

	if ServerHas('declaration')
		nnoremap <buffer> gD <Cmd>LspGotoDeclaration<CR>
	endif

	if ServerHas('definition')
		nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
	endif

	if ServerHas('implementation')
		nnoremap <buffer> gi <Cmd>LspGotoImpl<CR>
	endif

	if ServerHas('references')
		nnoremap <buffer> gr <Cmd>LspShowReferences<CR>
	endif

	if ServerHas('selectionRange')
		xnoremap <buffer> <silent> <Leader>e <Cmd>LspSelectionExpand<CR>
		xnoremap <buffer> <silent> <Leader>s <Cmd>LspSelectionShrink<CR>
	endif
enddef
