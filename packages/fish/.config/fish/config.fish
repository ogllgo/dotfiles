if status is-interactive
    set EDITOR vim

    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) > /dev/null
    end

    # PATH modifications
    if test (uname) = Darwin
        fish_add_path "/opt/homebrew/bin"
    end
    fish_add_path "~/.cargo/bin"
    fish_add_path "~/bin"
end
