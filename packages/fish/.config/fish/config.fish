if status is-interactive
    fish_add_path ~/bin
    set EDITOR vim

    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) > /dev/null
    end
end
