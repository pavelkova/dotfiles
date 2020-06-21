local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local vicious = require("vicious")
local widgets = require("widgets.sidebar")
local helpers = require("helpers")
local pad = helpers.pad

-- Some commonly used variables
local icon_size = dpi(36)
local progress_bar_width = dpi(215)
-- local progress_bar_margins = dpi(9)

-- Item configuration
local exit_icon = wibox.widget.imagebox(beautiful.poweroff_icon)
exit_icon.resize = true
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = "Cantarell 11"

local exit = wibox.widget{
  exit_icon,
  exit_text,
  layout = wibox.layout.fixed.horizontal
}
exit:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     exit_screen_show()
                     sidebar.visible = false
                 end)
))

    -- Create text weather widget
local text_weather = require("noodle.text_weather")
local weather_widget_icon = text_weather:get_all_children()[1]
weather_widget_icon.font = "Typicons 24"
weather_widget_icon.forced_width = icon_size
weather_widget_icon.forced_height = icon_size
local weather_widget_text = text_weather:get_all_children()[2]
weather_widget_text.font = "Cantarell 11"

local weather = wibox.widget{
    nil,
    text_weather,
    nil,
    layout = wibox.layout.align.horizontal,
    forced_width = dpi(252),
    expand = "outside"
}

local battery = require("widgets.sidebar.battery_bar")

local cpu = require("widgets.sidebar.cpu_bar")

local ram = require("widgets.sidebar.ram_bar")

local temperature = require("widgets.sidebar.temperature_bar")

local volume_bar = require("widgets.sidebar.volume_bar")

local time = wibox.widget.textclock("%H %M")
time.align = "center"
time.valign = "center"
time.font = "Cantarell Thin 75"

local date = wibox.widget.textclock("%A, %d %B")
date.align = "center"
date.valign = "center"
date.font = "EtBembo Italic 18"



local search_icon = wibox.widget.imagebox(beautiful.search_icon)
search_icon.resize = true
search_icon.forced_width = icon_size
search_icon.forced_height = icon_size
local search_text = wibox.widget.textbox("Search")
search_text.font = "Cantarell 12"



-- Create the sidebar
sidebar = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock"})
sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = awful.screen.focused().geometry.height or dpi(1080) or beautiful.sidebar_height
sidebar.width = beautiful.sidebar_width or dpi(400)
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.sidebar_border_radius or 0
if beautiful.sidebar_position == "right" then
  sidebar.x = awful.screen.focused().geometry.width - sidebar.width
  sidebar.shape = helpers.prrect(radius, true, false, false, true)
else
  sidebar.x = beautiful.sidebar_x or 0
  sidebar.shape = helpers.prrect(radius, false, true, true, false)
end
-- sidebar.shape = helpers.rrect(radius)

sidebar:buttons(gears.table.join(
                  -- Middle click - Hide sidebar
                  awful.button({ }, 2, function ()
                      sidebar.visible = false
                  end)
                  -- Right click - Hide sidebar
                  -- awful.button({ }, 3, function ()
                  --     sidebar.visible = false
                  --     -- mymainmenu:show()
                  -- end)
))

-- Hide sidebar when mouse leaves
if beautiful.sidebar_hide_on_mouse_leave then
  sidebar:connect_signal("mouse::leave", function ()
                           sidebar.visible = false
  end)
end
-- Activate sidebar by moving the mouse at the edge of the screen
if beautiful.sidebar_hide_on_mouse_leave then
  local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true})
  sidebar_activator.height = sidebar.height
  -- sidebar_activator.height = sidebar.height - beautiful.wibar_height
  sidebar_activator:connect_signal("mouse::enter", function ()
                                     sidebar.visible = true
  end)

  if beautiful.sidebar_position == "right" then
    sidebar_activator.x = awful.screen.focused().geometry.width - sidebar_activator.width
  else
    sidebar_activator.x = 0
  end

  sidebar_activator:buttons(
    gears.table.join(
      -- awful.button({ }, 2, function ()
      --     start_screen_show()
      --     -- sidebar.visible = not sidebar.visible
      -- end),
      awful.button({ }, 4, function ()
          awful.tag.viewprev()
      end),
      awful.button({ }, 5, function ()
          awful.tag.viewnext()
      end)
  ))
end

local systray = wibox.widget.systray()
systray.forced_height = dpi(14)
systray.opacity = 0.8
systray.set_base_size(14)
beautiful.systray_icon_spacing = dpi(8)

-- Item placement
sidebar:setup {
  { ----------- TOP GROUP -----------
    pad(1),
    pad(1),
    pad(1),
    pad(1),
    time,
    pad(1),
    date,
    pad(1),
    pad(1),

    {
      -- Put some padding at the left and right edge so that
      -- it looks better with extremely long titles/artists
      pad(2),
      pad(2),
      layout = wibox.layout.align.horizontal,
    },
    pad(1),
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- MIDDLE GROUP -----------
    pad(1),
    volume,
    pad(1),
    cpu,
    pad(1),
    temperature,
    pad(1),
    ram,
    pad(1),
    battery,
    pad(1),
    weather,
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- BOTTOM GROUP -----------
    { -- Search and exit screen
      nil,
      {
        systray,
        --pad(1),
        --exit,
        pad(2),
        layout = wibox.layout.fixed.horizontal
      },
      nil,
      layout = wibox.layout.align.horizontal,
      expand = "none"
    },
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  layout = wibox.layout.align.vertical,
  -- expand = "none"
}
