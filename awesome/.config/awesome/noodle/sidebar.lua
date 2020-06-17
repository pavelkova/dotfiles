local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

-- Some commonly used variables
local playerctl_button_size = dpi(60)
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

local temperature_icon = wibox.widget.textbox()
local temperature_icon = wibox.widget{
   text = "",
   valign = 'center',
   widget = wibox.widget.textbox
}
temperature_icon.font = "voidcorp 24"

local temperature_bar = require("noodle.temperature_bar")
temperature_bar.forced_width = progress_bar_width
local temperature = wibox.widget{
  nil,
  {
    temperature_icon,
    pad(1),
    temperature_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}
temperature:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        -- local matcher = function (c)
        --   return awful.rules.match(c, {name = 'watch sensors'})
        -- end
        -- awful.client.run_or_raise(terminal .." -e 'watch sensors'", matcher)
        awful.spawn(terminal .. " -e 'watch sensors'", {floating = true})
    end)
))

local battery_icon = wibox.widget.textbox()
local battery_icon = wibox.widget{
   text = "",
   align = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}

battery_icon.forced_width = icon_size
battery_icon.forced_height = icon_size
battery_icon.font = "voidcorp 24"

local battery_bar = require("noodle.battery_bar")
battery_bar.forced_width = progress_bar_width
-- battery_bar.margins.top = progress_bar_margins
-- battery_bar.margins.bottom = progress_bar_margins
local battery = wibox.widget{
   nil,
  {
    battery_icon,
    pad(1),
    battery_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local cpu_icon = wibox.widget.textbox()
local cpu_icon = wibox.widget{
   text = "",
   valign = 'center',
   widget = wibox.widget.textbox
}
cpu_icon.forced_width = icon_size
cpu_icon.forced_height = icon_size
cpu_icon.font = "voidcorp 24"

local cpu_bar = require("noodle.cpu_bar")
cpu_bar.forced_width = progress_bar_width
local cpu = wibox.widget{
  nil,
  {
    cpu_icon,
    pad(1),
    cpu_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

cpu:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {name = 'htop'})
        end
        awful.client.run_or_raise(terminal .." -e htop", matcher)
    end),
    awful.button({ }, 3, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Lxtask'})
        end
        awful.client.run_or_raise("lxtask", matcher)
    end)
))

local ram_icon = wibox.widget.textbox()
local ram_icon = wibox.widget{
   text = "",
   valign = 'center',
   widget = wibox.widget.textbox
}
ram_icon.forced_width = icon_size
ram_icon.forced_height = icon_size
ram_icon.font = "voidcorp 24"

local ram_bar = require("noodle.ram_bar")
ram_bar.forced_width = progress_bar_width
-- ram_bar.margins.top = progress_bar_margins
-- ram_bar.margins.bottom = progress_bar_margins
local ram = wibox.widget{
  nil,
  {
    ram_icon,
    pad(1),
    ram_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

ram:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {name = 'htop'})
        end
        awful.client.run_or_raise(terminal .." -e htop", matcher)
    end),
    awful.button({ }, 3, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Lxtask'})
        end
        awful.client.run_or_raise("lxtask", matcher)
    end)
))

local playerctl_toggle_icon = wibox.widget.textbox()
local playerctl_toggle_icon = wibox.widget{
   text = "",
   align = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}
playerctl_toggle_icon.forced_width = playerctl_button_size
playerctl_toggle_icon.forced_height = playerctl_button_size
playerctl_toggle_icon.font = "voidcorp 42"



playerctl_toggle_icon:buttons(gears.table.join(
                         awful.button({ }, 1, function ()
                             awful.spawn.with_shell("mpc toggle")
                         end),
                         awful.button({ }, 3, function ()
                             awful.spawn.with_shell("mpvc toggle")
                         end)
))

local playerctl_prev_icon = wibox.widget.textbox()
local playerctl_prev_icon = wibox.widget{
   text = "",
   align = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}
playerctl_prev_icon.forced_width = playerctl_button_size
playerctl_prev_icon.forced_height = playerctl_button_size
playerctl_prev_icon.font = "voidcorp 18"

playerctl_prev_icon:buttons(gears.table.join(
                         awful.button({ }, 1, function ()
                             awful.spawn.with_shell("mpc prev")
                         end),
                         awful.button({ }, 3, function ()
                             awful.spawn.with_shell("mpvc prev")
                         end)
))

local playerctl_next_icon = wibox.widget.textbox()
local playerctl_next_icon = wibox.widget{
   text = "",
   align = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}
playerctl_next_icon.forced_width = playerctl_button_size
playerctl_next_icon.forced_height = playerctl_button_size
playerctl_next_icon.font = "voidcorp 18"

playerctl_next_icon:buttons(gears.table.join(
                         awful.button({ }, 1, function ()
                             awful.spawn.with_shell("mpc next")
                         end),
                         awful.button({ }, 3, function ()
                             awful.spawn.with_shell("mpvc next")
                         end)
))

local playerctl_buttons = wibox.widget {
  nil,
  {
    playerctl_prev_icon,
    pad(1),
    playerctl_toggle_icon,
    pad(1),
    playerctl_next_icon,
    layout  = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal,
}

local time = wibox.widget.textclock("%H %M")
time.align = "center"
time.valign = "center"
time.font = "Cantarell Thin 75"

local date = wibox.widget.textclock("%A, %d %B")
date.align = "center"
date.valign = "center"
date.font = "EtBembo Italic 18"

-- local mpd_song = require("noodle.mpd_song")
-- local mpd_widget_children = mpd_song:get_all_children()
-- local mpd_title = mpd_widget_children[1]
-- local mpd_artist = mpd_widget_children[2]
-- mpd_title.font = "Cantarell 12"
-- mpd_artist.font = "Cantarell 10"

-- -- Set forced height in order to limit the widgets to one line.
-- -- Might need to be adjusted depending on the font.
-- mpd_title.forced_height = dpi(24)
-- mpd_artist.forced_height = dpi(16)

-- mpd_song:buttons(gears.table.join(
--                 awful.button({ }, 1, function ()
--                     awful.spawn.with_shell("mpc toggle")
--                 end),
--                 awful.button({ }, 3, function ()
--                     -- Spawn music terminal
--                     awful.spawn("music_terminal")
--                 end),
--                 awful.button({ }, 4, function ()
--                     awful.spawn.with_shell("mpc prev")
--                 end),
--                 awful.button({ }, 5, function ()
--                     awful.spawn.with_shell("mpc next")
--                 end)
-- ))



local search_icon = wibox.widget.imagebox(beautiful.search_icon)
search_icon.resize = true
search_icon.forced_width = icon_size
search_icon.forced_height = icon_size
local search_text = wibox.widget.textbox("Search")
search_text.font = "Cantarell 12"

-- local volume_icon = wibox.widget.imagebox(beautiful.volume_icon)
-- volume_icon.resize = true
-- volume_icon.forced_width = icon_size
-- volume_icon.forced_height = icon_size
local volume_icon = wibox.widget.textbox()
local volume_icon = wibox.widget{
   text = "",
   align = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}
volume_icon.forced_width = icon_size
volume_icon.forced_height = icon_size
volume_icon.font = "voidcorp 24"

local volume_bar = require("noodle.volume_bar")
volume_bar.forced_width = progress_bar_width
-- volume_bar.shape = gears.shape.circle
-- volume_bar.margins.top = progress_bar_margins
-- volume_bar.margins.bottom = progress_bar_margins
local volume = wibox.widget{
  nil,
  {
    volume_icon,
    pad(1),
    volume_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

volume:buttons(gears.table.join(
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
    -- playerctl_buttons,
    {
      -- Put some padding at the left and right edge so that
      -- it looks better with extremely long titles/artists
      pad(2),
      -- mpd_song,
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
