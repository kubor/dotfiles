PATH=/usr/local/bin/:/Users/Ryuichi/bin:$PATH
export PATH
if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi
alias ls='gls --color=auto'
eval $(gdircolors /Users/Ryuichi/dircolors-solarized/dircolors.ansi-universal)
