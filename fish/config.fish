fish_add_path /usr/local/bin
fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

fish_vi_key_bindings

set fish_greeting

zoxide init fish | source
starship init fish | source

set -g fish_greeting "hi claire <3"

alias ls='eza --icons -F -H --group-directories-first --git'
alias v nvim
alias cd z
alias t tmux
alias rm trash

# option l to search git log
fzf_configure_bindings --git_log=\cg --git_status=\cs --directory=\cf --processes=\cp --variables=\cv

if status is-interactive
    # Commands to run in interactive sessions can go here
end
