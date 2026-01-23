-- ============================================
-- QBox Server Integration for Motion Notify
-- ============================================
-- INSTALLATION:
-- 1. Open qbx_core/server/functions.lua
-- 2. Replace the Notify function with this code
-- 3. Restart server
-- ============================================

function Notify(source, text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
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

    TriggerClientEvent('motion_notify:Notify', source, title, description, nType, duration)
end