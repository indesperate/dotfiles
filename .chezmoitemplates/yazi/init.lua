require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

require("git-search"):setup()

require("session"):setup({
	sync_yanked = true,
})
