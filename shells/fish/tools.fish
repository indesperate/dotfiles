# Initialize Starship before other prompt hooks so it captures command status.
if command -q starship
    starship init fish | source
end

if command -q zoxide
    zoxide init fish | source
end

if command -q fzf
    fzf --fish | source
end

if command -q mise
    mise activate fish | source
end
