if [ "$(command -v nvim)" ]; then
	alias vi=nvim
	alias vim=nvim
fi
if [ "$(command -v fdfind)" ]; then
	alias fd=fdfind
fi
if [ "$(command -v batcat)" ]; then
	alias bat=batcat
fi
if [ "$(command -v exa)" ]; then
	alias ls='exa'
	alias ll='exa -al'
	alias la='exa -a'
	alias l='exa -l'
fi
if [ -v WSL_DISTRO_NAME ]; then
	alias ii='/mnt/c/Windows/explorer.exe'
	alias clip='/mnt/c/Windows/system32/clip.exe'
	alias code="/mnt/c/Users/fadei/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
	alias copy="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command gcb"
fi
