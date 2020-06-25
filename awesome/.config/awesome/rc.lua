local theme_name = "paradise"
local bar_theme_name = "paradise"

--------------------------------------------------------------------------------

-- Jit
--pcall(function() jit.on() end)

-- Theme handling library
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- backgrounds used by wpgtk
local wallpaper_dir = os.getenv("HOME") .. "/.local/share/backgrounds/"
-- Themes define colours, icons, font and wallpapers.
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init(theme_dir .. theme_name .. "/theme.lua")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Default notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

-- {{{ Initialize stuff

-- Basic (required)
local helpers = require("helpers")
local keys = require("keys")

-- Extra features
local topbar = require("components.topbar")
local sidebar = require("components.sidebar")
local exit_screen = require("noodle.text_exit_screen")
-- local start_screen = require("noodle.start_screen")
-- }}}


------------------
-- APPLICATIONS --
------------------

-- {{{ Variable definitions
terminal = "alacritty"
-- Some terminals do not respect spawn callbacks
browser = "firefox"
filemanager = "Thunar"
tmux = terminal .. " -e tmux new "
editor = "emacsclient -nw -a ''" or os.getenv("EDITOR") or "jmacs" or "nano"
editor_cmd = terminal .. " -e " .. editor .. ""

-- Get screen geometry
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

----------
-- MENU --
----------

-- {{{ Menu
-- Create a launcher widget and a main menu

local freedesktop = require("freedesktop")

myawesomemenu = {
    {"hotkeys", function()
            return false, hotkeys_popup.show_help
        end},
    {"manual", terminal .. " -e man awesome"},
    {"edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile)},
    {"restart", awesome.restart},
    {"quit", function()
            awesome.quit()
        end}
}

mymainmenu =
    freedesktop.menu.build(
    {
        before = {
            {"Awesome", myawesomemenu, beautiful.awesome_icon}
            -- other triads can be put here
        },
        after = {
            {"firefox", browser, beautiful.firefox_icon},
            {"terminal", terminal, beautiful.terminal_icon},
            {"files", filemanager, beautiful.files_icon},
            {"search", "rofi", beautiful.search_icon}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)
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


-------------
-- LAYOUTS --
-------------

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)
        -- Each screen has its own tag table.
        -- Tag layouts
        local l = awful.layout.suit -- Alias to save time :)
        -- local layouts = { l.max, l.floating, l.max, l.max , l.tile,
        --     l.max, l.max, l.max, l.floating, l.tile}
        local layouts = {
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile,
            l.tile
        }

        -- Tag names
        local tagnames = beautiful.tagnames or {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}
        -- Create all tags at once (without seperate configuration for each tag)
        awful.tag(tagnames, s, layouts)
    end
)

------------------
-- CLIENT RULES --
------------------

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            -- defaults
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            -- added
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true
        }
    },
    -- Floating clients
    {
        rule_any = {
            instance = {
                "copyq" -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "cool-retro-term",
                "feh",
                "fst",
                "Lxappearance",
                "MPlayer",
                "mpv",
                "Nm-connection-editor",
                "planner", "Planner",
                "Sxiv",
                "tilda", "Tilda",
                "vdpau",
                "xv"
            },
            name = {
                "Event Tester", -- xev
                "Todoist"
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up"
            },
            type = {
                "dialog"
            }
        },
        properties = {floating = true}
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {titlebars_enabled = true}
    },
    -- Always spawn certain applications on specific tags
    {
        rule = {class = "trilium notes"},
        properties = {screen = 1, tag = "10"}
    }
}
-- }}}


-------------------
-- SMART BORDERS --
-------------------

require("smart_borders") {
    show_button_tooltips = true,
    button_positions = {"top"},
    buttons = {"floating", "minimize", "maximize", "close"},
    layout = "fixed",
    button_ratio = 0.3,
    align_horizontal = "center",
    button_size = 40,
    button_floating_size = 60,
    button_close_size = 60,
    border_width = 10,
    color_close_normal = {
        type = "linear",
        from = {0, 0},
        to = {60, 0},
        stops = {{0, "#fd8489"}, {1, "#56666f"}}
    },
    color_close_focus = {
        type = "linear",
        from = {0, 0},
        to = {60, 0},
        stops = {{0, "#fd8489"}, {1, "#a1bfcf"}}
    },
    color_close_hover = {
        type = "linear",
        from = {0, 0},
        to = {60, 0},
        stops = {{0, "#FF9EA3"}, {1, "#a1bfcf"}}
    },
    color_floating_normal = {
        type = "linear",
        from = {0, 0},
        to = {40, 0},
        stops = {{0, "#56666f"}, {1, "#ddace7"}}
    },
    color_floating_focus = {
        type = "linear",
        from = {0, 0},
        to = {40, 0},
        stops = {{0, "#a1bfcf"}, {1, "#ddace7"}}
    },
    color_floating_hover = {
        type = "linear",
        from = {0, 0},
        to = {40, 0},
        stops = {{0, "#a1bfcf"}, {1, "#F7C6FF"}}
    },
    -- custom control example:
    button_back = function(c)
        -- set client as master
        c:swap(awful.client.getmaster())
    end
                         }

-------------
-- SIGNALS --
-------------

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set every new window as a slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then
            awful.client.setslave(c)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- If the layout is not floating, every floating client that appears is centered
-- If the layout is floating, and there is no other client visible, center it
client.connect_signal(
    "manage",
    function(c)
        if not awesome.startup then
            if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
                awful.placement.centered(c, {honor_workarea = true})
            else
                if #mouse.screen.clients == 1 then
                    awful.placement.centered(c, {honor_workarea = true})
                end
            end
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
            client.focus = c
        end
    end
)

-- Rounded corners
if beautiful.border_radius ~= 0 then
    client.connect_signal(
        "manage",
        function(c, startup)
            if not c.fullscreen then
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end
    )

    -- Fullscreen clients should not have rounded corners
    client.connect_signal(
        "property::fullscreen",
        function(c)
            if c.fullscreen then
                c.shape = helpers.rect()
            else
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end
    )
end

-- Center client when floating property changes
--client.connect_signal("property::floating", function(c)
--awful.placement.centered(c,{honor_workarea=true})
--end)

-- Apply shapes
beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

-- Floating: restore geometry
tag.connect_signal(
    "property::layout",
    function(t)
        for k, c in ipairs(t:clients()) do
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
                -- Geometry x = 0 and y = 0 most probably means that the
                -- clients have been spawned in a non floating layout, and thus
                -- they don't have their floating_geometry set properly.
                -- If that is the case, don't change their geometry
                local cgeo = awful.client.property.get(c, "floating_geometry")
                if cgeo ~= nil then
                    if not (cgeo.x == 0 and cgeo.y == 0) then
                        c:geometry(awful.client.property.get(c, "floating_geometry"))
                    end
                end
            --c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
)

client.connect_signal(
    "manage",
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, "floating_geometry", c:geometry())
        end
    end
)

client.connect_signal(
    "property::geometry",
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, "floating_geometry", c:geometry())
        end
    end
)

-- Make rofi able to unminimize minimized clients
client.connect_signal(
    "request::activate",
    function(c, context, hints)
        if not awesome.startup then
            if c.minimized then
                c.minimized = false
            end
            awful.ewmh.activate(c, context, hints)
        end
    end
)

-- }}}

-------------------
-- NOTIFICATIONS --
-------------------

-- {{{ Notifications
-- TODO: some options are not respected when the notification is created
-- through lib-notify. Naughty works as expected.

-- Icon size
naughty.config.defaults["icon_size"] = beautiful.notification_icon_size

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
    font = beautiful.notification_font,
    fg = beautiful.notification_fg,
    bg = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

naughty.config.presets.low = {
    font = beautiful.notification_font,
    fg = beautiful.notification_fg,
    bg = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.critical = {
    font = beautiful.notification_font,
    fg = beautiful.notification_crit_fg,
    bg = beautiful.notification_crit_bg,
    border_width = beautiful.notification_border_width,
    margin = beautiful.notification_margin,
    position = beautiful.notification_position
}

-- }}}

------------
-- ERRORS --
------------

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}
