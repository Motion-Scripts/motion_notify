-- ============================================
-- QBox Client Integration for Motion Notify
-- ============================================
-- INSTALLATION:
-- 1. Open qbx_core/client/functions.lua
-- 2. Replace the Notify function with this code
-- 3. Restart server
-- ============================================

function Notify(text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
    if GetResourceState("motion_notify") ~= "started" then
        return
    end

    local title, description
    if type(text) == 'table' then
        title = text.text or 'Placeholder'
        description = text.caption or nil
    elseif subTitle then
        title = text
        description = subTitle
    else
        description = text
    end

    local nType = notifyType or 'info'

    exports["motion_notify"]:Notify(title, description, nType, duration)
end