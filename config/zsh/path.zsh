# PATH configuration
# typeset -U ensures no duplicate entries
typeset -U path

export GOPATH=$HOME/.go

path=(
    $HOME/.local/bin
    $HOME/bin
    /usr/local/heroku/bin
    /usr/local/bin
    $GOPATH/bin
    /usr/local/opt/go/libexec/bin
    $HOME/.poetry/bin
    $path
)

# Import server-specific PATH settings
if [ -f ~/.zshrc.path ]; then
    source ~/.zshrc.path
fi
