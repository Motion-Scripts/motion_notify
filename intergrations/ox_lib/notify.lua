-- ============================================
-- ox_lib Integration for Motion Notify
-- ============================================
-- INSTALLATION:
-- 1. Open ox_lib/resource/interface/client and find the lib.notify function
-- 2. Replace it with this code
-- 3. Restart server
-- ============================================

function lib.notify(data)
    if GetResourceState("motion_notify") ~= "started" then
        return
    end

    local notifyType = data.type or 'info'
    if notifyType == 'inform' then notifyType = 'info' end
    
    exports['motion_notify']:Notify(
        data.title or 'Notification',
        data.description or '',
        notifyType,
        data.duration or 5000
    )
end