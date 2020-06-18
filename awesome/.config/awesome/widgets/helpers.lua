local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local vicious = require("vicious")
local helpers = require("helpers")
local pad = helpers.pad

-- Configuration
-- local _widget = wibox.widget.progressbar()

local widget_helpers = {}

function widget_helpers.create_widget_stack(widget, text, active_color, background_color)
   local widget_stack = wibox.widget{
   {
      max_value     = 100,
      value         = 50,
      forced_height = dpi(10),
      margins       = {
         top = dpi(8),
         bottom = dpi(8),
      },
      forced_width  = dpi(200),
      shape         = gears.shape.rounded_bar,
      bar_shape     = gears.shape.rounded_bar,
      color         = active_color,
      background_color = background_color,
      border_width  = 0,
      border_color  = beautiful.border_color,
      widget        = widget,
   },
   {
      text = text,
      font = "Cantarell Medium 7",
      valign = "center",
      widget = wibox.widget.textbox,
   },
   layout = wibox.layout.stack
   }
   widget_stack.forced_width = dpi(215)
   return widget_stack
end


function widgethelpers.create_text_icon(icon_text)
   local text_icon = wibox.widget.textbox()
   local text_icon = wibox.widget{
      text = icon_text,
      valign = 'center',
      widget = wibox.widget.textbox
   }

   text_icon.forced_width = dpi(36)
   text_icon.forced_height = dpi(36)
   text_icon.font = "voidcorp 24"
   return text_icon
end

function helpers.create_status_bar(widget_icon, widget_stack)
   widget_stack.forced_width = dpi(215)

   return wibox.widget{
  nil,
  {
    widget_icon,
    self.pad(1),
    widget_stack,
    self.pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}
end



return helpers


-- function helpers.create_status_bar(
--    widget,
--    text,
--    text_font,
--    active_color,
--    background_color,
--    status_bar_width,
--    icon_text,
--    icon_size,
--    icon_font)


-- end
