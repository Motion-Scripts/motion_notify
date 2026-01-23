-- ============================================
-- QBCore Integration for Motion Notify
-- ============================================
-- INSTALLATION:
-- 1. Copy this file to: qb-core/motion_notify.lua
-- 2. Add to qb-core/fxmanifest.lua at the BOTTOM:
--    client_script 'motion_notify.lua'
-- 3. Restart server
-- ============================================

local originalNotify = QBCore.Functions.Notify

QBCore.Functions.Notify = function(text, texttype, length)
    if GetResourceState("motion_notify") == "started" then
        local msg = text
        local title = nil

        if type(text) == 'table' then
            msg = text.text or text.caption or ''
            title = text.title
        end

        local notifyType = texttype or 'info'
        if notifyType == 'primary' then notifyType = 'info' end

        exports["motion_notify"]:Notify(title, msg, notifyType, length)
    else
        originalNotify(text, texttype, length)
    end
end