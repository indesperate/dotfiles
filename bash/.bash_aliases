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
# use win32yank.exe
# ln -s /mnt/c/Users/fadei/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code .
# ln -s /mnt/c/Windows/explorer.exe ii
# ln -s /mnt/c/Windows/System32/clip.exe .
