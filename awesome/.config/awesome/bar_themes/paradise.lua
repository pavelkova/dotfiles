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

-- }}}

awful.screen.connect_for_each_screen(
    function(s)
        -- Create a custom text taglist
        local text_taglist = require("noodle.text_taglist")

        -- We need one layoutbox per screen.
        -- s.mylayoutbox = awful.widget.layoutbox(s)
        -- s.mylayoutbox:buttons(
        --     gears.table.join(
        --         awful.button(
        --             {},
        --             1,
        --             function()
        --                 awful.layout.inc(1)
        --             end
        --         ),
        --         awful.button(
        --             {},
        --             3,
        --             function()
        --                 awful.layout.inc(-1)
        --             end
        --         ),
        --         awful.button(
        --             {},
        --             4,
        --             function()
        --                 awful.layout.inc(1)
        --             end
        --         ),
        --         awful.button(
        --             {},
        --             5,
        --             function()
        --                 awful.layout.inc(-1)
        --             end
        --         )
        --     )
        -- )

        -- Create the wibox
        s.mywibox =
            awful.wibar(
            {
                position = beautiful.wibar_position,
                screen = s,
                width = beautiful.wibar_width,
                height = beautiful.wibar_height,
                shape = helpers.rrect(beautiful.wibar_border_radius)
            }
        )
        -- Wibar items
        -- Add or remove widgets here
        s.mywibox:setup {
            {
                {
                    -- Some padding
                    layout = wibox.layout.fixed.horizontal
                },
                spacing = dpi(12),
                layout = wibox.layout.fixed.horizontal
            },
            text_taglist,
            expand = "none",
            -- minimal_tasklist,
            -- s.mytasklist,
            -- s.mylayoutbox,
            -- s.mypromptbox,
            layout = wibox.layout.align.horizontal
        }
    end
)
