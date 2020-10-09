if [ ! -f "$HOME/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source $HOME/.zplug/init.zsh

zplug 'plugins/colored-man-pages', from:oh-my-zsh
zplug 'plugins/git', from:oh-my-zsh
zplug 'plugins/sudo', from:oh-my-zsh
zplug 'plugins/zsh-autosuggestions', from:oh-my-zsh
zplug 'plugins/zsh-syntax-highlighting', from:oh-my-zsh

zplug 'zsh-users/zsh-syntax-highlighting', defer:2

zplug 'halfo/lambda-mod-zsh-theme', as:theme

if ! zplug check; then
  zplug install
fi

export EDITOR='vim'

alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='ls --color=auto'
alias grep='grep --color'

zplug load
