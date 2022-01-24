Me dotfiles

# How to initialize

`git clone --bare git@git.globius.org:jrod/dotfiles.git $HOME/.cfg; git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`

### Then if using ZSH you can restart shell or source to init

`source .zshrc`
