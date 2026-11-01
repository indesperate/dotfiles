#!/usr/bin/env bash
set -euo pipefail

for dependency in git tmux; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$dependency" >&2
        exit 1
    fi
done

plugins_directory="$HOME/.config/tmux/plugins"
tpm_directory="$plugins_directory/tpm"

if [[ -e "$tpm_directory" || -L "$tpm_directory" ]]; then
    if [[ ! -d "$tpm_directory/.git" ]]; then
        printf 'Refusing to overwrite an existing non-checkout: %s\n' "$tpm_directory" >&2
        exit 1
    fi
    printf 'TPM already exists at %s\n' "$tpm_directory"
else
    mkdir -p "$plugins_directory"
    git clone -- https://github.com/tmux-plugins/tpm.git "$tpm_directory"
fi

printf '%s\n' \
    'TPM is ready. In a running tmux session, reload your config:' \
    '  tmux source-file ~/.config/tmux/tmux.conf' \
    'Then press Ctrl+a, followed by uppercase I, to install configured plugins.'
