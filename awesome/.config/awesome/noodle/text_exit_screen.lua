local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad
local keygrabber = require("awful.keygrabber")

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or 140
local text_font = beautiful.exit_screen_font or "EtBembo Italic 18"
local icon_font = "voidcorp 130"

local shutdown_text_icon = ""
local restart_text_icon = ""
local exit_text_icon = ""
local lock_text_icon = ""

-- Commands
local shutdown_command = function()
  awful.spawn.with_shell("sudo shutdown now")
  awful.keygrabber.stop(exit_screen_grabber)
end
local restart_command = function()
  awful.spawn.with_shell("sudo restart")
  awful.keygrabber.stop(exit_screen_grabber)
end
local exit_command = function()
  awesome.quit()
end
local lock_command = function()
  awful.spawn.with_shell("i3lock")
  exit_screen_hide()
end

local goodbye_widget = wibox.widget.textbox("ciao ")
goodbye_widget.font = "Lato Light 70"

local shutdown_icon = wibox.widget.textbox(shutdown_text_icon)
shutdown_icon.font = icon_font
shutdown_icon.markup = helpers.colorize_text(shutdown_icon.text, beautiful.xcolor1)
local shutdown_text = wibox.widget.textbox("shutdown")
shutdown_text.font = text_font

local shutdown = wibox.widget{
  {
    nil,
    shutdown_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(1),
    shutdown_text,
    pad(1),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
shutdown:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     shutdown_command()
                 end)
))

local restart_icon = wibox.widget.textbox(restart_text_icon)
restart_icon.font = icon_font
restart_icon.markup = helpers.colorize_text(restart_icon.text, beautiful.xcolor2)
local restart_text = wibox.widget.textbox("restart")
restart_text.font = text_font

local restart = wibox.widget{
  {
    nil,
    restart_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    nil,
    restart_text,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
restart:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                       restart_command()
                   end)
))

local exit_icon = wibox.widget.textbox(exit_text_icon)
exit_icon.font = icon_font
exit_icon.markup = helpers.colorize_text(exit_icon.text, beautiful.xcolor4)
local exit_text = wibox.widget.textbox("exit")
exit_text.font = text_font

local exit = wibox.widget{
  {
    nil,
    exit_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    nil,
    exit_text,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
exit:buttons(gears.table.join(
                  awful.button({ }, 1, function ()
                      exit_command()
                  end)
))

local lock_icon = wibox.widget.textbox(lock_text_icon)
lock_icon.font = icon_font
lock_icon.markup = helpers.colorize_text(lock_icon.text, beautiful.xcolor5)
local lock_text = wibox.widget.textbox("lock")
lock_text.font = text_font

local lock = wibox.widget{
  {
    nil,
    lock_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(1),
    lock_text,
    pad(1),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
lock:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                       lock_command()
                   end)
))

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Create the widget
exit_screen = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock", height = screen_height, width = screen_width})

exit_screen.bg = beautiful.exit_screen_bg or beautiful.wibar_bg or "#111111"
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"

local exit_screen_grabber
function exit_screen_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end
function exit_screen_show()
  exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
      if event == "release" then return end

      if     key == 'e'    then
        exit_command()
      elseif key == 'l'    then
        lock_command()
      elseif key == 's'    then
        shutdown_command()
      elseif key == 'r'    then
        restart_command()
      elseif key == 'Escape' or key == 'q' or key == 'x' then
        exit_screen_hide()
      -- else awful.keygrabber.stop(exit_screen_grabber)
      end
  end)
  exit_screen.visible = true
end

exit_screen:buttons(gears.table.join(
                 -- Middle click - Hide exit_screen
                 awful.button({ }, 2, function ()
                     exit_screen_hide()
                 end),
                 -- Right click - Hide exit_screen
                 awful.button({ }, 3, function ()
                     exit_screen_hide()
                 end)
))

-- Item placement
exit_screen:setup {
  nil,
  {
    {
      nil,
      --goodbye_widget,
      nil,
      expand = "none",
      layout = wibox.layout.align.horizontal
    },
    {
      nil,
      {
        -- {
          shutdown,
          restart,
          lock,
          exit,
          spacing = dpi(90),
          layout = wibox.layout.fixed.horizontal
        -- },
        -- widget = exit_screen_box
      },
      nil,
      expand = "none",
      layout = wibox.layout.align.horizontal
      -- layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.fixed.vertical
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.vertical
}
