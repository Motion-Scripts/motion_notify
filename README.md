# lime Notify - Modern FiveM Notification System

A sleek, modern notification system for FiveM with sound support and multiple positioning options.
https://discord.gg/fqUsy3FuYn

## Installation

1. Download and extract to your FiveM resources folder
2. Rename the folder to `lime_notify`
3. Add your `alert.ogg` sound file to the `html/` folder (or use the default one)
4. Add `ensure lime_notify` to your `server.cfg`
5. Restart your server

## Usage

### Client Side

```lua
-- Basic usage
exports['lime_notify']:Notify('Success', 'Action completed!', 'success')

-- With duration
exports['lime_notify']:Notify('Warning', 'Be careful!', 'warning', 7000)

### Server Side

```lua
-- Send to specific player
exports['lime_notify']:Notify(source, 'Server Message', 'Hello!', 'success', 5000)

-- Send to all players
for _, playerId in ipairs(GetPlayers()) do
    exports['lime_notify']:Notify(playerId, 'Announcement', 'Server restart in 5 minutes', 'warning', 10000)
end
```

## Framework Integration
If any of the integrations do not work, please open a ticket in our discord or submit a pull request 
https://discord.gg/fqUsy3FuYn

We recommend to integrate with ox_lib:

### ox_lib
1. Replace `lib.notify` function with code from `integrations/ox_lib/notify.lua`

### QBCore
1. Copy `integrations/qbcore/lime_notify.lua` to `qb-core/lime_notify.lua`
2. Add `client_script 'lime_notify.lua'` to `qb-core/fxmanifest.lua`

### QBox
1. Replace Notify function in `qbx_core/client/functions.lua` with code from `integrations/qbox/client.lua`
2. Replace Notify function in `qbx_core/server/functions.lua` with code from `integrations/qbox/server.lua`

### ESX
1. Copy `integrations/esx/lime_notify.lua` to `es_extended/lime_notify.lua`
2. Add `client_script 'lime_notify.lua'` to `es_extended/fxmanifest.lua`

## Exports List

### Client-Side Exports
- `exports['lime_notify']:Notify(title, message, type, duration)`

### Server-Side Exports
- `exports['lime_notify']:Notify(source, title, message, type, duration)`

### Parameters

**title** (string): Notification title
**message** (string): Notification message
**type** (string): 'success', 'error', 'warning', 'info'
**duration** (number): Duration in milliseconds

## Notification Types

- `success` - Green
- `error` - Red
- `warning` - Orange
- `info` - Blue

## Commands

`/editnotify` - Change default notification position and sound
`/resetnotify` - Reset the to the default notification position and sound
`/testnotify` - To test the default notifications
## Support

For issues or questions, please open an issue on GitHub or open a ticket in our discord: https://discord.gg/fqUsy3FuYn

## License
GNU GPL v3

