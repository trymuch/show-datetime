local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
-- local InputHandler = require "utils/input_handler"
local icon_scaling = .5
Assets = {Asset("ATLAS", "images/clock.xml"), Asset("IMAGE", "images/clock.tex")}

local function get_time()
    return os.date("%H:%M:%S")
end

local function get_date()
    return os.date("%Y/%m/%d")
end

local DatetimeWidget = Class(Widget, function(self, show_icon, show_time, show_date)
    Widget._ctor(self, "DatetimeWidget")

    self.show_icon = show_icon
    self.show_time = show_time
    self.show_date = show_date

    -- 根容器
    self.root = self:AddChild(Widget("root"))

    -- 钟表图标部件
    self.icon = self.root:AddChild(Image("images/clock.xml", "clock.tex"))
    self.icon:SetScale(icon_scaling)
    self.icon:Hide()

    -- 时间文本部件
    self.time_text = self.root:AddChild(Text(NUMBERFONT, 24, get_time(), {0, 1, 0, .75}))
    self.time_text:Hide()

    -- 日期文本部件
    self.date_text = self.root:AddChild(Text(NUMBERFONT, 24, get_date(), {0, 1, 0, .75}))
    self.date_text:Hide()

    -- 背景图片
    self.bg = self:AddChild(Image("images/global.xml", "square.tex"))
    self.bg:SetTint(1, 1, 1, 0.5)
    self.bg:MoveToBack()
    self.bg:Hide()

    self:Realign()

    -- 每秒更新时间文本和日期文本
    self:UpdateTimeAndDate()

    -- self:SetScaleMode(SCALEMODE_PROPORTIONAL)

    -- 设置初始位置
    self:SetVAnchor(ANCHOR_TOP)
    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetPosition(0, -30)
    -- 部件更新注册
    TheFrontEnd:StartUpdatingWidget(self)

    -- 拖拽支持
    self.dragging = false
    self.mouse_x_start = 0
    self.mouse_y_start = 0
    self.widget_x_start = 0
    self.widget_y_start = 0
    self:SetClickable(true)
end)

function DatetimeWidget:Realign()
    local icon_width, icon_height = self.icon:GetSize()
    icon_width, icon_height = icon_width * icon_scaling, icon_height * icon_scaling
    local time_width, time_height = self.time_text:GetRegionSize()
    local date_width, date_height = self.date_text:GetRegionSize()
    local minor_offset = 2
    local expanded_area = 10

    -- 将布尔值转换为二进制位
    local layout_mode = (self.show_icon and 4 or 0) + (self.show_time and 2 or 0) + (self.show_date and 1 or 0)

    -- 定义布局处理函数
    local layout_handlers = {
        [0] = function() -- 000: 什么都不显示
            -- 布局逻辑
        end,
        [1] = function() -- 001: 只显示日期
            -- 布局逻辑
            self.date_text:Show()
            self.bg:Show()
            self.bg:SetSize(date_width + expanded_area, date_height + expanded_area)
        end,
        [2] = function() -- 010: 只显示时间
            -- 布局逻辑
            self.time_text:Show()
            self.bg:Show()
            self.bg:SetSize(time_width + expanded_area, time_height + expanded_area)
        end,
        [3] = function() -- 011: 显示时间和日期
            -- 布局逻辑
            self.time_text:Show()
            self.date_text:Show()
            self.bg:Show()

            self.date_text:SetPosition(time_width / 2 + date_width / 2 + minor_offset * 2, 0)
            self.bg:SetSize(time_width + date_width + minor_offset * 2 + expanded_area,
                math.max(time_height, date_height) + expanded_area)
            self.root:SetPosition(-date_width / 2, 0)
        end,
        [4] = function() -- 100: 只显示图标
            -- 布局逻辑
            self.icon:Show()
            self.bg:Show()
            self.bg:SetSize(icon_width + expanded_area, icon_height + expanded_area)
        end,
        [5] = function() -- 101: 显示图标和日期
            -- 布局逻辑
            self.icon:Show()
            self.date_text:Show()
            self.bg:Show()
            self.date_text:SetPosition(icon_width / 2 + date_width / 2 + minor_offset * 2, 0)
            self.bg:SetSize(icon_width + date_width + minor_offset * 2 + expanded_area,
                math.max(icon_height, date_height) + expanded_area)
            self.root:SetPosition(-date_width / 2, 0)
        end,
        [6] = function() -- 110: 显示图标和时间
            -- 布局逻辑
            self.icon:Show()
            self.time_text:Show()
            self.bg:Show()
            self.time_text:SetPosition(icon_width / 2 + time_width / 2 + minor_offset * 2, 0)
            self.bg:SetSize(icon_width + time_width + minor_offset * 2 + expanded_area,
                math.max(icon_height, time_height) + expanded_area)
            self.root:SetPosition(-time_width / 2, 0)
        end,
        [7] = function() -- 111: 显示图标、时间和日期
            -- 布局逻辑
            self.icon:Show()
            self.time_text:Show()
            self.date_text:Show()
            self.bg:Show()
            self.time_text:SetPosition(icon_width / 2 + time_width / 2 + minor_offset * 2, 0)
            self.date_text:SetPosition(icon_width / 2 + minor_offset * 2 + time_width + minor_offset * 2 + date_width /
                                           2, 0)
            self.bg:SetSize(icon_width + time_width + date_width + minor_offset * 4 + expanded_area,
                math.max(icon_height, time_height, date_height) + expanded_area)
            self.root:SetPosition(-time_width / 2 - date_width / 2 - minor_offset * 2, 0)
        end
    }
    -- 执行对应的布局处理函数
    local handler = layout_handlers[layout_mode]
    if handler then
        handler()
    end
end

function DatetimeWidget:UpdateTimeAndDate()
    if self.show_time then
        self.time_text:SetString(get_time())
    end
    if self.show_date then
        self.date_text:SetString(get_date())
    end
end

function DatetimeWidget:OnMouseButton(button, down, x, y)
    if button == MOUSEBUTTON_LEFT then
        if down then
            local pos = self:GetWorldPosition() -- 获取组件在屏幕的位置
            local widget_width, widget_height = self.bg:GetScaledSize()
            -- 判断鼠标是否在组件内部
            local in_widget = math.abs(x - pos.x) <= widget_width / 2 and math.abs(y - pos.y) <= widget_height / 2
            if in_widget then
                print("[Show Datetime] 鼠标点击在了控件内部！")
                self.dragging = true
                local mouse_pos = TheInput:GetScreenPosition()
                self.mouse_x_start = mouse_pos.x
                self.mouse_y_start = mouse_pos.y
                local widget_pos = self:GetPosition()
                self.widget_x_start = widget_pos.x
                self.widget_y_start = widget_pos.y
            end
        else
            self.dragging = false
        end
    end
    -- if button == MOUSEBUTTON_LEFT and down then
    --     self:FollowMouse()
    -- else
    --     self:StopFollowMouse()
    -- end
end

function DatetimeWidget:OnUpdate(dt)
    if self.dragging and TheInput:IsMouseDown(MOUSEBUTTON_LEFT) then
        local mouse_pos = TheInput:GetScreenPosition()
        local dx = mouse_pos.x - self.mouse_x_start
        local dy = mouse_pos.y - self.mouse_y_start
        self:SetPosition(self.widget_x_start + dx, self.widget_y_start + dy)
    end
    self:UpdateTimeAndDate()
end

return DatetimeWidget
