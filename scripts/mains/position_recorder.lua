--[[
    记录DatetimeWidget控件的位置信息
    统一不同屏幕下的控件的位置
]] local json = require "json"
-- 记录DatetimeWidget控件的位置
global("show_datetime_widget_position")
show_datetime_widget_position = nil

local PositionRecorder = Class(function(self, widget)
    self.widget = widget
    self.storage_key = "show_datetime"
end)

function PositionRecorder:GetPosition()
    TheSim:GetPersistentString(self.storage_key, function(success, content)
        if success and content then
            local data = json.decode(content)
            show_datetime_widget_position = Vector3(data.x, data.y, data.z)
        else
            show_datetime_widget_position = Vector3(0, -30, 0)
        end
    end)
    return show_datetime_widget_position
end

function PositionRecorder:SetPosition(pos)
    show_datetime_widget_position = pos
    local content = json.encode(show_datetime_widget_position)
    print("[Show Datetime] content", content)
    TheSim:SetPersistentString(self.storage_key, content, false)
end

return PositionRecorder
