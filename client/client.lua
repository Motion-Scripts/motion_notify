local currentPosition = nil
local menuPosition = nil
local soundEnabled = true
local soundVolume = 50
local nuiLoaded = false

-- ================================
-- NUI READY HANDSHAKE
-- ================================
RegisterNUICallback("nuiReady", function(_, cb)
    nuiLoaded = true
    cb("ok")
end)

-- Attempt to re-trigger nuiReady in case the page loaded before the callback was registered
CreateThread(function()
    Wait(500)
    if not nuiLoaded then
        SendNUIMessage({ action = "ping" })
    end
end)

local function waitForNui()
    if nuiLoaded then return true end
    local timeout = 0
    while not nuiLoaded and timeout < 10000 do
        Wait(10)
        timeout = timeout + 10
    end
    if not nuiLoaded then
        print("[motion_notify] WARNING: NUI failed to signal ready after 10s. UI may not display correctly.")
        return false
    end
    return true
end

-- ================================
-- SAFE POSITION GETTER
-- ================================
local function getPosition()
    local x = GetResourceKvpInt("motion_notify_x")
    local y = GetResourceKvpInt("motion_notify_y")

    -- If invalid or first run
    if x <= 0 or x > 100 then x = 95 end
    if y <= 0 or y > 100 then y = 5 end

    -- Clamp to safe range (prevents ultrawide clipping)
    x = math.max(5, math.min(95, x))
    y = math.max(5, math.min(95, y))

    SetResourceKvpInt("motion_notify_x", x)
    SetResourceKvpInt("motion_notify_y", y)

    currentPosition = { x = x, y = y }
    return currentPosition
end

local function getMenuPosition()
    local x = GetResourceKvpInt("motion_notify_menu_x")
    local y = GetResourceKvpInt("motion_notify_menu_y")

    if x <= 0 then x = 20 end
    if y <= 0 then y = 20 end

    SetResourceKvpInt("motion_notify_menu_x", x)
    SetResourceKvpInt("motion_notify_menu_y", y)

    menuPosition = { x = x, y = y }
    return menuPosition
end

-- ================================
-- SOUND SETTINGS
-- ================================
local function getSoundSettings()
    local storedSound = GetResourceKvpInt("motion_notify_sound")
    local storedVolume = GetResourceKvpInt("motion_notify_volume")

    soundEnabled = (storedSound ~= 2)

    if storedVolume < 1 or storedVolume > 100 then
        storedVolume = 50
    end

    soundVolume = storedVolume

    SetResourceKvpInt("motion_notify_sound", soundEnabled and 1 or 2)
    SetResourceKvpInt("motion_notify_volume", soundVolume)

    return soundEnabled, soundVolume
end

-- ================================
-- SAVE SETTINGS CALLBACK
-- ================================
RegisterNUICallback('saveSettings', function(data, cb)
    local x = math.floor(tonumber(data.x) or 95)
    local y = math.floor(tonumber(data.y) or 5)
    local menuX = math.floor(tonumber(data.menuX) or 20)
    local menuY = math.floor(tonumber(data.menuY) or 20)
    local volume = math.floor(tonumber(data.volume) or 50)

    x = math.max(5, math.min(95, x))
    y = math.max(5, math.min(95, y))
    volume = math.max(0, math.min(100, volume))

    soundEnabled = data.sound == true
    soundVolume = volume

    SetResourceKvpInt("motion_notify_x", x)
    SetResourceKvpInt("motion_notify_y", y)
    SetResourceKvpInt("motion_notify_menu_x", menuX)
    SetResourceKvpInt("motion_notify_menu_y", menuY)
    SetResourceKvpInt("motion_notify_sound", soundEnabled and 1 or 2)
    SetResourceKvpInt("motion_notify_volume", volume)

    SendNUIMessage({
        action = 'updateSettings',
        sound = soundEnabled,
        volume = soundVolume
    })

    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('closeEditor', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- ================================
-- MAIN NOTIFY FUNCTION
-- ================================
local function Notify(title, message, notifyType, duration)
    if not waitForNui() then
        print("[motion_notify] Skipping notify - NUI not ready. Title: " .. tostring(title))
        return
    end
    local pos = getPosition()

    SendNUIMessage({
        action = 'notify',
        type = notifyType or 'info',
        title = title or 'Notification',
        message = message or '',
        duration = duration or 5000,
        position = {
            x = pos.x,
            y = pos.y
        },
        sound = soundEnabled,
        volume = soundVolume
    })
end

exports('Notify', Notify)

RegisterNetEvent('motion_notify:Notify', function(title, message, notifyType, duration)
    Notify(title, message, notifyType, duration)
end)

-- ================================
-- COMMANDS
-- ================================
RegisterCommand("testnotify", function()
    Notify("Success!", "This is a success message", "success", 5000)
    Notify("Information", "This is an information message", "info", 5000)
    Notify("Warning", "This is a warning message", "warning", 5000)
    Notify("Error :(", "This is an error message", "error", 5000)
end)

RegisterCommand("editnotify", function()
    if not waitForNui() then
        print("[motion_notify] Cannot open editor - NUI not ready.")
        return
    end
    local pos = getPosition()
    local menuPos = getMenuPosition()
    local sound, volume = getSoundSettings()

    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'openEditor',
        x = pos.x,
        y = pos.y,
        menuX = menuPos.x,
        menuY = menuPos.y,
        sound = sound,
        volume = volume
    })
end)

RegisterCommand("resetnotify", function()
    SetResourceKvpInt("motion_notify_x", 95)
    SetResourceKvpInt("motion_notify_y", 5)
    SetResourceKvpInt("motion_notify_menu_x", 20)
    SetResourceKvpInt("motion_notify_menu_y", 20)
    SetResourceKvpInt("motion_notify_sound", 1)
    SetResourceKvpInt("motion_notify_volume", 50)

    currentPosition = nil
    menuPosition = nil
    soundEnabled = true
    soundVolume = 50

    Notify("Reset Settings", "Settings have been reset to default.", "success", 5000)
end)