local currentPosition = nil
local soundEnabled = nil
local soundVolume = nil
local menuPosition = nil

local function getPosition()
    local x = GetResourceKvpInt("motion_notify_x")
    local y = GetResourceKvpInt("motion_notify_y")
    if x == 0 and y == 0 then
        local presets = {
            ["top-left"]      = {x = 1,  y = 1},
            ["top-center"]    = {x = 50, y = 1},
            ["top-right"]     = {x = 99, y = 1},
            ["middle-left"]   = {x = 1,  y = 50},
            ["middle-center"] = {x = 50, y = 50},
            ["middle-right"]  = {x = 99, y = 50},
            ["bottom-left"]   = {x = 1,  y = 99},
            ["bottom-center"] = {x = 50, y = 99},
            ["bottom-right"]  = {x = 99, y = 99},
        }
        local preset = presets[Config.Position] or presets["top-right"]
        x = preset.x
        y = preset.y
        SetResourceKvpInt("motion_notify_x", x)
        SetResourceKvpInt("motion_notify_y", y)
    end
    currentPosition = {x = x, y = y}
    return currentPosition
end

local function getMenuPosition()
    local x = GetResourceKvpInt("motion_notify_menu_x")
    local y = GetResourceKvpInt("motion_notify_menu_y")
    if x == 0 and y == 0 then
        x = 20
        y = 20
        SetResourceKvpInt("motion_notify_menu_x", x)
        SetResourceKvpInt("motion_notify_menu_y", y)
    end
    menuPosition = {x = x, y = y}
    return menuPosition
end

local function getSoundSettings()
    if soundEnabled == nil then
        local storedSound = GetResourceKvpInt("motion_notify_sound")
        if storedSound == 2 or storedSound == 0 then
            local vol = GetResourceKvpInt("motion_notify_volume")
            if storedSound == 0 and vol == 0 then
                soundEnabled = true
                SetResourceKvpInt("motion_notify_sound", 1)
            elseif storedSound == 2 then
                soundEnabled = false
                SetResourceKvpInt("motion_notify_sound", 2)
            else
                soundEnabled = false
            end
        else
            soundEnabled = storedSound == 1
        end
    end

    if soundVolume == nil then
        soundVolume = GetResourceKvpInt("motion_notify_volume")
        if soundVolume == 0 or soundVolume > 100 then
            soundVolume = 50
            SetResourceKvpInt("motion_notify_volume", soundVolume)
        end
    end

    return soundEnabled, soundVolume
end

RegisterNUICallback('saveSettings', function(data, cb)
    local x = math.floor(tonumber(data.x))
    local y = math.floor(tonumber(data.y))
    local menuX = math.floor(tonumber(data.menuX))
    local menuY = math.floor(tonumber(data.menuY))
    local sound = data.sound and 1 or 2
    local volume = math.floor(tonumber(data.volume))
    if volume > 100 then volume = 100 end
    if volume < 0 then volume = 0 end

    SetResourceKvpInt("motion_notify_x", x)
    SetResourceKvpInt("motion_notify_y", y)
    SetResourceKvpInt("motion_notify_menu_x", menuX)
    SetResourceKvpInt("motion_notify_menu_y", menuY)
    SetResourceKvpInt("motion_notify_sound", sound)
    SetResourceKvpInt("motion_notify_volume", volume)

    currentPosition = {x = x, y = y}
    menuPosition = {x = menuX, y = menuY}
    soundEnabled = data.sound
    soundVolume = volume

    SendNUIMessage({
        action = 'updateSettings',
        sound = soundEnabled,
        volume = soundVolume
    })

    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('closeEditor', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

local function Notify(title, message, notifyType, duration)
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
        }
    })
end

exports('Notify', Notify)

RegisterNetEvent('motion_notify:Notify', function(title, message, notifyType, duration)
    Notify(title, message, notifyType, duration)
end)

RegisterCommand("testnotify", function()
    Notify("Success!", "This is a success message", "success", 5000)
    Notify("Infomation", "This is an information message", "info", 5000)
    Notify("Warning", "This is a warning message", "warning", 5000)
    Notify("Error :(", "This is an error message", "error", 5000)
end)

RegisterCommand("editnotify", function()
    local pos = getPosition()
    local menuPos = getMenuPosition()
    local sound, volume = getSoundSettings()
    SetNuiFocus(true, true)
    Wait(50)
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
    SetResourceKvpInt("motion_notify_x", 0)
    SetResourceKvpInt("motion_notify_y", 0)
    SetResourceKvpInt("motion_notify_menu_x", 0)
    SetResourceKvpInt("motion_notify_menu_y", 0)
    SetResourceKvpInt("motion_notify_sound", 0)
    SetResourceKvpInt("motion_notify_volume", 0)
    currentPosition = nil
    menuPosition = nil
    soundEnabled = nil
    soundVolume = nil
    Notify("Reset Settings", "Settings have been successfully set to default.", "success", 5000)
end)