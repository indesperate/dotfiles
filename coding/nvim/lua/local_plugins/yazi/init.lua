local M = {}
local terminal, origin, client_id

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
    vim.cmd.edit({ args = { files[1] }, magic = { file = false } })
    for i = 2, #files do
        local buffer = vim.fn.bufadd(files[i])
        vim.bo[buffer].buflisted = true
    end
end

local function discard_exited_terminal()
    if not terminal or not terminal:buf_valid() then
        return
    end
    local channel = vim.bo[terminal.buf].channel
    if channel > 0 and vim.fn.jobwait({ channel }, 0)[1] == -1 then
        return
    end
    if terminal:buf_valid() then
        terminal:close()
    end
    terminal = nil
    client_id = nil
end

function M.toggle(path)
    path = path and vim.fn.fnamemodify(path, ":p")
    discard_exited_terminal()
    local visible = terminal and terminal:valid()
    if visible and not path then
        hide()
        return
    end
    if not visible then
        origin = vim.api.nvim_get_current_win()
    end
    if terminal and terminal:buf_valid() then
        if path then
            vim.system(
                { "ya", "emit-to", client_id, "cd", "--raw", path },
                { text = true },
                vim.schedule_wrap(function(result)
                    if result.code ~= 0 then
                        vim.notify("Yazi cd failed: " .. vim.trim(result.stderr), vim.log.levels.ERROR)
                    end
                end)
            )
        end
        terminal:show():focus()
        return
    end
    local bridge = assert(vim.api.nvim_get_runtime_file("lua/local_plugins/yazi/bridge.lua", false)[1])
    local windows = vim.fn.has("win32") == 1
    local editor = windows and "yazi-nvim.cmd" or "yazi-nvim"
    local path_separator = windows and ";" or ":"
    local seconds, microseconds = vim.uv.gettimeofday()
    client_id = ("%d%06d"):format(seconds, microseconds)
    terminal = Snacks.terminal.open({ "yazi", "--client-id", client_id, path or vim.fn.getcwd() }, {
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
                hide_yazi = { "<C-q>", hide, mode = "t", desc = "Hide Yazi" },
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
