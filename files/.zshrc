
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/var/lib/snapd/snap/bin:/home/siffer/.local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(z.lua fast-syntax-highlighting git you-should-use)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export Editor='nvim'
export ARCHFLAGS="-arch x86_64"
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v


# My stuff

source /home/siffer/.dotfiles/files/scripts/live.sh
export PATH=/home/siffer/.dotfiles/files/bin:$PATH

#Aliases

alias vim="nvim"
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias xmonadr="xmonad --recompile && xmonad --restart"
alias icat="kitty +kitten icat"
alias gc="g++ main.cpp"
alias zshrc="vim ~/.zshrc"
alias s.zshrc="source ~/.zshrc"
alias dk="setxkbmap dk"
alias p3="python3"
alias copy="xclip -selection clipboard"
alias x="startx"
alias clearC="clear && colorscript -r"
alias shut="shutdown 0"
#git
alias ginit="git init"
alias gitcm="git commit -m"
alias gitps="git push -u origin"
alias gitpl="git pull origin"
alias gitad="git add -A"


colorscript -r

