vim9script

import './lsp/servers.vim'
import './lsp/options.vim'
import './tools/strings.vim'

command! -nargs=* -complete=customlist,ListMissingServers -bar LspInstall servers.Install([<f-args>], AddExtraServers)

def ListMissingServers(argLead: string, cmdLine: string, cursorPos: number): list<string>
	return servers.Missing()->mapnew((_, server): string => server.name)
enddef

def AddExtraServers(extraServers: list<dict<any>>): void
	g:lsp#lsp#AddServer(extraServers->deepcopy())
enddef

export def Configure(): void
	augroup dot/vim/lsp.vim
		autocmd!
		autocmd User LspAttached options.SetBufferOptions()
	augroup END

	# We have to use final rather than const because LspAddServer() assumes it can
	# modify the dicts it gets, rather than making a fresh copy to mess with.
	final installedServers = servers.Installed()

	const missingCount = servers.CountAll() - len(installedServers)
	if missingCount > 0
		# Since this code runs during Vim initialisation, this message would
		# normally pause Vim's startup so the user can read it. We don't want
		# that, so we're gonna delay it using an autocmd.
		const warn = $'{missingCount} language server{missingCount > 1 ? "s are" : " is"} configured, but not installed. You may want to run :LspInstall.'
		augroup dot/vim/lsp.vim
			exe $'autocmd VimEnter * ++once echo {strings.Quote(warn)}'
		augroup END
	endif

	g:lsp#options#OptionsSet(options.lspOptions)
	g:lsp#lsp#AddServer(installedServers)
enddef
