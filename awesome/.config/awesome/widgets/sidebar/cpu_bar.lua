local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local vicious = require("vicious")
local helpers = require("helpers")

-- Set colors
local active_color = beautiful.cpu_bar_active_color or "#5AA3CC"
local background_color = beautiful.cpu_bar_background_color or "#222222"

-- Configuration

cpu_widget = wibox.widget.progressbar()
vicious.register(cpu_widget, vicious.widgets.cpu, "$1", 3)

local cpu_widget_stack = helpers.create_widget_stack(
   cpu_widget,
   '   CPU',
   active_color,
   background_color
)

local cpu_icon = helpers.create_text_icon("")

local cpu_bar = helpers.create_status_bar(cpu_icon, cpu_widget_stack)

-- Mouse control
cpu_bar:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                         naughty.notify{title = "cpu",
                         text = vicious.call(vicious.widgets.cpu, "cpu: $1", "0")}
    end)
))

-- cpu_bar:buttons(
--   gears.table.join(
--     awful.button({ }, 1, function ()
--         local matcher = function (c)
--           return awful.rules.match(c, {name = 'htop'})
--         end
--         awful.client.run_or_raise(terminal .." -e htop", matcher)
--     end),
--     awful.button({ }, 3, function ()
--         local matcher = function (c)
--           return awful.rules.match(c, {class = 'Lxtask'})
--         end
--         awful.client.run_or_raise("lxtask", matcher)
--     end)
-- ))

return cpu_bar
