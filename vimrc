vim9script
const xdg = {
  XDG_CONFIG_HOME: '~/.config',
  XDG_CACHE_HOME: '~/.cache',
  XDG_DATA_HOME: '~/.local/share',
  XDG_STATE_HOME: '~/.local/state',
}
for [key, default] in items(xdg)
  if !has_key(environ(), key)
    setenv(key, expand(default))
  endif
endfor

set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$XDG_CONFIG_HOME/vim/after,$XDG_CACHE_HOME/vim/after
set viminfo+=n$XDG_STATE_HOME/vim/viminfo
if exists('+packpath')
  set packpath^=$XDG_CONFIG_HOME/vim,$XDG_CACHE_HOME/vim
endif
g:netrw_home = $XDG_CACHE_HOME .. '/vim/netrw'

$MYVIMRC = $XDG_CONFIG_HOME .. '/vim/init.vim'
source $MYVIMRC
