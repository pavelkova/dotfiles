local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local vicious = require("vicious")
local helpers = require("helpers")


-- Set colors
local active_color = beautiful.ram_bar_active_color or "#5AA3CC"
local background_color = beautiful.ram_bar_background_color or "#222222"

-- Configuration

ram_widget = wibox.widget.progressbar()
vicious.cache(vicious.widgets.mem)
vicious.register(ram_widget, vicious.widgets.mem, "$1", 20)

local ram_widget_stack = helpers.create_widget_stack(
   ram_widget,
   "   RAM",
   active_color,
   background_color)



local ram_icon = helpers.create_text_icon("")


local ram_bar = helpers.create_status_bar(ram_icon, ram_widget_stack)

return ram_bar
