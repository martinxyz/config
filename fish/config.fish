if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path -P ~/scripts
    fish_add_path -P ~/bin

    alias ls "ls -rt --color=auto"
    alias i git

    set -xg EDITOR nvim
    set -xg VISUAL nvim
    set -xg LESS '-R'
end
