--[[
    用户输入处理
    将用户输入处理和控件界面布局分离，代码更加易于维护和扩展
]] 
local InputHandler = Class(function(self, widget, toggle_key)
    self.widget = widget
    self.toggle_key = toggle_key
    -- 记录拖拽状态
    self.dragging = false
    -- 拖拽开始时候的鼠标位置
    self.mouse_start_x = 0
    self.mouse_start_y = 0
    -- 拖拽开始时候的控件位置
    self.widget_start_x = 0
    self.widget_start_y = 0

    -- 绑定切合显示/隐藏控件的快捷键
    self:BindingToggleKey(toggle_key)
end)

function InputHandler:OnMouseButton(button, down, x, y)
    if button == MOUSEBUTTON_LEFT then
        if down then
            -- 鼠标按下的时候控件转换到拖拽状态
            self.dragging = true
            -- 鼠标左键按下的时候记录鼠标和控件的位置
            local mouse_pos = TheInput:GetScreenPosition() -- 鼠标在屏幕的位置
            self.mouse_start_x = mouse_pos.x
            self.mouse_start_y = mouse_pos.y
            local widget_pos = self.widget:GetWorldPosition() -- 控件在屏幕的位置
            self.widget_start_x = widget_pos.x
            self.widget_start_y = widget_pos.y
            return true
        else
            -- 鼠标左键弹起的时候转换成非拖拽状态
            self.dragging = false
            self.widget.position_recorder:SetPosition(self.widget:GetPosition())
        end
    end
    return false
end

function InputHandler:UpdateDragging()
    if self.dragging and TheInput:IsMouseDown(MOUSEBUTTON_LEFT) then
        local mouse_pos = TheInput:GetScreenPosition()
        local dx = mouse_pos.x - self.mouse_start_x
        local dy = mouse_pos.y - self.mouse_start_y
        self.widget:SetPosition(self.widget_start_x + dx, self.widget_start_y + dy)
    else
        self.dragging = false
    end
end

function InputHandler:BindingToggleKey(toggle_key)
    TheInput:AddKeyHandler(function(key, down)
        if not TheInput:IsKeyDown(KEY_CTRL) then
            return
        end
        if down and key == toggle_key then
            if self.widget:IsVisible() then
                self.widget:Hide()
            else
                self.widget:Show()
            end
        end
    end)
end

return InputHandler
