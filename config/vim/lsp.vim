vim9script

const lspServers = [
  {
    name: 'dockerfile-langserver',
    filetype: 'dockerfile',
    path: expand('~/.local/bin/docker-langserver'),
    args: ['--stdio'],
    install: ['npm', 'install', '-g', 'dockerfile-language-server-nodejs'],
  },

  {
    name: 'lua-language-server',
    filetype: 'lua',
    path: '/usr/local/bin/lua-language-server',
    args: [],
    install: ['brew', 'install', 'lua-language-server'],
  },

  {
    name: 'tilt-lsp',
    filetype: 'bzl',
    path: '/usr/local/bin/tilt',
    args: ['lsp', 'start'],
    install: ['brew', 'install', 'tilt'],
  },

  {
    name: 'typescript-language-server',
    filetype: ['javascript', 'typescript'],
    path: '/usr/local/bin/typescript-language-server',
    args: ['--stdio'],
    install: ['brew', 'install', 'typescript-language-server'],
  },

  {
    name: 'phpactor',
    filetype: 'php',
    path: expand('~/bin/phpactor'),
    args: ['language-server'],
    initializationOptions: {
      'language_server_configuration.auto_config': false,
    },
    install: ['bash', '-c', 'curl -Lo phpactor https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar && chmod u+x phpactor && mv phpactor ~/bin'],
  },

  {
    name: 'pylsp',
    filetype: 'python',
    path: '/usr/local/bin/pylsp',
    args: [],
    install: ['brew', 'install', 'python-lsp-server'],
  },

  {
    name: 'solargraph',
    filetype: 'ruby',
    path: '/usr/local/bin/solargraph',
    args: ['stdio'],
    install: ['brew', 'install', 'solargraph'],
  },

  {
    name: 'vim-language-server',
    filetype: 'vim',
    path: expand('~/.local/bin/vim-language-server'),
    args: ['--stdio'],
    install: ['npm', 'install', '-g', 'vim-language-server'],
  },
]

const lspOptions = {
  aleSupport: true,
}

command! -nargs=0 -bar LspInstall Install()

export def LazyConfigure(): void
  autocmd VimEnter * ++once Configure()
enddef

export def Configure(): void
  final installedServers = lspServers->deepcopy()->filter((_, server) => executable(server.path) == 1)
  if len(lspServers) != len(installedServers)
    echo (len(lspServers) - len(installedServers)) "language servers are configured, but not installed. You may want to run :LspInstall."
  endif
  g:LspAddServer(installedServers)
  g:LspOptionsSet(lspOptions)
enddef

export def Install(): void
  # TODO: running all installations in parallel doesn't work super well,
  # because some package managers use an exclusive lock while they're running.
  # Plus you don't get feedback on installation progress. Perhaps use
  # term_start() instead, so installs run in series and are visible on screen?
  const missing = lspServers->copy()
    ->filter((_, server) => executable(server.path) == 0)
  const jobs = missing->copy()
    ->mapnew((_, server) => async#job#start(server.install, {normalize: 'raw'}))
  async#job#wait(jobs)
enddef
