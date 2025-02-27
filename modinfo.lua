name = "Show Datetime"
author = "陇首云飞"
version = "0.0.1"
description = [[
启动游戏后在屏幕中显示当前系统的时间和日期。
]]

forumthread = ""

icon = ""
icon_atlas = ""

api_version = 10
dst_compatible = true
client_only_mod = true
all_clients_require_mod = false

local shortcut_keys = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
                       "T", "U", "V", "W", "X", "Y", "Z", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10",
                       "F11", "F12"}
local shortcut_keys_options = {}
for i = 1, #shortcut_keys do
    shortcut_keys_options[i] = {
        description = shortcut_keys[i],
        hover = "按下LCTRL + " .. shortcut_keys[i] .. "切换显示/隐藏时间日期",
        data = "KEY_" .. shortcut_keys[i]
    }
end
configuration_options = {{
    name = "shortcut_key",
    hover = "设定切换显示/隐藏日期时间的快捷键(需要按住LCTRL键)",
    label = "显示/隐藏",
    options = shortcut_keys_options,
    default = "KEY_F10"
}, {
    name = "show_icon",
    hover = "设定是否显示钟表图标",
    label = "显示图标",
    options = {{
        description = "是",
        hover = "显示钟表图标",
        data = true
    }, {
        description = "否",
        hover = "隐藏钟表图标",
        data = false
    }},
    default = true
}, {
    name = "show_time",
    hover = "设定是否显示时间",
    label = "显示时间",
    options = {{
        description = "是",
        hover = "显示时间",
        data = true
    }, {
        description = "否",
        hover = "隐藏时间",
        data = false
    }},
    default = true
}, {
    name = "show_date",
    hover = "设定是否显示日期",
    label = "显示日期",
    options = {{
        description = "是",
        hover = "显示日期",
        data = true
    }, {
        description = "否",
        hover = "隐藏日期",
        data = false
    }},
    default = true
}}
