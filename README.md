# Personal dotfiles

Managed with [mise](https://mise.jdx.dev/).

## Setup

Preserve any existing `~/.config/mise` and move it aside first.

```sh
mise bootstrap --from https://github.com/indesperate/dotfiles.git --from-dir ~/.dotfiles --config-dir mise --skip dotfiles
```

Set machine-local values in `~/.config/mise/config.local.toml` (Git-ignored):

```toml
[vars]
git_name = "Your Name"
git_email = "you@example.com"
ssh_hostname = "your-server"
ssh_user = "your-user"
```

## Groups

All groups apply by default: `common`, `nvim`, and `pi`.
Select groups in `~/.config/mise/config.local.toml`:

```toml
[bootstrap]
dotfile_groups = ["nvim", "pi"]
```

## Apply

Preview: `mise dot diff` · Apply: `mise dot apply` — from any directory.

Update and apply:

```sh
git -C ~/.dotfiles pull --ff-only && mise dot apply
```
