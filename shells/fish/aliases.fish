if command -q nvim
    abbr --add vi 'nvim --clean'
    abbr --add vim nvim
end

if command -q git
    abbr --add g git
end

if command -q lazygit
    abbr --add lg lazygit
end

if command -q mise
    abbr --add md 'mise dot'
end

if command -q just
    abbr --add j just
end

if command -q zellij
    abbr --add zj zellij
end

if command -q tuicr
    abbr --add cr tuicr
end

if command -q eza
    abbr --add ls 'eza --icons=auto'
    abbr --add ll 'eza -al --icons=auto'
    abbr --add la 'eza -a --icons=auto'
    abbr --add l 'eza -l --icons=auto'
end

if command -q bat
    abbr --add cat bat
end

abbr --add .. 'cd ..'

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end
