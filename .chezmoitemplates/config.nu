# alias

alias vim = nvim
alias vi = nvim --clean
alias vo = nvim +Oil
alias hx = helix
alias j = just
alias che = chezmoi


def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# env
$env.EDITOR = "nvim"

# config
$env.config.history = {
  file_format: sqlite
  max_size: 10_000_000
  sync_on_enter: true
  isolation: false
}

$env.config.show_banner = false

$env.config.buffer_editor = "nvim"

$env.config.edit_mode = 'vi'
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

# starship config, zoxide configure after starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# modules
use std/clip copy
