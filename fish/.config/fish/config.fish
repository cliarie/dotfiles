set --export LDFLAGS "-L/opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/14"
set --export STAPL_ROOT /Users/clairechen/stapl
set --export BOOST_ROOT /opt/homebrew/Cellar/boost@1.76/1.76.0_6
set --export STL_PATH /opt/homebrew/Cellar/gcc/14.2.0_1/lib/gcc/14

fish_add_path /usr/local/bin
fish_add_path ~/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/node@20/bin

fish_vi_key_bindings

set fish_greeting

function finder
	open -a finder $argv
end

zoxide init fish | source
fzf --fish | source
starship init fish | source

set -g fish_greeting "hi claire <3"
set -gx PATH /opt/homebrew/opt/trash-cli/bin $PATH

alias ls='eza --icons -F -H --group-directories-first --git'
alias cat bat
alias v nvim
alias cd z
alias t tmux
alias wez='wezterm cli'
alias rm trash
alias config='/usr/bin/git --git-dir=/Users/gavinwang/.cfg/ --work-tree=/Users/gavinwang/.config'

# option l to search git log
fzf_configure_bindings --git_log=\cg --git_status=\cs --directory=\cf --processes=\cp --variables=\cv

if status is-interactive
    # Commands to run in interactive sessions can go here
end

