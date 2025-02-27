GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})
local DatetimeWidget = require "widgets/datetimewidget"
local datetimewidget = nil

AddGamePostInit(function()
    datetimewidget = DatetimeWidget(true, true, true)
    datetimewidget:SetHAnchor(ANCHOR_MIDDLE)
    datetimewidget:SetVAnchor(ANCHOR_TOP)
    datetimewidget:SetPosition(0, -30)
end)
