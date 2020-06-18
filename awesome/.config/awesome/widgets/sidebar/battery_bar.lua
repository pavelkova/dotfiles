local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local vicious = require("vicious")
local helpers = require("helpers")

-- Set colors
local active_color = beautiful.battery_bar_active_color or "#5AA3CC"
local background_color = beautiful.battery_bar_background_color or "#222222"

-- Configuration

battery_widget = wibox.widget.progressbar()
vicious.register(battery_widget, vicious.widgets.bat, "$2", 30, "BAT0")

local battery_widget_stack = helpers.create_widget_stack(
   battery_widget,
   '   BATTERY',
   active_color,
   background_color
)

local battery_icon = helpers.create_text_icon("")

local battery_bar = helpers.create_status_bar(battery_icon, battery_widget_stack)

return battery_bar
