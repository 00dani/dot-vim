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

autocmd VimEnter * ++once {
  # TODO: work out a way nicer approach to automatically installing any
  # missing language servers. Maybe use a command or something.
  const missing = lspServers->copy()
    ->filter((_, server) => !executable(server.path))
  const jobs = missing->copy()
    ->mapnew((_, server) => async#job#start(server.install, {normalize: 'raw'}))
  async#job#wait(jobs)
  # :call is required here because these functions from vim-lsp won't be
  # loaded yet when this file is parsed by Vim, so you get a "function not
  # found" error if you try to call them the short way.
  call LspAddServer(lspServers->deepcopy()->filter((_, server) => executable(server.path)))
  call LspOptionsSet(lspOptions)
}
