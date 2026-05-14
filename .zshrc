# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d $ZINIT_HOME ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load direnv
eval "$(direnv hook zsh)"

# oh-my-posh shell prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light darvid/zsh-poetry

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::archlinux

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab-complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab-complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'
alias tm='tmux new-session -A -s main'
alias nv='nvim'
alias nvunity='nvimunity'
alias android-emulator='emulator -avd phone -skin 720x1280 -noaudio -no-snapshot-load -no-snapshot'

# Export PATHs
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm-global/bin
export PATH=$PATH:$HOME/.cache/.bun/bin
export ANDROID_AVD_HOME=$HOME/.android/avd
export PATH="$HOME/fvm/default/bin:$PATH"

# Pyenv support
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/saladin/.config/.dart-cli-completion/zsh-config.zsh ]] && . /home/saladin/.config/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

