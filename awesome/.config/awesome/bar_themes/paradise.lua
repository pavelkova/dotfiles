local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

-- {{{ Widgets
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    -- awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ }, 3, function(t)
                        if client.focus then
                          client.focus:move_to_tag(t)
                        end
                    end),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

-- local tasklist_buttons = gears.table.join(
--                      awful.button({ }, 1,
--                         function (c)
--                             if c == client.focus then
--                                 c.minimized = true
--                             else
--                                 -- Without this, the following
--                                 -- :isvisible() makes no sense
--                                 c.minimized = false
--                                 if not c:isvisible() and c.first_tag then
--                                     c.first_tag:view_only()
--                                 end
--                                 -- This will also un-minimize
--                                 -- the client, if needed
--                                 client.focus = c
--                                 c:raise()
--                             end
--                         end),
--                      -- Middle mouse button closes the window
--                      awful.button({ }, 2, function (c) c:kill() end),
--                      awful.button({ }, 3, function (c) c.minimized = true end),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(1)
--                     end)
-- )

-- }}}

awful.screen.connect_for_each_screen(function(s)

    -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create an icon taglist
    -- local icon_taglist = require("noodle.icon_taglist")

    --  local minimal_tasklist = require("noodle.minimal_tasklist")

    -- Create a custom text taglist
    local text_taglist = require("noodle.text_taglist")

    -- Create text weather widget
    -- local text_weather = require("noodle.text_weather")
    -- local weather_widget_icon = text_weather:get_all_children()[1]
    -- weather_widget_icon.font = "Typicons 11"
    -- local weather_widget_text = text_weather:get_all_children()[2]
    -- weather_widget_text.font = "Lato 10"

    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = beautiful.wibar_position,
                              screen = s,
                              width = beautiful.wibar_width,
                              height = beautiful.wibar_height,
                              shape = helpers.rrect(beautiful.wibar_border_radius)})
    -- Wibar items
    -- Add or remove widgets here
    s.mywibox:setup {
        {
            { -- Some padding
                layout = wibox.layout.fixed.horizontal
            },
            --text_weather,
            spacing = dpi(12),
            layout = wibox.layout.fixed.horizontal
        },
        text_taglist,
        expand = "none",
        -- minimal_tasklist,
        -- s.mytasklist,
        layout = wibox.layout.align.horizontal
    }
end)
