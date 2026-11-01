#!/usr/bin/env -S nvim -l
local files, directory = {}, nil
for _, path in ipairs(arg) do
    path = vim.fn.fnamemodify(path, ":p")
    if vim.fn.isdirectory(path) == 1 then
        directory = directory or path
    else
        files[#files + 1] = path
    end
end
if #files == 0 then
    if directory then
        local result = vim.system({ "ya", "emit", "cd", directory }, { text = true }):wait()
        assert(result.code == 0, result.stderr)
    end
    return
end
local server = assert(vim.env.YAZI_NVIM_SERVER, "Missing parent Neovim server")
local channel = vim.fn.sockconnect("pipe", server, { rpc = true })
assert(channel > 0, "Cannot connect to parent Neovim")
local ok, err = pcall(vim.rpcrequest, channel, "nvim_exec_lua", "require('local_plugins.yazi').open(...)", { files })
vim.fn.chanclose(channel)
if not ok then
    error(err)
end
