local fzf = require("fzf-lua")

local M = {}

local fzf_notifications = function()
  local notify = require("notify")
  local ansi_from_hl = require("fzf-lua.utils").ansi_from_hl

  local time_format = notify._config().time_formats().notification
  local notifs = notify.history()
  local content = {}

  for i, notif in ipairs(notifs) do
    local entry = table.concat({
      ansi_from_hl("NotifyLogTime", vim.fn.strftime(time_format, notif.time)),
      ansi_from_hl("NotifyLogTitle", notif.title[1]),
      ansi_from_hl("Notify" .. notif.level .. "Title", notif.icon),
      ansi_from_hl("Notify" .. notif.level .. "Title", notif.level),
      -- Make sure only the first return value of `ansi_from_hl` will be used
      (ansi_from_hl("Keyword", notif.message[1])),
    }, " ")

    -- In reversed order
    content[#notifs - i + 1] = entry
  end

  fzf.fzf_exec(content, {
    prompt = "Notifications> ",
  })
end

M.setup = function()
  fzf.notify = fzf_notifications
end

return M
