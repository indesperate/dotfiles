local M = {}
local terminal, origin

local function hide()
    if terminal and terminal:valid() then
        vim.cmd.stopinsert()
        terminal:hide()
        if origin and vim.api.nvim_win_is_valid(origin) then
            vim.api.nvim_set_current_win(origin)
        end
    end
end

function M.open(files)
    if #files == 0 then
        return
    end
    hide()
    vim.cmd.edit({ args = { files[1] } })
    for i = 2, #files do
        vim.fn.bufadd(files[i])
    end
end

function M.toggle(path)
    if terminal and terminal:valid() then
        hide()
        return
    end
    origin = vim.api.nvim_get_current_win()
    if terminal and terminal:buf_valid() then
        terminal:show():focus()
        return
    end
    local bridge = assert(vim.api.nvim_get_runtime_file("lua/local_plugins/yazi/bridge.lua", false)[1])
    local windows = vim.fn.has("win32") == 1
    local editor = windows and "yazi-nvim.cmd" or "yazi-nvim"
    local path_separator = windows and ";" or ":"
    terminal = Snacks.terminal.open({ "yazi", path or vim.fn.getcwd() }, {
        env = {
            -- A command on PATH avoids shell-splitting executable and bridge paths in $EDITOR.
            EDITOR = editor,
            VISUAL = editor,
            PATH = vim.fs.dirname(bridge) .. path_separator .. (vim.env.PATH or ""),
            YAZI_NVIM = vim.v.progpath,
            YAZI_NVIM_BRIDGE = bridge,
            YAZI_NVIM_SERVER = vim.v.servername ~= "" and vim.v.servername or vim.fn.serverstart(),
        },
        win = {
            position = "float",
            width = 0.75,
            height = 0.75,
            border = "rounded",
            keys = {
                term_normal = false,
                hide_yazi = { "q", hide, mode = "t", desc = "Hide Yazi" },
            },
        },
    })
end

function M.setup()
    vim.g.loaded_netrwPlugin = 1
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("YaziDirectories", { clear = true }),
        callback = function(event)
            local path = vim.api.nvim_buf_get_name(event.buf)
            if vim.fn.isdirectory(path) ~= 1 then
                return
            end
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(event.buf) or vim.api.nvim_get_current_buf() ~= event.buf then
                    return
                end
                vim.cmd.enew()
                vim.api.nvim_buf_delete(event.buf, { force = true })
                M.toggle(path)
            end)
        end,
    })
end

return M
