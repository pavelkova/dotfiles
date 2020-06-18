local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local vicious = require("vicious")
local helpers = require("helpers")

-- Set colors
local active_color = beautiful.temperature_bar_active_color or "#5AA3CC"
local background_color = beautiful.temperature_bar_background_color or "#222222"

-- Configuration

temperature_widget = wibox.widget.progressbar()
vicious.register(temperature_widget, vicious.widgets.hwmontemp, "$1", 5)

local temperature_widget_stack = helpers.create_widget_stack(
   temperature_widget,
   '   TEMPERATURE',
   active_color,
   background_color
)

local temperature_icon = helpers.create_text_icon("")

local temperature_bar = helpers.create_status_bar(temperature_icon, temperature_widget_stack)

return temperature_bar
