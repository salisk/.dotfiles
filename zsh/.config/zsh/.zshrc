# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable en_US locale w/ UTF-8 encodings if not already configured
export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_ALL="${LANG}"

# ====== ZSH Specific variables =========
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
# Store ZSH files under XDG_CONFIG_HOME base directory.
export HISTFILE=$ZSH_CACHE_DIR/.zsh_history

HISTSIZE=10000000
SAVEHIST=10000000
ZSH_PLUGINS=$ZDOTDIR/custom/plugins

# Set Option
setopt SHARE_HISTORY
# setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Enable vi mode
bindkey -v

# Force re-completion
autoload -U compinit && compinit -d $ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
# compinit
_comp_options+=(globdots)

# Colors
autoload -Uz colors && colors

# Set the theme
# ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZDOTDIR/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

### Completions

# Zsh completions
fpath=($ZSH_PLUGINS/zsh-completions/src $fpath)
source $ZSH_PLUGINS/zsh-completions/zsh-completions.plugin.zsh

# Kubectl
source $ZSH_PLUGINS/kubectl/kubectl.plugin.zsh
compdef __start_kubectl k

### Plugins

[[ "$OSTYPE" == "darwin"* ]] && source $ZSH_PLUGINS/macos/macos.plugin.zsh
source $ZSH_PLUGINS/docker/_docker
source $ZSH_PLUGINS/iterm2/iterm2.plugin.zsh
source $ZSH_PLUGINS/autojump/autojump.plugin.zsh
source $ZSH_PLUGINS/git/git.plugin.zsh
#source $ZSH_PLUGINS/zsh-vi-mode/zsh-vi-mode.plugin.zsh  # doesn't work with history substring search
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh

# plugins=()
# plugins+=(zsh-syntax-highlighting)
plugins+=(git-flow git-extras)                  # Git
plugins+=(golang gnu-utils)
# plugins+=(pip)                                  # Python stuff
plugins+=(docker docker-compose)                # Docker stuff
# plugins+=(kubectl minikube)                     # Kubernetes stuff
# [[ "$OSTYPE" == "darwin"* ]] && plugins+=(osx)  # Mac OS

# #__________________
# # - Custom plugins: '$ZSH_CUSTOM/plugins/*' i.e. ~/config./zsh/custom/plugins/
# #
# plugins+=(zsh-autosuggestions zsh-completions)

# Aliases
source ~/.config/zsh/.zsh_aliases

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/go:$PATH"
  export GOPROXY="https://us-central1-go.pkg.dev/cicd-master-oxk5/go-modules,https://proxy.golang.org,direct"
  export GONOSUMDB="github.com/castai/*,gitlab.com/castai/*"
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
else 
  export TERMINAL=alacritty
  export GOROOT=/usr/local/go
  export GOPATH=$HOME/go
  export PATH="/snap/bin:$PATH"
fi

# Force re-completion
autoload -U compinit && compinit -d $ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

#export TERM="xterm-256color"

#export PATH="/usr/local/opt/qt/bin:$PATH"
#export PATH="/usr/local/opt/libiconv/bin:$PATH"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:`go env GOPATH`/bin
export PATH="/usr/local/sbin:$PATH"

# export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"

# bindkey "^[[A" history-substring-search-up
# bindkey "^[OA" history-substring-search-up
# bindkey "^[[B" history-substring-search-down
# bindkey "^[OB" history-substring-search-down

eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"

# Vinted
[ -f "${DEVTOOLS_PATH:-$HOME/vinted/dev-tools}/bin/shell_function.sh" ] && source "${DEVTOOLS_PATH:-$HOME/vinted/dev-tools}/bin/shell_function.sh"

# if [[ "$OSTYPE" != "darwin"* ]]; then
#     source ~/.nix-profile/etc/profile.d/nix.sh
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
