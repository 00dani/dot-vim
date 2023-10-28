vim9script

import './tools/strings.vim'
import './tools/perl.vim'

const lspServers = [
	{
		name: 'dockerfile-langserver',
		filetype: 'dockerfile',
		path: expand('~/.local/bin/docker-langserver'),
		args: ['--stdio'],
		install: 'npm install -g dockerfile-language-server-nodejs',
	},

	{
		name: 'lua-language-server',
		filetype: 'lua',
		path: '/usr/local/bin/lua-language-server',
		args: [],
		install: 'brew install lua-language-server',
	},

	{
		name: 'PerlNavigator',
		filetype: 'perl',
		path: expand('~/.local/bin/perlnavigator'),
		args: ['--stdio'],
		install: 'npm install -g perlnavigator-server',
	},

	perl.Lsp('Perl::LanguageServer', ['-e', 'Perl::LanguageServer::run']),

	{
		name: 'taplo',
		filetype: 'toml',
		path: '/usr/local/bin/taplo',
		args: ['lsp', 'stdio'],
		install: 'brew install taplo',
	},

	{
		name: 'tilt-lsp',
		filetype: 'bzl',
		path: '/usr/local/bin/tilt',
		args: ['lsp', 'start'],
		install: 'brew install tilt',
	},

	{
		name: 'typescript-language-server',
		filetype: ['javascript', 'typescript'],
		path: '/usr/local/bin/typescript-language-server',
		args: ['--stdio'],
		install: 'brew install typescript-language-server',
	},

	{
		name: 'phpactor',
		filetype: 'php',
		path: expand('~/bin/phpactor'),
		args: ['language-server'],
		initializationOptions: {
			'language_server_configuration.auto_config': false,
		},
		install: 'curl -Lo phpactor https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar && chmod u+x phpactor && mv phpactor ~/bin',
	},

	{
		name: 'pylsp',
		filetype: 'python',
		path: '/usr/local/bin/pylsp',
		args: [],
		install: 'brew install python-lsp-server',
	},

	{
		name: 'solargraph',
		filetype: 'ruby',
		path: '/usr/local/bin/solargraph',
		args: ['stdio'],
		install: 'brew install solargraph',
	},

	{
		name: 'vim-language-server',
		filetype: 'vim',
		path: expand('~/.local/bin/vim-language-server'),
		args: ['--stdio'],
		install: 'npm install -g vim-language-server',
	},

	{
		name: 'vscode-json-language-server',
		filetype: ['json', 'jsonc'],
		path: expand('~/.local/bin/vscode-json-language-server'),
		args: ['--stdio'],
		workspaceConfig: {json: {
			format: {enable: true},
			validate: {enable: true},
			schemas: g:SchemaStore#Schemata(),
		}},
		install: 'npm install -g vscode-langservers-extracted',
	},

	{
		name: 'yaml-language-server',
		filetype: 'yaml',
		path: expand('~/.local/bin/yaml-language-server'),
		args: ['--stdio'],
		workspaceConfig: {yaml: {
			format: {enable: true, singleQuote: true},
			schemaStore: {enable: true, url: 'https://www.schemastore.org/api/json/catalog.json'},
		}},
		install: 'npm install -g yaml-language-server',
	},
]

const lspOptions = {
	aleSupport: true,
	ignoreMissingServer: true,
}

command! -nargs=* -complete=customlist,ListMissingServers -bar LspInstall Install(<f-args>)

def IsInstalled(server: dict<any>): bool
	return server->has_key('installed') ? server.installed() : executable(server.path) == 1
enddef

def InstalledServers(): list<dict<any>>
	return lspServers->deepcopy()->filter((_, server): bool => server->IsInstalled())
enddef

def MissingServers(): list<dict<any>>
	return lspServers->deepcopy()->filter((_, server): bool => !server->IsInstalled())
enddef

def ListMissingServers(argLead: string, cmdLine: string, cursorPos: number): list<string>
	return MissingServers()->mapnew((_, server): string => server.name)
enddef

export def Configure(): void
	# We have to use final rather than const because LspAddServer() assumes it can
	# modify the dicts it gets, rather than making a fresh copy to mess with.
	final installedServers = InstalledServers()
	if len(lspServers) != len(installedServers)
		# Since this code runs during Vim initialisation, this message would
		# normally pause Vim's startup so the user can read it. We don't want
		# that, so we're gonna delay it using an autocmd.
		const missingCount = len(lspServers) - len(installedServers)
		const warn = $'{missingCount} language server{missingCount > 1 ? "s are" : " is"} configured, but not installed. You may want to run :LspInstall.'
		augroup dot/vim/lsp.vim
			autocmd!
			exe $'autocmd VimEnter * ++once echo {strings.Quote(warn)}'
		augroup END
	endif

	g:lsp#lsp#AddServer(installedServers)
	g:lsp#options#OptionsSet(lspOptions)
enddef

export def Install(...serverNames: list<string>): void
	const missingServers = MissingServers()

	if empty(missingServers)
		echo $"All {len(lspServers)} configured language servers are already installed."
		return
	endif

	const serverNamesSet = strings.ToStringSet(serverNames)
	const serversToInstall = empty(serverNamesSet)
		? missingServers
		: missingServers->copy()->filter((_, server): bool => serverNamesSet->has_key(server.name))

	# The installScript runs every server's install command, regardless of
	# whether any fail in the process. The script's exit status is the number of
	# failed installations.
	const installScript = "failed=0\n" .. serversToInstall->copy()
		->map((_, server): string => $"\{ {server.install}; \} || failed=$((failed + 1))")
		->join("\n") ..  "\nexit $failed\n"

	const term = term_start('sh', {exit_cb: (job: job, status: number): void => {
		# If any installations failed, keep the terminal window open so we can
		# troubleshoot. If they all worked fine, close the terminal and reload the
		# LSP configuration.
		if status == 0
			execute 'bdelete' job->ch_getbufnr('out')
			Configure()
		endif
	}})

	# We prefer term_sendkeys() over sh -c because that will display each
	# command in the terminal as it's being executed, making it easier to
	# understand exactly what the install script is doing.
	term->term_sendkeys(installScript)
enddef
