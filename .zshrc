# Load zsh integrations
[[ -x "$(command -v antidot)" ]] && eval "$(antidot init)"
[[ -x "$(command -v fnm)" ]] && eval "$(fnm env --use-on-cd)"
[[ -x "$(command -v fzf)" ]] && eval "$(fzf --zsh)"
[[ -x "$(command -v zoxide)" ]] && eval "$(zoxide init zsh --cmd=cd)"

# Set the directory we want to store zinit and plugins in
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit, if it's not already installed
if [[ ! -d "${ZINIT_HOME}" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Load basic plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Use fzf for tab completion
zinit light aloxaf/fzf-tab

# Colorize a bunch of commands
zinit pack for ls_colors
zinit light zpm-zsh/colors
zinit light zpm-zsh/colorize

# Better yarn completions
zinit light chrisands/zsh-yarn-completions

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word  # [Ctrl]+[RightArrow]: Forward word
bindkey '^[[1;5D' backward-word # [Ctrl]+[LeftArrow]: Backward word
bindkey '^[[3~' delete-char     # [Delete]: Delete char

# History
HISTSIZE=5000
HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
# Append to history file
setopt appendhistory
# Share history between sessions
setopt sharehistory
# Ignore duplicates
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
mkdir -p "$(dirname $HISTFILE)"

# Make rm safer
unsetopt rm_star_silent
setopt rm_star_wait
alias rm='rm -vI'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --icons --group-directories-first --color=always --git --oneline --all $realpath'

# Use bat if available
if [[ -x "$(command -v bat)" ]]; then
  # Build bat cache if it doesn't exist
  if [[ ! -d $HOME/.cache/bat ]]; then
    bat cache --build
  fi

  # Set bat theme
  export BAT_THEME='Catppuccin Mocha'
  export BATDIFF_USE_DELTA=true

  # Use bat for a bunch of commands
  alias -- 'cat'='bat --paging=never --style=plain'
  [[ -x "$(command -v batgrep)" ]] && alias -- 'ripgrep'='batgrep'
  [[ -x "$(command -v batman)" ]] && alias -- 'man'='batman'
  [[ -x "$(command -v batwatch)" ]] && alias -- 'watch'='batwatch'
  [[ -x "$(command -v batdiff)" ]] && alias -- 'diff'='batdiff'

  # Use bat for help
  alias -g -- '-h'='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- '--help'='--help 2>&1 | bat --language=help --style=plain'
fi

# Use exa if available
if [[ -x "$(command -v exa)" ]]; then
  alias -- 'ls'='exa --icons --group-directories-first --color=always --git'
  alias -- 'tree'='ls --tree'
fi

# Use gh copilot if available
if [[ -x "$(command -v gh)" && "$(gh copilot --version)" ]]; then
  alias -- '??'='gh copilot suggest'
  alias -- '?!'='gh copilot explain'
fi

# Use kitty if available
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias -- 'ssh'='kitty +kitten ssh'
fi

# Use rsync if available
if [[ -x "$(command -v rsync)" ]]; then
  alias -- 'cp'='rsync -ah --info=progress2 --inplace --no-whole-file'
  alias -- 'mv'='rsync -ah --info=progress2 --inplace --no-whole-file --remove-source-files'
fi

# Use trash-cli if available
if [[ -x "$(command -v trash)" ]]; then
  unalias rm

  alias -- 'rm'='trash'
fi

# Use nvim if available
if [[ -x "$(command -v nvim)" ]]; then
  export EDITOR='nvim'

  alias -- 'vim'='nvim'
fi
