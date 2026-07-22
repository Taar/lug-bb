HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTSIZESIZE=2000

shopt -s histappend
shopt -s checkwinsize

if [[ -f ~/.bash_aliases ]]; then
  source ~/.bash_aliases
fi

source /usr/share/bash-completion/bash_completion
