local resourceName = GetCurrentResourceName()
if resourceName ~= "motion_notify" then
    print("^1[ERROR]^7 Resource must be named 'motion_notify' ")
    print("^1[ERROR]^7 Current name: '" .. resourceName .. "'")
    print("^1[ERROR]^7 Resource will now stop")
    return
end

local function NotifyServer(source, title, message, notifyType, duration)    
    TriggerClientEvent('motion_notify:Notify', source, title, message, notifyType, duration)
end

exports('Notify', NotifyServer)