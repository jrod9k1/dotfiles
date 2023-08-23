# jrod ZSHRC

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

# Configuration Junk
ZSH_THEME="flazz"
export UPDATE_ZSH_DAYS=20
COMPLETION_WAITING_DOTS="true"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.scripts/bin:$PATH"

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
alias cent7tools="scl enable evtoolset-7 $SHELL"

alias cfggit='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export EDITOR="hx"

#############
### macOS ###
#############

if [ -d "/Volumes" ]; then #Check if we're running macOS
    # Fixes
    alias mtr="sudo /usr/local/Cellar/mtr/0.87/sbin/mtr" # Fix brew mtr install
    export BYOBU_PREFIX=/usr/local # Fix byobu bindings
    # Handy Stuff
    alias netwatch="watch -n 1 ifconfig en4"
    alias proxmark="~/proxmark3/client/proxmark3 /dev/cu.usbmodem1421"
fi

########################
### boilerplate shit ###
########################

export TERM="xterm-256color" # fix 256 colour rendering

if [ $DISPLAY ] && [ -f ~/.Xresources ]; then
    xrdb ~/.Xresources
fi

if [ -x "$(command -v thefuck)" ]; then
    eval $(thefuck --alias)
fi

copydotfiles(){
    scp .zshrc .vimrc $1:~/
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jrod/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jrod/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jrod/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jrod/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
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

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
