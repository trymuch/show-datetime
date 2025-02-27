GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local DatetimeWidget = require "widgets/datetimewidget"

local datetimewidget = nil
local show_icon = GetModConfigData("show_icon")
local show_time = GetModConfigData("show_time")
local show_date = GetModConfigData("show_date")

local function init_datetimewidget()
    datetimewidget = DatetimeWidget(show_icon, show_time, show_date)
    datetimewidget:SetHAnchor(ANCHOR_MIDDLE)
    datetimewidget:SetVAnchor(ANCHOR_TOP)
    datetimewidget:SetPosition(0, -30)
end
AddGamePostInit(function()
    init_datetimewidget()
end)

local left_ctrl_down = false
TheInput:AddKeyDownHandler(KEY_LCTRL, function()
    left_ctrl_down = true
end)
TheInput:AddKeyUpHandler(KEY_LCTRL, function()
    left_ctrl_down = false
end)
local shortcut_key = GLOBAL[GetModConfigData("shortcut_key")]
TheInput:AddKeyHandler(function(key, down)
    if not left_ctrl_down then
        return
    end
    if down and key == shortcut_key then
        if datetimewidget ~= nil then
            datetimewidget:Kill()
            datetimewidget = nil
        else
            init_datetimewidget()
        end
    end
end)
