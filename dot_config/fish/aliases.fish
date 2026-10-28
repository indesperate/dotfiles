if command -q nvim
    alias vi 'nvim --clean'
    alias vim nvim
end

if command -q helix
    alias hx helix
end

if command -q just
    alias j just
end

if command -q chezmoi
    alias che chezmoi
end

if command -q zellij
    alias zj zellij
end

if command -q eza
    alias ls 'eza --icons=auto'
    alias ll 'eza -al --icons=auto'
    alias la 'eza -a --icons=auto'
    alias l 'eza -l --icons=auto'
end

if command -q bat
    alias cat bat
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end
