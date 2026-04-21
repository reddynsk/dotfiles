-- Hammerspoon — window hints + URL handler for AeroSpace integration
-- Reload: cmd+alt+ctrl+R  |  Console: menu bar icon

hs.allowAppleScript(true)

-- Auto-reload when any lua file changes
hs.pathwatcher.new(os.getenv("HOME").."/.hammerspoon/", function(paths)
    for _, p in ipairs(paths) do
        if p:match("%.lua$") then hs.reload() return end
    end
end):start()

-- Hint style (letter overlay on every visible window)
hs.hints.style = "vimperator"
hs.hints.showTitleThresh = 0
hs.hints.fontName = "JetBrainsMono-Bold"
hs.hints.fontSize = 26
hs.hints.iconAlpha = 0.95
hs.hints.hintChars = {"A","S","D","F","G","H","J","K","L","Q","W","E","R","T","Y","U","I","O","P"}

-- Trigger hint mode via URL (called from AeroSpace: alt-e)
hs.urlevent.bind("hints", function()
    hs.hints.windowHints(nil, nil, true)
end)

-- Also bind directly on cmd+alt+ctrl+E as backup
hs.hotkey.bind({"cmd","alt","ctrl"}, "E", function()
    hs.hints.windowHints(nil, nil, true)
end)

-- Reload config
hs.hotkey.bind({"cmd","alt","ctrl"}, "R", function()
    hs.reload()
end)

-- Cheatsheet overlay (Hyper + /)
local cheat = require("cheatsheet")
hs.hotkey.bind({"cmd","alt","ctrl"}, "/", function() cheat.toggle() end)
hs.urlevent.bind("cheatsheet", function() cheat.toggle() end)

-- Quick app launcher bindings (Omarchy-style super+letter)
-- Use Hyper (cmd+alt+ctrl) since alt is taken by AeroSpace
local apps = {
    B = "Safari",
    C = "Visual Studio Code",
    T = "Terminal",
    F = "Finder",
    M = "Mail",
    S = "Slack",
}
for key, app in pairs(apps) do
    hs.hotkey.bind({"cmd","alt","ctrl"}, key, function()
        hs.application.launchOrFocus(app)
    end)
end

hs.alert.show("Hammerspoon loaded")
