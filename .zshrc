# - - - - - - - - - - - - - - - - - - - -
# Early Load
# - - - - - - - - - - - - - - - - - - - -

# Antidot modifies the environment, so it must be loaded first.
if command -v antidot &> /dev/null; then
    eval "$(antidot init)" # Load Antidot
fi

# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

# Install Functions.
export XDG_CONFIG_HOME="$HOME/.config"
export UPDATE_INTERVAL=15

# Load The Prompt System And Completion System And Initilize Them.
fpath+=($HOME/.zshrc)
autoload -Uz compinit promptinit

# Load And Initialize The Completion System Ignoring Insecure Directories With A
# Cache Time Of 20 Hours, So It Should Almost Always Regenerate The First Time A
# Shell Is Opened Each Day.
# See: https://gist.github.com/ctechols/ca1035271ad134841284
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst

# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors    # Load Colors.
unsetopt case_glob              # Use Case-Insensitve Globbing.
setopt globdots                 # Glob Dotfiles As Well.
setopt extendedglob             # Use Extended Globbing.
setopt autocd                   # Automatically Change Directory If A Directory Is Entered.
setopt interactive_comments     # Allow Comments In Interactive Mode.

# Smart URLs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General.
setopt brace_ccl                # Allow Brace Character Class List Expansion.
setopt combining_chars          # Combine Zero-Length Punctuation Characters ( Accents ) With The Base Character.
setopt rc_quotes                # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning           # Don't Print A Warning Message If A Mail File Has Been Accessed.

# Jobs.
setopt long_list_jobs           # List Jobs In The Long Format By Default.
setopt auto_resume              # Attempt To Resume Existing Job Before Creating A New Process.
setopt notify                   # Report Status Of Background Jobs Immediately.
unsetopt bg_nice                # Don't Run All Background Jobs At A Lower Priority.
unsetopt hup                    # Don't Kill Jobs On Shell Exit.
unsetopt check_jobs             # Don't Report On Jobs When Shell Exit.

setopt correct                  # Turn On Corrections

# Completion Options.
setopt complete_in_word         # Complete From Both Ends Of A Word.
setopt always_to_end            # Move Cursor To The End Of A Completed Word.
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_menu                # Show Completion Menu On A Successive Tab Press.
setopt auto_list                # Automatically List Choices On Ambiguous Completion.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.
setopt no_complete_aliases

setopt menu_complete            # Do Not Autoselect The First Completion Entry.
unsetopt flow_control           # Disable Start/Stop Characters In Shell Editor.

# Zstyle.
zstyle ':completion:*:*:*:*:*' menu select interactive
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

# History.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=5000
setopt appendhistory notify
unsetopt beep nomatch

setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt share_history            # Share History Between All Sessions.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt extended_history         # Show Timestamp In History.

# rm.
unsetopt rm_star_silent         # Don't Remove Files Without Confirmation.
setopt rm_star_wait             # Wait For Confirmation Before Removing Files.

# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

# Provide A Simple Prompt Till The Theme Loads
PS1="READY >"

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as'command' from'gh-r' \
    atclone'./starship init zsh > init.zsh; ./starship completions zsh > _starship' \
    atpull'%atclone' src'init.zsh'
zinit light starship/starship

# - - - - - - - - - - - - - - - - - - - -
# Plugins
# - - - - - - - - - - - - - - - - - - - -

# Load Syntax Highlighting with catppuccin theme
zinit ice atload'fast-theme -q XDG:catppuccin-mocha'
zinit light zdharma-continuum/fast-syntax-highlighting

# Load Colorize
zinit light zpm-zsh/colors
zinit light zpm-zsh/colorize

# Load Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Load Better Yarn Completions
zinit ice atload'compdef _yarn_completion yarn' #TODO: this is stupid. why do i need to do this? >:(
zinit light chrisands/zsh-yarn-completions

# Load LS_COLORS
zinit ice atclone'dircolors -b LS_COLORS > clrs.zsh' \
    atpull'%atclone' pick'clrs.zsh' nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS

# Load History Substring Search
zinit ice atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

# Load ZSH-Completions. Recommended to be loaded last.
zinit ice wait blockf lucid atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

# - - - - - - - - - - - - - - - - - - - -
# User Configuration
# - - - - - - - - - - - - - - - - - - - -

setopt no_beep # Disable beep

bindkey '^[[1;5C' forward-word  # [Ctrl]+[RightArrow]: Forward word
bindkey '^[[1;5D' backward-word # [Ctrl]+[LeftArrow]: Backward word
bindkey '^[[3~' delete-char     # [Delete]: Delete char

alias rm='rm -vI'                                                              # Verbose, Interactive

path+=($HOME/.local/bin)                                                       # Add local bin to PATH

if command -v eza &> /dev/null; then
    alias ls='eza --icons --color=auto --group-directories-first --classify --git' # Use eza as ls
    alias tree='ls --tree'                                                         # Use eza as tree
fi

if command -v bat &> /dev/null; then
    if [[ ! -d $HOME/.cache/bat ]]; then
        bat cache --build
    fi

    export BAT_THEME='Catppuccin Mocha'
    export MANPAGER='sh -c "col -bx | bat -l man -p"'
    export MANROFFOPT='-c'

    alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'         # Use bat for help
    alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

    alias -g cat='bat --paging=never --style=plain'                         # Use bat as cat
    alias -g less='bat --paging=always --style=plain'                       # Use bat as less

    tail() {
        command tail $@ | bat --paging=never --style=plain -l log        # Use bat as tail
    }
fi

if command -v gh &> /dev/null && gh copilot &> /dev/null; then
    alias '??'='gh copilot suggest'
    alias '?!'='gh copilot explain'
fi

if command -v nvim &> /dev/null; then
    alias vim='nvim'
    export EDITOR='nvim'
fi

if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

if [[ "$TERM" == "xterm-kitty" ]]; then
    alias ssh='kitty +kitten ssh'
fi

# foreach piece (
#     exports.zsh
#     node.zsh
#     aliases.zsh
#     functions.zsh
# ) {
#     . $ZSH/config/$piece
# }
# TODO: Use this instead of having everything in this file
