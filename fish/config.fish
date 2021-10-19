if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path -P ~/scripts
    fish_add_path -P ~/bin

    alias ls "ls -rt --color=auto"
    alias l "exa -s modified"
    alias i git
    abbr -a -- - 'cd -'

    set -xg EDITOR nvim
    set -xg VISUAL nvim
    set -xg LESS '-R'

    zoxide init fish | source

    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    set -xg LD_LIBRARY_PATH /home/martin/.local/lib
end
