local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

local keys = {}

-- Mod keys
superkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"
hyperkey = "Mod3"

-- {{{ Mouse bindings on desktop
keys.desktopbuttons =
    gears.table.join(
    awful.button(
        {superkey},
        1,
        function()
            mymainmenu:hide()
            sidebar.visible = false
            naughty.destroy_all_notifications()

            local function double_tap()
                uc = awful.client.urgent.get()
                -- If there is no urgent client, go back to last tag
                if uc == nil then
                    awful.tag.history.restore()
                else
                    awful.client.urgent.jumpto()
                end
            end
            helpers.single_double_tap(
                function()
                end,
                double_tap
            )
        end
    ),
    awful.button(
        {},
        3,
        function()
            mymainmenu:toggle()
        end
    )
)
-- }}}

-- {{{ Key bindings
keys.globalkeys =
    gears.table.join(
    -- AWESOME

    -- Super + ALT + k
    awful.key({superkey, altkey}, "k", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
    -- Super + SHIFT + v
    awful.key(
        {superkey, shiftkey},
        "v",
        function()
            mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}
    ),
    -- Super + ESC
    awful.key(
        {superkey},
        "Escape",
        function()
            exit_screen_show()
        end,
        {description = "exit", group = "awesome"}
    ),
    -- Super + <F1>
    -- Start screen
    awful.key(
        {superkey},
        "F1",
        function()
            start_screen_show()
        end,
        {description = "show start screen", group = "awesome"}
    ),
    -- Super + <XF86HomePage>
    -- Toggle sidebar
    awful.key(
        {superkey},
        "XF86HomePage",
        function()
            sidebar.visible = not sidebar.visible
        end,
        {description = "show or hide sidebar", group = "awesome"}
    ),
    -- Super + SHIFT + b
    -- Toggle wibar
    awful.key(
        {superkey, shiftkey},
        "b",
        function()
            local s = awful.screen.focused()
            s.mywibox.visible = not s.mywibox.visible
            if beautiful.wibar_detached then
                s.useless_wibar.visible = not s.useless_wibar.visible
            end
        end,
        {description = "show or hide wibar", group = "awesome"}
    ),
    -- Super + q
    -- Restart awesome
    awful.key({superkey}, "q", awesome.restart, {description = "reload awesome", group = "awesome"}),
    -- Super + CTRL + q
    -- Quit awesome
    awful.key({superkey, ctrlkey}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
    -- Prompt
    awful.key(
        {superkey},
        "d",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {description = "run prompt", group = "awesome"}
    ),
    ------------

    -- AWESOME : CLIENT : FOCUS --

    -- Focus client by direction
    -- Super + <DOWN>
    awful.key(
        {superkey},
        "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus down", group = "awesome : client : focus"}
    ),
    -- Super + <UP>
    awful.key(
        {superkey},
        "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus up", group = "awesome : client : focus"}
    ),
    -- Super + <LEFT>
    awful.key(
        {superkey},
        "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus left", group = "awesome : client : focus"}
    ),
    -- Super + <RIGHT>
    awful.key(
        {superkey},
        "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus right", group = "awesome : client : focus"}
    ),
    -- Focus client by index (cycle through clients)
    -- Super + TAB
    awful.key(
        {superkey},
        "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "awesome : client : focus"}
    ),
    -- Super + SHIFT + TAB
    awful.key(
        {superkey, shiftkey},
        "Tab",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "awesome : client : focus"}
    ),
    -- Super + u
    awful.key(
        {superkey},
        "u",
        function()
            uc = awful.client.urgent.get()
            -- If there is no urgent client, go back to last tag
            if uc == nil then
                awful.tag.history.restore()
            else
                awful.client.urgent.jumpto()
            end
        end,
        {description = "jump to urgent client", group = "awesome : client : focus"}
    ),
    -- Super + z
    awful.key(
        {superkey},
        "z",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "awesome : client : focus"}
    ),
    ------------

    -- AWESOME: CLIENTS : REARRANGE

    -- Super + SHIFT + <DOWN>
    awful.key(
        {superkey, shiftkey},
        "Down",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client to edge
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_to_edge(c, "down")
            else
                awful.client.swap.bydirection("down", c, nil)
            end
        end,
        {description = "swap with direction down", group = "awesome : client : rearrange"}
    ),
    -- Super + SHIFT + <UP>
    awful.key(
        {superkey, shiftkey},
        "Up",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client to edge
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_to_edge(c, "up")
            else
                awful.client.swap.bydirection("up", c, nil)
            end
        end,
        {description = "swap with direction up", group = "awesome : client : rearrange"}
    ),
    -- Super + SHIFT + <LEFT>
    -- Swap window with left
    awful.key(
        {superkey, shiftkey},
        "Left",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client to edge
            if c ~= nil and (current_layout == "floating" or c.floating) then
                --c:relative_move( -40,  0,   0,   0)
                helpers.move_to_edge(c, "left")
            else
                awful.client.swap.bydirection("left", c, nil)
            end
        end,
        {description = "swap with direction left", group = "awesome : client : rearrange"}
    ),
    -- Super + SHIFT + <RIGHT>
    -- Swap window with right
    awful.key(
        {superkey, shiftkey},
        "Right",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client to edge
            if c ~= nil and (current_layout == "floating" or c.floating) then
                --c:relative_move(  40,  0,   0,   0)
                helpers.move_to_edge(c, "right")
            else
                awful.client.swap.bydirection("right", c, nil)
            end
        end,
        {description = "swap with direction right", group = "awesome : client : rearrange"}
    ),
    ------------

    -- AWESOME : CLIENT : RESIZE

    -- Super + CTRL + <LEFT>
    -- Decrease width of master window
    awful.key(
        {superkey, ctrlkey},
        "Left",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: resize client
            if current_layout == "floating" or c.floating == true then
                c:relative_move(0, 0, dpi(-20), 0)
            else
                awful.tag.incmwfact(-0.05)
            end
        end,
        {description = "decrease master width factor", group = "awesome : client : resize"}
    ),
    -- Super + CTRL + <RIGHT>
    -- Increase width of master window
    awful.key(
        {superkey, ctrlkey},
        "Right",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: resize client
            if current_layout == "floating" or c.floating == true then
                c:relative_move(0, 0, dpi(20), 0)
            else
                awful.tag.incmwfact(0.05)
            end
        end,
        {description = "increase master width factor", group = "awesome : client : resize"}
    ),
    ------------

    -- AWESOME: LAYOUTS

    -- Super + h
    -- Increase number of masters
    awful.key(
        {superkey},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "awesome : layout"}
    ),
    -- Super + l
    -- Decrease number of masters
    awful.key(
        {superkey},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "awesome : layout"}
    ),
    -- Super + CTRL + h
    -- Increase number of columms
    awful.key(
        {superkey, ctrlkey},
        "h",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client
            if c ~= nil and (current_layout == "floating" or c.floating) then
                c:relative_move(dpi(-20), 0, 0, 0)
            else
                awful.tag.incncol(1, nil, true)
            end
        end,
        {description = "increase the number of columns", group = "awesome : layout"}
    ),
    -- Super + CTRL + l
    -- Decrease number of columns
    awful.key(
        {superkey, ctrlkey},
        "l",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            -- Floating: move client
            if c ~= nil and (current_layout == "floating" or c.floating) then
                c:relative_move(dpi(20), 0, 0, 0)
            else
                awful.tag.incncol(-1, nil, true)
            end
        end,
        {description = "increase the number of columns", group = "awesome : layout"}
    ),
    -- Super + SHIFT + t
    -- Switch to next layout
    awful.key(
        {superkey, shiftkey},
        "l",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next layout", group = "awesome : layout"}
    ),
    -- Set max layout
    awful.key(
        {superkey, shiftkey},
        "w",
        function()
            awful.layout.set(awful.layout.suit.max)
        end,
        {description = "set max layout", group = "awesome : layout"}
    ),
    -- Set tiled layout
    awful.key(
        {superkey},
        "s",
        function()
            awful.layout.set(awful.layout.suit.tile)
        end,
        {description = "set tiled layout", group = "awesome : layout"}
    ),
    -- Set floating layout
    awful.key(
        {superkey, shiftkey},
        "s",
        function()
            awful.layout.set(awful.layout.suit.floating)
        end,
        {description = "set floating layout", group = "awesome : layout"}
    ),
    ------------

    -- AWESOME: TAGS

    -- Resize gaps
    -- Super + SHIFT + <MINUS>
    awful.key(
        {superkey, shiftkey},
        "minus",
        function()
            awful.tag.incgap(5, nil)
        end,
        {description = "increase gap size for the current tag", group = "awesome : tag"}
    ),
    -- Super + <MINUS>
    awful.key(
        {superkey},
        "minus",
        function()
            awful.tag.incgap(-5, nil)
        end,
        {description = "decrease gap size for the current tag", group = "awesome : tag"}
    ),
    -- Super + ALT + q
    -- Kill all visible clients for the current tag
    awful.key(
        {superkey, altkey},
        "q",
        function()
            local clients = awful.screen.focused().clients
            for _, c in pairs(clients) do
                c:kill()
            end
        end,
        {description = "kill all visible clients for the current tag", group = "awesome : tag"}
    ),
    -- Super + x
    -- restore
    awful.key(
        {superkey},
        "x",
        function()
            awful.tag.history.restore()
        end,
        {description = "go back", group = "awesome : tag"}
    ),
    -- Restore minimized
    awful.key(
        {superkey, shiftkey},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "awesome : tag"}
    ),
    ------------

    -- ROFI --
    -- Rofi
    awful.key(
        {superkey},
        "space",
        function()
            awful.spawn.with_shell("rofi -show combi")
        end,
        {description = "rofi launcher", group = "rofi"}
    ),
    -- Rofi - open file in new emacsclient frame
    awful.key(
        {superkey, hyperkey},
        "space",
        function()
            awful.spawn.with_shell("rofi.emacs")
        end,
        {description = "rofi emacs", group = "rofi"}
    ),
    -- Rofi-Tmux
    awful.key(
        {superkey, hyperkey},
        "l",
        function()
            awful.spawn.with_shell("rofi-tmux lp")
        end,
        {description = "load tmuxinator project", group = "rofi : tmux"}
    ),
    awful.key(
        {superkey, hyperkey},
        "w",
        function()
            awful.spawn.with_shell("rofi-tmux sw")
        end,
        {description = "switch tmux window", group = "rofi : tmux"}
    ),
    awful.key(
        {superkey, hyperkey},
        "s",
        function()
            awful.spawn.with_shell("rofi-tmux ss")
        end,
        {description = "switch tmux session", group = "rofi : tmux"}
    ),
    awful.key(
        {superkey, hyperkey},
        "k",
        function()
            awful.spawn.with_shell("rofi-tmux kw")
        end,
        {description = "kill tmux window", group = "rofi : tmux"}
    ),
    awful.key(
        {superkey, hyperkey},
        "c",
        function()
            awful.spawn.with_shell("rofi-tmux ks")
        end,
        {description = "kill tmux session", group = "rofi : tmux"}
    ),
    -- rofi youtube
    awful.key(
        {superkey, hyperkey},
        "y",
        function()
            awful.spawn.with_shell("rofi.youtube")
        end,
        {description = "search youtube", group = "rofi"}
    ),
    -- rofi clipboard
    awful.key(
        {superkey, hyperkey},
        "x",
        function()
            awful.spawn.with_shell("rofi-copyq")
        end,
        {description = "view clipboard history", group = "rofi"}
    ),
    -- rofi browse files
    awful.key(
        {superkey, hyperkey},
        "f",
        function()
            awful.spawn.with_shell("rofi.browse-files")
        end,
        {description = "browse filesystem", group = "rofi"}
    ),
    -- rofi browse files
    awful.key(
        {superkey, hyperkey},
        "p",
        function()
            awful.spawn.with_shell("rofi-pass")
        end,
        {description = "access pass manager", group = "rofi"}
    ),
    ------------

    -- UTILITIES --

    -- Brightness
    -- awful.key( { }, "XF86MonBrightnessDown",
    awful.key(
        {superkey},
        "F5",
        function()
            awful.spawn.with_shell("backlight.scr down")
        end,
        {description = "decrease brightness", group = "utilities : brightness"}
    ),
    -- awful.key( { }, "XF86MonBrightnessUp",
    awful.key(
        {superkey},
        "F6",
        function()
            awful.spawn.with_shell("backlight.scr up")
        end,
        {description = "increase brightness", group = "utilities : brightness"}
    ),
    -- Volume Control
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awful.spawn.with_shell("vol toggle")
        end,
        {description = "(un)mute volume", group = "utilities : volume"}
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awful.spawn.with_shell("vol down")
        end,
        {description = "lower volume", group = "utilities : volume"}
    ),
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn.with_shell("vol up")
        end,
        {description = "raise volume", group = "utilities : volume"}
    ),
    -- Screenshots
    awful.key(
        {},
        "Print",
        function()
            awful.spawn.with_shell("sshot")
        end,
        {description = "take full screenshot", group = "utilities : screenshot"}
    ),
    awful.key(
        {shiftkey},
        "Print",
        function()
            awful.spawn.with_shell("sshot window")
        end,
        {description = "take screenshot of window", group = "utilities : screenshot"}
    ),
    awful.key(
        {altkey},
        "Print",
        function()
            awful.spawn.with_shell("sshot select")
        end,
        {description = "select area to capture", group = "utilities : screenshot"}
    ),
    ------------

    -- APPLICATIONS --

    -- Emacs
    awful.key(
        {superkey},
        "e",
        function()
            awful.spawn("emacsclient -c -a ''")
        end,
        {description = "emacs", group = "*"}
    ),
    -- Terminal
    awful.key(
        {superkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "alacritty", group = "*"}
    ),
    -- Trilium
    awful.key(
        {superkey},
        "t",
        function()
            local matcher = function(c)
                return awful.rules.match(c, {class = "trilium notes"})
            end
            awful.client.run_or_raise("trilium", matcher)
        end,
        {description = "trilium", group = "*"}
    ),

    ----------------------

    -- like below but for tag 10
    -- View tag only.
    awful.key(
        {superkey},
        "0",
        function()
            local screen = awful.screen.focused()
            local tag = screen.tags[10]
            if tag then
                tag:view_only()
            end
        end
    ),
    -- Move client to tag.
    awful.key(
        {superkey, shiftkey},
        "0",
        function()
            if client.focus then
                local tag = client.focus.screen.tags[10]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.globalkeys =
        gears.table.join(
        keys.globalkeys,
        -- View tag only.
        awful.key(
            {superkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end
        ),
        -- Move client to tag.
        awful.key(
            {superkey, shiftkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end
        )
    )
end

keys.clientkeys =
    gears.table.join(
    ------------
      -- AWESOME : CLIENT --

    -- Toggle fullscreen
    awful.key(
        {superkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "awesome : client"}
    ),
    -- Resize and set floating - Predetermined size according to screen
    -- F for focused view
    awful.key(
        {superkey, ctrlkey},
        "f",
        function(c)
            c.width = screen_width * 0.7
            c.height = screen_height * 0.75
            c.floating = true
            awful.placement.centered(c, {honor_workarea = true})
            c:raise()
        end,
        {description = "focus mode", group = "awesome : client"}
    ),
    -- V for vertical view
    awful.key(
        {superkey, ctrlkey},
        "v",
        function(c)
            c.width = screen_width * 0.45
            c.height = screen_height * 0.90
            c.floating = true
            awful.placement.centered(c, {honor_workarea = true})
            c:raise()
        end,
        {description = "focus mode - vertical", group = "awesome : client"}
    ),
    -- T for tiny window
    awful.key(
        {superkey, ctrlkey},
        "t",
        function(c)
            c.width = screen_width * 0.3
            c.height = screen_height * 0.35
            c.floating = true
            awful.placement.centered(c, {honor_workarea = true})
            c:raise()
        end,
        {description = "tiny mode", group = "awesome : client"}
    ),
    -- N for normal window
    awful.key(
        {superkey, ctrlkey},
        "n",
        function(c)
            c.width = screen_width * 0.45
            c.height = screen_height * 0.5
            c.floating = true
            awful.placement.centered(c, {honor_workarea = true})
            c:raise()
        end,
        {description = "normal mode", group = "awesome : client"}
    ),
    awful.key(
        {superkey},
        "w",
        function(c)
            c:kill()
        end,
        {description = "close", group = "awesome : client"}
    ),
    -- Toggle floating
    awful.key(
        {superkey, ctrlkey},
        "space",
        function(c)
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout ~= "floating" then
                awful.client.floating.toggle()
            end
            --c:raise()
        end,
        {description = "toggle floating", group = "awesome : client"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "awesome : client"}
    ),
    awful.key(
        {superkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "awesome : client"}
    ),
    -- P for pin: keep on top OR sticky
    -- On top
    awful.key(
        {superkey, shiftkey},
        "p",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "awesome : client"}
    ),
    -- Sticky
    awful.key(
        {superkey, ctrlkey},
        "p",
        function(c)
            c.sticky = not c.sticky
        end,
        {description = "toggle sticky", group = "awesome : client"}
    ),
    -- Move floating client (relative)
    awful.key(
        {superkey, shiftkey},
        "Down",
        function(c)
            c:relative_move(0, 40, 0, 0)
        end
    ),
    awful.key(
        {superkey, shiftkey},
        "Up",
        function(c)
            c:relative_move(0, -40, 0, 0)
        end
    ),
    awful.key(
        {superkey, shiftkey},
        "Left",
        function(c)
            c:relative_move(-40, 0, 0, 0)
        end
    ),
    awful.key(
        {superkey, shiftkey},
        "Right",
        function(c)
            c:relative_move(40, 0, 0, 0)
        end
    ),
    -- Center client
    awful.key(
        {superkey},
        "c",
        function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    ),
    -- Resize client
    awful.key(
        {superkey, ctrlkey},
        "Down",
        function(c)
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move(0, 0, 0, dpi(20))
            else
                awful.client.incwfact(0.05)
            end
        end
    ),
    awful.key(
        {superkey, ctrlkey},
        "Up",
        function(c)
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move(0, 0, 0, dpi(-20))
            else
                awful.client.incwfact(-0.05)
            end
        end
    ),
    awful.key(
        {superkey, shiftkey, ctrlkey},
        "Down",
        function(c)
            c:relative_move(0, dpi(20), 0, 0)
        end
    ),
    awful.key(
        {superkey, shiftkey, ctrlkey},
        "Up",
        function(c)
            c:relative_move(0, dpi(-20), 0, 0)
        end
         --,
        --{description = "focus mode", group = "client"}
    ),
    ------------
    -- AWESOME : CLIENT --

    -- Minimize
    awful.key(
        {superkey},
        "n",
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        function(c)
            c.minimized = true
        end,
        {description = "minimize", group = "awesome : client : resize"}
    ),
    awful.key(
        {superkey},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "awesome : client : resize"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "awesome : client : resize"}
    ),
    awful.key(
        {superkey, shiftkey},
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "awesome : client : resize"}
    )
)

-- Mouse buttons on the client (whole window, not just titlebar)
keys.clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            client.focus = c
            c:raise()
        end
    ),
    awful.button({superkey}, 1, awful.mouse.client.move),
    awful.button(
        {superkey},
        2,
        function(c)
            c:kill()
        end
    ),
    awful.button(
        {superkey},
        3,
        function(c)
            awful.mouse.client.resize(c)
        end
    )
)
-- }}}

-- Set keys
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

return keys
