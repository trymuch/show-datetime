local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
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
    self:UpdateTimeAndDate()
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
        self.time_text.inst:DoPeriodicTask(1, function()
            self.time_text:SetString(get_time())
        end)
    end
    if self.show_date then
        self.date_text.inst:DoPeriodicTask(1, function()
            self.date_text:SetString(get_date())
        end)
    end
end

return DatetimeWidget
