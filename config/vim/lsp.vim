vim9script

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
]

const lspOptions = {
  aleSupport: true,
}

command! -nargs=0 -bar LspInstall Install()

def InstalledServers(): list<dict<any>>
  return lspServers->deepcopy()->filter((_, server): bool => executable(server.path) == 1)
enddef

def MissingServers(): list<dict<any>>
  return lspServers->deepcopy()->filter((_, server): bool => executable(server.path) == 0)
enddef

export def LazyConfigure(): void
  autocmd VimEnter * ++once Configure()
enddef

export def Configure(): void
  final installedServers = InstalledServers()
  if len(lspServers) != len(installedServers)
    echo $'{len(lspServers) - len(installedServers)} language servers are configured, but not installed. You may want to run :LspInstall.'
  endif
  g:LspAddServer(installedServers)
  g:LspOptionsSet(lspOptions)
enddef

export def Install(): void
  const missingServers = MissingServers()
  if empty(missingServers)
    echo $"All {len(lspServers)} configured language servers are already installed."
    return
  endif

  # The installScript runs every missing server's install command, regardless
  # of whether any fail in the process. The script's exit status is the number
  # of failed installations.
  const installScript = "failed=0\n" .. missingServers->copy()
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

