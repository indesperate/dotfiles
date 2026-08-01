# Only initialize once in the current Bash process.
if [[ ${BASH_INIT_TOOLS:-0} == 1 ]]; then
    return 0
fi

BASH_INIT_TOOLS=1

# Starship should initialize first so it can save the original command status.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

history_update() {
    history -a
}

# PROMPT_COMMAND may be either a string or an array.
if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == "declare -a"* ]]; then
    PROMPT_COMMAND+=("history_update")
else
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history_update"
fi

eval "$(zoxide init bash)"
eval "$(fzf --bash)"
eval "$(mise activate bash)"
