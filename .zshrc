# jrod ZSHRC


# not an interactive shell? don't run rv or any other logic
# prevents my weird wrapper stuff breaking things
if [ -z "${PS1:-}" ]; then
    return
fi

# ssh agent floating socket to fix continuity issues with attaching/detaching multiplexers
if [ -n "$TMUX" ] || [ -n "$ZELLIJ" ]; then
    export $SSH_AUTH_SOCK=/tmp/{$USER}_ssh_auth_sock_floating
fi

# ensure we actually have oh-my-zsh installed
if [[ ! -d ~/.oh-my-zsh ]]; then;
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

export ZSH=~/.oh-my-zsh

# ensure plugins
# TODO: maybe a better way to do this
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then;
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

XDG_CONFIG_HOME="$HOME/.config/"

# Configuration Junk
ZSH_THEME="flazz"
export UPDATE_ZSH_DAYS=20
COMPLETION_WAITING_DOTS="true"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.scripts/bin:$PATH"

export LANG=en_US.UTF-8
export EDITOR="hx"
export HISTSIZE=100000
export TERM="xterm-256color" # fix 256 colour rendering
export COLORTERM=24bit
export HOMEBREW_NO_AUTO_UPDATE=1

# matplotlib
export MPLBACKEND="module://itermplot"
export ITERMPLOT=rv

. "$HOME/.cargo/env"

###############################
### handy aliases & related ###
###############################

alias showtime="python -m SimpleHTTPServer"
alias weather="curl wttr.in/philadelphia"
alias weatherserver="telnet rainmaker.wunderground.com"
alias heroute="telnet route-server.he.net"
alias attroute="telnet route-server.ip.att.net"
alias ports="lsof -n -i4TCP | grep LISTEN"
alias 🚒="echo "Stay 100, stay lit boys and girls"; halt -f"
alias l="lsd -lah"
alias ll="ls -lah"
alias ipinfo="curl ipinfo.io"
alias g="git"
$ ipi () { curl ipinfo.io/"$@"; }
alias hb="du -sh"
alias hba="du -sh *"
alias become="sudo -s -u"
alias whicos="cat /etc/*release*"
alias toptenproc="ps aux --sort=-pcpu | head -n11"
alias psa="ps axo user:20,pid,pcpu,pmem,vsz,rss,tty,stat,start,time,comm,command"
alias f="fzf --bind 'f1:become(nvim {1})'"
alias coa="conda activate"
alias cod="conda deactivate"
alias k="kubectl"
alias psa="ps axo user:20,pid,pcpu,pmem,vsz,rss,tty,stat,start,time,comm,command"
alias nixdirstat="duc index .; duc graph . -o - -f svg | rsvg-convert | imgcat"

alias cfggit='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


#############
### macOS ###
#############

if [ -d "/Volumes" ]; then #Check if we're running macOS
    export BYOBU_PREFIX=/usr/local # Fix byobu bindings
    # Handy Stuff
    alias netwatch="watch -n 1 ifconfig en4"
    alias proxmark="~/proxmark3/client/proxmark3 /dev/cu.usbmodem1421"
    alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

  if [ -d "/Applications/Visual\ Studio\ Code.app" ]; then
    function code() {
      "/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron" $1
    }
  fi

  # add wezterm to PATH for nvim and some command integration
  if [ -d "/Applications/WezTerm.app/Contents/MacOS/" ]; then
    export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS/"
  fi
fi

########################
### boilerplate shit ###
########################


#if [ $DISPLAY ] && [ -f ~/.Xresources ]; then
#    xrdb ~/.Xresources
#fi

if [ -x "$(command -v thefuck)" ]; then
    eval $(thefuck --alias)
fi

copydotfiles(){
    scp .zshrc .vimrc $1:~/
}

# tools needed
#
# ripgrep (rg)
# fd
# lsd
# zellij
# bat

hxs() {
	RG_PREFIX="rg -i --files-with-matches"
	local files
	files="$(
		FZF_DEFAULT_COMMAND_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --multi 3 --print0 --sort --preview="[[ ! -z {} ]] && rg --pretty --ignore-case --context 5 {q} {}" \
				--phony -i -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap" \
				--bind 'ctrl-a:select-all'
	)"
	[[ "$files" ]] && hx --vsplit $(echo $files | tr \\0 " ")
}

rf() {
  rg --smart-case $1 --line-number --no-heading | fzf -d ':' --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' --bind 'f1:become(nvim {1})'
}

# TODO: add f4 for vscode
# TODO: add p4 commands maybe?
fzfhelp="<F1> helix <F2> nvim <F3> gvim <F5> git log <F6> git diff"

function livegrep(){
  rg --line-number --no-heading --color=always --smart-case $1 |
    fzf -d ':' -n 1,3.. --ansi --no-sort --preview 'bat --color=always --highlight-line {2} {1}' --preview-window 'right:50%:+{2}+3/3,~3' \
    --bind 'f1:become(hx {1}:{2})' \
    --bind 'f2:become(nvim +{2} {1})' \
    --bind 'f3:execute(gvim +{2} {1} &)' \
    --bind 'f5:execute(git lg --color=always {1} | less -r)' \
    --bind 'f6:execute(git diff --color=always {1} | less -r)' \
    --border --border-label="$fzfhelp" --border-label-pos=-3:bottom
}

function livefind(){
  fd $1 | fzf --ansi --preview 'bat --color=always {1}' \
  --bind 'f1:become(hx {1})' \
  --bind 'f2:become(nvim {1})' \
  --bind 'f3:execute(gvim {1} &)' \
  --bind 'f5:execute(git lg --color=always {1} | less -r)' \
  --bind 'f6:execute(git diff --color=always {1} | less -r)'
}

fingerprint(){
  ssh-keyscan $1 | ssh-keygen -E md5 -l -f -
}

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        command rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        command rm -f "$cmd_file"
        return "$code"
    fi
}

export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
