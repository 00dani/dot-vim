vim9script

import '../tools/perl.vim'
import '../tools/strings.vim'

const lspServers = [
	{
		name: 'clojure-lsp',
		filetype: 'clojure',
		path: '/usr/local/bin/clojure-lsp',
		args: [],
		install: 'brew install clojure-lsp/brew/clojure-lsp-native',
	},

	{
		name: 'cue-lsp',
		filetype: 'cue',
		path: '/usr/local/bin/cue',
		args: ['lsp'],
		install: 'brew install cue-lang/tap/cue',
	},

	{
		name: 'dockerfile-langserver',
		filetype: 'dockerfile',
		path: expand('~/.local/bin/docker-langserver'),
		args: ['--stdio'],
		install: 'npm install -g dockerfile-language-server-nodejs',
	},

	{
		name: 'intelephense',
		filetype: 'php',
		path: expand('~/.local/bin/intelephense'),
		args: ['--stdio'],
		install: 'npm install -g intelephense',
	},

	{
		name: 'lua-language-server',
		filetype: 'lua',
		path: '/usr/local/bin/lua-language-server',
		args: [],
		install: 'brew install lua-language-server',
	},

	{
		name: 'marksman',
		filetype: 'markdown',
		path: '/usr/local/bin/marksman',
		args: ['server'],
		install: 'brew install marksman',
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
		name: 'PowerShellEditorServices',
		filetype: 'ps1',
		path: exepath('pwsh'),
		args: [
			'-NoLogo', '-NoProfile',
			'-Command', expand('~/.cache/powershell/PowerShellEditorServices/Start-EditorServices.ps1'),
			' -Stdio', '-SessionDetailsPath', expand('~/.cache/powershell/PowerShellEditorServices/session.json'),
		],
		installed: () => executable('pwsh') && filereadable(expand('~/.cache/powershell/PowerShellEditorServices/Start-EditorServices.ps1')),
		install: [
			'mkdir -p ~/.cache/powershell',
			'cd ~/.cache/powershell',
			'wget https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip',
			'unzip PowerShellEditorServices.zip',
			'rm PowerShellEditorServices.zip'
		]->join(' && ')
	},

	{
		name: 'pylsp',
		filetype: 'python',
		path: expand('~/.local/bin/pylsp'),
		args: [],
		install: 'pipx install python-lsp-server[all]',
	},

	{
		name: 'rust-analyzer',
		filetype: 'rust',
		path: expand('~/.local/share/cargo/bin/rust-analyzer'),
		args: [],
		install: 'rustup component add rust-analyzer',
	},

	{
		name: 'solargraph',
		filetype: 'ruby',
		path: '/usr/local/bin/solargraph',
		args: ['stdio'],
		install: 'brew install solargraph',
	},

	{
		name: 'taplo',
		filetype: 'toml',
		path: '/usr/local/bin/taplo',
		args: ['lsp', 'stdio'],
		install: 'brew install taplo',
	},

	{
		name: 'texlab',
		filetype: ['tex', 'plaintex', 'bib'],
		path: '/usr/local/bin/texlab',
		args: [],
		install: 'brew install texlab',
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
		name: 'typst-lsp',
		filetype: 'typst',
		path: exepath('typst-lsp'),
		initializationOptions: {
			exportPdf: 'onType',
		},
		install: 'cargo install typst-lsp',
	},

	{
		name: 'vim-language-server',
		filetype: 'vim',
		path: expand('~/.local/bin/vim-language-server'),
		args: ['--stdio'],
		install: 'npm install -g vim-language-server',
	},

	{
		name: 'vscode-css-language-server',
		filetype: ['css', 'less', 'sass', 'scss'],
		path: expand('~/.local/bin/vscode-css-language-server'),
		args: ['--stdio'],
		install: 'npm install -g vscode-langservers-extracted',
	},

	{
		name: 'vscode-html-language-server',
		filetype: 'html',
		path: expand('~/.local/bin/vscode-html-language-server'),
		args: ['--stdio'],
		install: 'npm install -g vscode-langservers-extracted',
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

def IsInstalled(server: dict<any>): bool
	return server->has_key('installed') ? server.installed() : executable(server.path) == 1
enddef

export def CountAll(): number
	return len(lspServers)
enddef

export def Installed(): list<dict<any>>
	return lspServers->deepcopy()->filter((_, server): bool => server->IsInstalled())
enddef

export def Missing(): list<dict<any>>
	return lspServers->deepcopy()->filter((_, server): bool => !server->IsInstalled())
enddef

export def Install(serverNames: list<string>, OnSuccess: func(list<dict<any>>)): void
	const missingServers = Missing()

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
			OnSuccess(serversToInstall)
		endif
	}})

	# We prefer term_sendkeys() over sh -c because that will display each
	# command in the terminal as it's being executed, making it easier to
	# understand exactly what the install script is doing.
	term->term_sendkeys(installScript)
enddef
