local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local vicious = require("vicious")
local helpers = require("helpers")

-- Set colors
local active_color = beautiful.volume_bar_active_color or "#5AA3CC"
local muted_color = beautiful.volume_bar_muted_color or "#666666"
local active_background_color = beautiful.volume_bar_active_background_color or "#222222"
local muted_background_color = beautiful.volume_bar_muted_background_color or "#222222"
-- Configuration

volume_widget = wibox.widget.progressbar()
vicious.register(volume_widget, vicious.widgets.volume, "$1", 30, "Master")

local volume_widget_stack = helpers.create_widget_stack(
   volume_widget,
   '   VOLUME',
   active_color,
   background_color
)

local volume_icon = helpers.create_text_icon("")

local volume_bar = helpers.create_status_bar(volume_icon, volume_widget_stack)

volume_bar:buttons(gears.table.join(
                 -- Left click - Mute / Unmute
                 awful.button({ }, 1, function ()
                     awful.spawn.with_shell("vol toggle")
                 end),
                 -- Right click - Run or raise pavucontrol
                 awful.button({ }, 3, function ()
                     local matcher = function (c)
                       return awful.rules.match(c, {class = 'Pavucontrol'})
                     end
                     awful.client.run_or_raise("pavucontrol", matcher)
                 end),
                 -- Scroll - Increase / Decrease volume
                 awful.button({ }, 4, function ()
                     awful.spawn.with_shell("vol up")
                 end),
                 awful.button({ }, 5, function ()
                     awful.spawn.with_shell("vol down")
                 end)
))

return volume_bar
