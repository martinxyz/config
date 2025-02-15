if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path -P ~/scripts
    fish_add_path -P ~/bin

    alias ls "ls -rt --color=auto"
    alias l "exa -s modified"
    alias i git
    alias ... "cd ../.."
    alias .... "cd ../../.."
    alias ..... "cd ../../../.."
    alias ...... "cd ../../../../.."
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


    if test -d ~/.caldav-remind
       ~/scripts/calshow-rust/target/release/calshow
    end

    sleep 0.05  # reduces "first prompt sometimes empty" problem?
end

set -xg DOTNET_CLI_TELEMETRY_OPTOUT true
# set -xg FIREJAIL_FILE_COPY_LIMIT 5000

# set -xg PYENV_ROOT /home/martin/.pyenv
# fish_add_path -g /home/martin/.pyenv/bin
# pyenv init - --no-rehash | source

if test -d ~/.rye/shims
    set -xg fish_user_pathsu ~/.rye/shims
end

if test -d ~/compile/helix/runtime
    set -xg HELIX_RUNTIME ~/compile/helix/runtime
end

if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

