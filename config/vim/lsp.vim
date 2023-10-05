vim9script

final lspServers = [
  {
    name: 'dockerfile-langserver',
    filetype: 'dockerfile',
    path: expand('~/.local/bin/docker-langserver'),
    args: ['--stdio'],
    install: 'npm install -g dockerfile-language-server-nodejs',
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
    install: 'curl -Lo phpactor https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar && chmod u+x phpactor && mv phpactor ~/bin'
  },

  {
    name: 'pylsp',
    filetype: 'python',
    path: '/usr/local/bin/pylsp',
    args: [],
    install: 'brew install python-lsp-server',
  },

  {
    name: 'vim-language-server',
    filetype: 'vim',
    path: expand('~/.local/bin/vim-language-server'),
    args: ['--stdio'],
    install: 'npm install -g vim-language-server',
  },
]

final lspOptions = {
  aleSupport: true,
}

autocmd VimEnter * ++once {
  # :call is required here because these functions from vim-lsp won't be
  # loaded yet when this file is parsed by Vim, so you get a "function not
  # found" error if you try to call them the short way.
  call LspAddServer(lspServers)
  call LspOptionsSet(lspOptions)
}
