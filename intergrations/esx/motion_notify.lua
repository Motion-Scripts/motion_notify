-- ============================================
-- ESX Integration for lime Notify
-- ============================================
-- INSTALLATION:
-- 1. Copy this file to: es_extended/lime_notify.lua
-- 2. Add to es_extended/fxmanifest.lua at the BOTTOM:
--    client_script 'lime_notify.lua'
-- 3. Restart server
-- ============================================

local originalShowNotification = ESX.ShowNotification

ESX.ShowNotification = function(message, notifyType, length)
    if GetResourceState("lime_notify") == "started" then
        exports["lime_notify"]:Notify(nil, message, notifyType, length)
    else
        originalShowNotification(message, notifyType, length)
    end
end