alias ls="lsd --group-dirs first"
alias ll='lsd -alF'
alias la='ls -A'
alias lls="ls -Alt modified"
alias treee='ls -alt --group-directories-first -I .git --tree --depth 4 -I .venv -I __pycache__ -I="*~"'

export PATH="~/.npm-global/bin:/usr/local/go/bin:~/.config/emacs/bin/:$PATH"
