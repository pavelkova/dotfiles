local theme_collection = {
      "paradise",        -- 1 --
      "paradiselost",    -- 2 --
  }

  -- Change this number to use a different theme
  local theme_name = theme_collection[2]

  ----------------------------------------------

  local bar_theme_collection = {
      "paradise",     -- 1 -- Start button, taglist, layout
      "paradiselost", -- 2 -- Weather, taglist, window buttons, pop-up tray
  }

  -- Change this number to use a different bar theme
  local bar_theme_name = bar_theme_collection[2]

  --------------------------------------------------------------------------------

  -- Jit
  --pcall(function() jit.on() end)

  -- Theme handling library
  local beautiful = require("beautiful")
  -- backgrounds used by wpgtk
  local wallpaper_dir = os.getenv("HOME") .. "/.local/share/backgrounds/"
  -- Themes define colours, icons, font and wallpapers.
  local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
  beautiful.init( theme_dir .. theme_name .. "/theme.lua" )
  --beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

  -- Standard awesome library
  local gears = require("gears")
  local awful = require("awful")
  require("awful.autofocus")
  -- Widget and layout library
  local wibox = require("wibox")
  -- Default notification library
  local naughty = require("naughty")
  local menubar = require("menubar")

  local hotkeys_popup = require("awful.hotkeys_popup").widget
  require("awful.hotkeys_popup.keys")

  -- ~~ Noodle Cleanup Script ~~
  -- Some of my widgets (mpd, volume) rely on scripts that have to be
  -- run persistently in the background.
  -- They sleep until mpd/volume state changes, in an infinite loop.
  -- As a result when awesome restarts, they keep running in background, along with the new ones that are created after the restart.
  -- This script cleans up the old processes.
  awful.spawn.with_shell("~/.config/awesome/awesome-cleanup.sh")

  -- {{{ Initialize stuff

  -- Basic (required)
  local helpers = require("helpers")
  local keys = require("keys")
  local titlebars = require("titlebars")

  -- Extra features
  local bars = require("bar_themes."..bar_theme_name)
  local sidebar = require("noodle.sidebar")
  local exit_screen = require("noodle.text_exit_screen")
  -- local exit_screen = require("noodle.exit_screen")
  local start_screen = require("noodle.start_screen")
  -- local tag_notifications = require("noodle.tag_notifications")

  -- Third party
  -- local radical = require("radical")
  -- }}}

  -- {{{ Error handling
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  if awesome.startup_errors then
      naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors })
  end

  -- Handle runtime errors after startup
  do
      local in_error = false
      awesome.connect_signal("debug::error", function (err)
          -- Make sure we don't go into an endless error loop
          if in_error then return end
          in_error = true

          naughty.notify({ preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = tostring(err) })
          in_error = false
      end)
  end
  -- }}}

  -- {{{ Variable definitions
  emulator = "alacritty"
  terminal = emulator .. " -e fish"
  -- Some terminals do not respect spawn callbacks
  floating_terminal = "cool-retro-term -c fst" -- clients with class "fst" are set to be floating (check awful.rules below)
  browser = "firefox"
  filemanager = "Thunar"
  tmux = terminal .. " -e tmux new "
  editor = "micro"
  --editor = os.getenv("EDITOR") or "nano"
  editor_cmd = terminal.." -e "..editor.." "

  -- Get screen geometry
  screen_width = awful.screen.focused().geometry.width
  screen_height = awful.screen.focused().geometry.height

  -- Table of layouts to cover with awful.layout.inc, order matters.
  awful.layout.layouts = {
      -- I only ever use these 3
      awful.layout.suit.tile,
      awful.layout.suit.floating,
      awful.layout.suit.max,
      --awful.layout.suit.spiral,
      --awful.layout.suit.spiral.dwindle,
      --awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      --awful.layout.suit.fair.horizontal,
      --awful.layout.suit.tile.left,
      --awful.layout.suit.tile.bottom,
      --awful.layout.suit.max.fullscreen,
      --awful.layout.suit.corner.nw,
      --awful.layout.suit.magnifier,
      --awful.layout.suit.corner.ne,
      --awful.layout.suit.corner.sw,
      --awful.layout.suit.corner.se,
  }
  -- }}}

  -- {{{ Notifications
  -- TODO: some options are not respected when the notification is created
  -- through lib-notify. Naughty works as expected.

  -- Icon size
  naughty.config.defaults['icon_size'] = beautiful.notification_icon_size

  -- Timeouts
  naughty.config.defaults.timeout = 5
  naughty.config.presets.low.timeout = 2
  naughty.config.presets.critical.timeout = 12

  -- Apply theme variables
  naughty.config.padding = beautiful.notification_padding
  naughty.config.spacing = beautiful.notification_spacing
  naughty.config.defaults.margin = beautiful.notification_margin
  naughty.config.defaults.border_width = beautiful.notification_border_width

  naughty.config.presets.normal = {
      font         = beautiful.notification_font,
      fg           = beautiful.notification_fg,
      bg           = beautiful.notification_bg,
      border_width = beautiful.notification_border_width,
      margin       = beautiful.notification_margin,
      position     = beautiful.notification_position
  }

  naughty.config.presets.low = {
      font         = beautiful.notification_font,
      fg           = beautiful.notification_fg,
      bg           = beautiful.notification_bg,
      border_width = beautiful.notification_border_width,
      margin       = beautiful.notification_margin,
      position     = beautiful.notification_position
  }

  naughty.config.presets.ok = naughty.config.presets.low
  naughty.config.presets.info = naughty.config.presets.low
  naughty.config.presets.warn = naughty.config.presets.normal

  naughty.config.presets.critical = {
      font         = beautiful.notification_font,
      fg           = beautiful.notification_crit_fg,
      bg           = beautiful.notification_crit_bg,
      border_width = beautiful.notification_border_width,
      margin       = beautiful.notification_margin,
      position     = beautiful.notification_position
  }

  -- }}}

  -- {{{ Menu
  -- Create a launcher widget and a main menu
  myawesomemenu = {
      { "hotkeys", function() return false, hotkeys_popup.show_help end, beautiful.keyboard_icon},
      { "restart", awesome.restart, beautiful.reboot_icon },
      { "quit", function() exit_screen_show() end, beautiful.poweroff_icon}
  }

  mymainmenu = awful.menu({ items = {
      { "awesome", myawesomemenu, beautiful.home_icon },
      { "firefox", browser, beautiful.firefox_icon },
      { "terminal", terminal, beautiful.terminal_icon },
      { "files", filemanager, beautiful.files_icon },
      { "search", "rofi", beautiful.search_icon },
  }
  })

  mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
  menu = mymainmenu })
  -- Menubar configuration
  menubar.utils.terminal = terminal -- Set the terminal for applications that require it
  -- }}}

  local function set_wallpaper(s)
      -- Wallpaper
      if beautiful.wallpaper then
          local wallpaper = beautiful.wallpaper
          -- If wallpaper is a function, call it with the screen
          if type(wallpaper) == "function" then
              wallpaper = wallpaper(s)
          end

          -- Set wpg wallpaper with feh
        awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")

      end
  end

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", set_wallpaper)

  awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s)

      -- Each screen has its own tag table.
      -- Tag layouts
      local l = awful.layout.suit -- Alias to save time :)
      -- local layouts = { l.max, l.floating, l.max, l.max , l.tile,
      --     l.max, l.max, l.max, l.floating, l.tile}
      local layouts = { l.tile, l.tile, l.tile, l.tile , l.tile,
      l.tile, l.tile, l.tile, l.tile, l.tile}

      -- Tag names
      local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
      -- Create all tags at once (without seperate configuration for each tag)
       awful.tag(tagnames, s, layouts)
  end)

  -- {{{ Rules
  -- Rules to apply to new clients (through the "manage" signal).
  awful.rules.rules = {
      -- All clients will match this rule.
      { rule = { },
          properties = { border_width = beautiful.border_width,
              border_color = beautiful.border_normal,
              focus = awful.client.focus.filter,
              raise = true,
              keys = keys.clientkeys,
              buttons = keys.clientbuttons,
              screen = awful.screen.preferred,
              size_hints_honor = false,
              honor_workarea = true,
              honor_padding = true,
              placement = awful.placement.no_overlap+awful.placement.no_offscreen }
          },

      -- Add titlebars to normal clients and dialogs
      { rule_any = { type = { "normal", "dialog" }
          }, properties = { titlebars_enabled = true },
      },

      -- Floating clients
      { rule_any = {
          instance = {
              "copyq",  -- Includes session name in class.
          },
          class = {
             "cool-retro-term",
             "mpv",
             "Lxappearance",
             "Nm-connection-editor",
             "MPlayer",
             "vdpau",
             "feh",
             "sxiv",
             "xv",
             "fst",
          },
          name = {
             "Event Tester",  -- xev
             "Todoist",
          },
          role = {
              "pop-up",
          },
          type = {
              "dialog",
          }
      }, properties = { floating = true, ontop = false }},

      -- "Switch to tag"
      -- These clients make you switch to their tag when they appear
      { rule_any = {
          class = {
              -- "Firefox",
              -- "Chromium-browser",
              -- "qutebrowser",
          },
      }, properties = { switchtotag = true }},


      -- Titlebars ON (explicitly)
      -- Titlebars of these clients will be shown regardless of the theme setting
      { rule_any = {
          class = {
              --"???",
          },
          type = {
              "dialog",
          },
          role = {
              "conversation",
          }
      }, properties = {},
      callback = function (c)
          awful.titlebar.show(c)
      end
      },


      -- Pavucontrol
      { rule_any = {
          class = {
              "Pavucontrol",
          },
      }, properties = { floating = true, dockable = true, width = screen_width * 0.35, height = screen_height * 0.3 },
        callback = function (c)
           awful.titlebar.show(c)
        end
      },

       -- Todoist
      { rule_any = {
          name = {
              "Todoist",
          },
      }, properties = { floating = true, width = screen_width * 0.35, height = screen_height * 0.5 }
      },

      -- Steam guard
      { rule = { name = "Steam Guard - Computer Authorization Required" },
      properties = { floating = true },
      callback = function (c)
          -- gears.timer.delayed_call(function()
          --     awful.placement.centered(c,{honor_workarea=true})
          -- end)
      end
      }
  }
  -- }}}

  -- {{{ Signals
  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c)
      -- Set every new window as a slave,
      -- i.e. put it at the end of others instead of setting it master.
      if not awesome.startup then awful.client.setslave(c) end

      if awesome.startup and
          not c.size_hints.user_position
          and not c.size_hints.program_position then
          -- Prevent clients from being unreachable after screen count changes.
          awful.placement.no_offscreen(c)
      end

  end)


  -- Hide titlebars if required by the theme
  client.connect_signal("manage", function (c)
      if not beautiful.titlebars_enabled then
          awful.titlebar.hide(c)
      end
  end)

  -- If the layout is not floating, every floating client that appears is centered
  -- If the layout is floating, and there is no other client visible, center it
  client.connect_signal("manage", function (c)
      if not awesome.startup then
          if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
              awful.placement.centered(c,{honor_workarea=true})
          else if #mouse.screen.clients == 1 then
                  awful.placement.centered(c,{honor_workarea=true})
              end
          end
      end
  end)

  -- Enable sloppy focus, so that focus follows mouse.
  client.connect_signal("mouse::enter", function(c)
     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
         and awful.client.focus.filter(c) then
         client.focus = c
     end
  end)

  -- Rounded corners
  if beautiful.border_radius ~= 0 then
      client.connect_signal("manage", function (c, startup)
          if not c.fullscreen then
              c.shape = helpers.rrect(beautiful.border_radius)
          end
      end)

      -- Fullscreen clients should not have rounded corners
      client.connect_signal("property::fullscreen", function (c)
          if c.fullscreen then
              c.shape = helpers.rect()
          else
              c.shape = helpers.rrect(beautiful.border_radius)
          end
      end)
  end

  -- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
  -- Fixes wrong geometry when titlebars are enabled
  --client.connect_signal("property::fullscreen", function(c)
  client.connect_signal("manage", function(c)
      if c.fullscreen then
          gears.timer.delayed_call(function()
              if c.valid then
                  c:geometry(c.screen.geometry)
              end
          end)
      end
  end)

  -- Center client when floating property changes
  --client.connect_signal("property::floating", function(c)
  --awful.placement.centered(c,{honor_workarea=true})
  --end)

  -- Apply shapes
  -- beautiful.notification_shape = helpers.infobubble(beautiful.notification_border_radius)
  beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
  beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
  beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)

  client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
  client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

  -- Set mouse resize mode (live or after)
  awful.mouse.resize.set_mode("live")

  -- Floating: restore geometry
  tag.connect_signal('property::layout',
  function(t)
      for k, c in ipairs(t:clients()) do
          if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
              -- Geometry x = 0 and y = 0 most probably means that the
              -- clients have been spawned in a non floating layout, and thus
              -- they don't have their floating_geometry set properly.
              -- If that is the case, don't change their geometry
              local cgeo = awful.client.property.get(c, 'floating_geometry')
              if cgeo ~= nil then
                  if not (cgeo.x == 0 and cgeo.y == 0) then
                      c:geometry(awful.client.property.get(c, 'floating_geometry'))
                  end
              end
              --c:geometry(awful.client.property.get(c, 'floating_geometry'))
          end
      end
  end
  )

  client.connect_signal('manage',
  function(c)
      if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
          awful.client.property.set(c, 'floating_geometry', c:geometry())
      end
  end
  )

  client.connect_signal('property::geometry',
  function(c)
      if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
          awful.client.property.set(c, 'floating_geometry', c:geometry())
      end
  end
  )

  -- Make rofi able to unminimize minimized clients
  client.connect_signal("request::activate",
  function(c, context, hints)
      if not awesome.startup then
          if c.minimized then
              c.minimized = false
          end
          awful.ewmh.activate(c, context, hints)
      end
  end
  )


  -- Startup applications
  --awful.spawn.with_shell("autostart.common")
  --awful.spawn.with_shell("autostart.dark-paradise")
  -- }}}
