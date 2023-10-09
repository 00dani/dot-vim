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

export def LazyConfigure(): void
  autocmd VimEnter * ++once Configure()
enddef

export def Configure(): void
  g:LspAddServer(lspServers->deepcopy()->filter((_, server) => executable(server.path) == 1))
  g:LspOptionsSet(lspOptions)
enddef

export def Install(): void
  # TODO: work out a way nicer approach to automatically installing any
  # missing language servers. Maybe use a command or something.
  const missing = lspServers->copy()
    ->filter((_, server) => executable(server.path) == 0)
  const jobs = missing->copy()
    ->mapnew((_, server) => async#job#start(server.install, {normalize: 'raw'}))
  async#job#wait(jobs)
enddef
