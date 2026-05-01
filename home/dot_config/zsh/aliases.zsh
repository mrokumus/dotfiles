# System #
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'

alias c='clear'
alias e='exit'
alias ..="cd .."
alias cd..="cd .."

alias vim="nvim"
alias ls="eza -al -h --git --group-directories-last --color=always"
alias lt="eza --all -T --color=always --group-directories-first"

# Git #
alias gaa="git add ."
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gst="git status -s"
alias gps="git push"
alias gpl="git pull --rebase"
alias gch="git checkout"
alias gsh="git stash"
alias gdf="git diff"
alias gbd="git branch -D"

alias tmux="tmux -f ~/.config/tmux/tmux.conf"
