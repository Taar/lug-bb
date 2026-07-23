HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTSIZESIZE=2000

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

shopt -s histappend
shopt -s checkwinsize

if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [[ -f ~/.bash_aliases ]]; then
  source ~/.bash_aliases
fi

source /usr/share/bash-completion/bash_completion
