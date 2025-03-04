GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local DatetimeWidget = require "widgets/datetimewidget"

local show_icon = GetModConfigData("show_icon")
local show_time = GetModConfigData("show_time")
local show_date = GetModConfigData("show_date")
local shortcut_key = GLOBAL[GetModConfigData("shortcut_key")]

local function add_datetimewidget(self)
    self.datetimewidget = self:AddChild(DatetimeWidget(show_icon, show_time, show_date, shortcut_key))
end
AddClassPostConstruct("screens/redux/mainscreen", add_datetimewidget)
AddClassPostConstruct("screens/redux/multiplayermainscreen", add_datetimewidget)
AddClassPostConstruct("widgets/controls", add_datetimewidget)
