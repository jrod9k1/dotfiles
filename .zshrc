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

export LANG=en_US.UTF-8
export EDITOR="hx"
export HISTSIZE=100000
export TERM="xterm-256color" # fix 256 colour rendering
export COLORTERM=24bit

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

alias cfggit='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


#############
### macOS ###
#############

if [ -d "/Volumes" ]; then #Check if we're running macOS
    export BYOBU_PREFIX=/usr/local # Fix byobu bindings
    # Handy Stuff
    alias netwatch="watch -n 1 ifconfig en4"
    alias proxmark="~/proxmark3/client/proxmark3 /dev/cu.usbmodem1421"
fi

########################
### boilerplate shit ###
########################


if [ $DISPLAY ] && [ -f ~/.Xresources ]; then
    xrdb ~/.Xresources
fi

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

fingerprint(){
  ssh-keyscan $1 | ssh-keygen -E md5 -l -f -
}

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
