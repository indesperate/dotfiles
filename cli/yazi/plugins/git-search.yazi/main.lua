local function status(xy)
	if xy == "!!" then
		return "ignored"
	elseif xy == "??" then
		return "untracked"
	elseif xy:find("U") or xy == "AA" or xy == "DD" then
		return "updated"
	elseif xy:find("D") then
		return "deleted"
	elseif xy:sub(2, 2):find("[MT]") then
		return "unstaged"
	elseif xy:sub(1, 1):find("[AC]") then
		return "added"
	else
		return "staged"
	end
end

local save = ya.sync(function(st, badges)
	st.badges = st.badges or {}
	for url, badge in pairs(badges) do
		st.badges[url] = badge
	end
	ui.render()
end)

local function setup(st)
	st.badges = {}
	Linemode:children_add(function(self)
		local file = self._file
		if not file.in_current or not file.url.spec.is_search then
			return ""
		end

		local badge = st.badges[tostring(file.url)]
		local theme = th.git or {}
		local sign = badge and theme[badge .. "_sign"] or ""
		if not sign or sign == "" then
			return ""
		elseif file.is_hovered then
			return ui.Line({ " ", sign })
		else
			return ui.Line({ " ", ui.Span(sign):style(theme[badge] or ui.Style()) })
		end
	end, 1500)
end

local function fetch(_, job)
	local first = job.files[1].url
	if not first.spec.is_search then
		return require("git"):fetch(job)
	end

	local cwd = first.base or first.parent
	local root = Command("git"):cwd(tostring(cwd.path)):arg({ "rev-parse", "--show-toplevel" }):output()
	if not root or not root.status.success then
		return require("noop"):fetch(job)
	end
	local repo = Url(root.stdout:gsub("[\r\n]+$", ""))

	local args = {
		"--no-optional-locks",
		"status",
		"--porcelain=v1",
		"-z",
		"--untracked-files=normal",
		"--no-renames",
		"--ignored=matching",
		"--",
	}
	for _, file in ipairs(job.files) do
		args[#args + 1] = tostring(file.url.path)
	end
	local output = Command("git"):cwd(tostring(repo)):arg(args):output()
	if not output or not output.status.success then
		return require("noop"):fetch(job)
	end

	local changed = {}
	for record in output.stdout:gmatch("([^%z]+)%z") do
		changed[tostring(repo:join(record:sub(4)))] = status(record:sub(1, 2))
	end

	local badges = {}
	for _, file in ipairs(job.files) do
		badges[tostring(file.url)] = changed[tostring(file.url.path)] or "clean"
	end
	save(badges)

	return ya.co(function()
		for _, file in ipairs(job.files) do
			coroutine.yield(file, { retry = true })
		end
	end)
end

return { setup = setup, fetch = fetch }
