import XMonad
import XMonad.Config

import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Circle
import XMonad.Layout.Cross
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.Minimize
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed

import XMonad.Util.CustomKeys
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import Graphics.X11.ExtraTypes.XF86
import Data.List
import qualified XMonad.StackSet as W

-- LOCAL
import Colors

-- LAYOUT & THEME
altMask           = mod1Mask

myLayout = avoidStruts $ minimize $ spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $
  emptyBSP ||| Circle -- ||| tabbed shrinkText myTheme

-- STARTUP PROGRAMS

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "autostart.dark-paradise"
  spawnOnce "autostart.common"
  spawnOnce "tint2"

-- MAIN CONFIG

main :: IO ()
main =
  xmonad
    $ withNavigation2DConfig def { defaultTiledNavigation = hybridNavigation }
    $ docks
    -- $ ewmh $ pagerHints
    $ myConfig

myTheme = def
  { activeColor         = middleColor
  , inactiveColor       = backgroundColor
  , activeBorderColor   = middleColor
  , inactiveBorderColor = backgroundColor
  , decoWidth           = 500
  , decoHeight          = 22
  , windowTitleAddons   = []
  , fontName            = "Lato 10"
  }

myConfig = def
  { borderWidth         = 2
  , focusedBorderColor  = middleColor
  , focusFollowsMouse   = False
  , handleEventHook     = docksEventHook <+> minimizeEventHook
  , keys                = myKeys
  , layoutHook          = myLayout
  , manageHook          = manageDocks
  , modMask             = mod4Mask
  , normalBorderColor   = middleColor
  , startupHook         = myStartupHook
  , terminal            = "urxvt"
  , workspaces          = ["navegando", "desarrollo [1]", "desarrollo [2]", "español", "diseño", "mensajes", "notas", "sistema", "otro"]
  }

-- KEYS
myKeys = customKeys removedKeys addedKeys

removedKeys :: XConfig l -> [(KeyMask, KeySym)]
removedKeys XConfig {modMask = modm} =
    [ (modm              , xK_space)  -- Default for layout switching
    , (modm .|. shiftMask, xK_Return) -- Default for opening a terminal
    , (modm .|. shiftMask, xK_c)      -- Default for closing the focused window
    ]

addedKeys :: XConfig l -> [((KeyMask, KeySym), X ())]
addedKeys conf @ XConfig {modMask = modm} =
  [ -- SERVICES
    ((modm, xK_space) , spawn "rofi.dark-paradise")
  , ((modm, xK_Return), spawn $ XMonad.terminal conf)
  , ((modm, xK_Home), spawn "Thunar")
  , ((modm, xK_Print), spawn "sshot.full")
  , ((modm .|. shiftMask, xK_Print), spawn "sshot.window")
  , ((altMask, xK_Print), spawn "sshot.select")
  , ((modm, xK_q), recompile True >> restart "xmonad" True)
  , ((0, xF86XK_AudioRaiseVolume), spawn "vol up")
  , ((0, xF86XK_AudioLowerVolume), spawn "vol down")
  , ((0, xF86XK_AudioMute), spawn "vol toggle")
  , ((0, xF86XK_MonBrightnessUp), spawn "backlight.scr up")
  , ((0, xF86XK_MonBrightnessDown), spawn "backlight.scr down")
  , ((0, xF86XK_KbdBrightnessUp), spawn "backlight.kbd up")
  , ((0, xF86XK_KbdBrightnessDown), spawn "backlight.kbd down")
  , ((modm .|. controlMask, xK_r), spawn "pkill -USR1 redshift")
  
    -- WINDOWS
  , ((modm, xK_w), kill)
  , ((modm, xK_r), sendMessage Rotate)
  , ((modm, xK_t), sendMessage Swap)
  , ((modm,               xK_a),     sendMessage Balance)
  , ((modm .|. shiftMask, xK_a),     sendMessage Equalize)
  , ((modm .|. shiftMask, xK_f), withFocused $ windows . W.sink) 

    -- Directional navigation of windows
  , ((modm, xK_Right), windowGo R False)
  , ((modm, xK_Left), windowGo L False)
  , ((modm, xK_Up), windowGo U False)
  , ((modm, xK_Down), windowGo D False)

    -- Expand and shrink windows
  , ((modm .|. controlMask,                xK_Right), sendMessage $ ExpandTowards R)
  , ((modm .|. controlMask,                xK_Left), sendMessage $ ExpandTowards L)
  , ((modm .|. controlMask,                xK_Down), sendMessage $ ExpandTowards D)
  , ((modm .|. controlMask,                xK_Up), sendMessage $ ExpandTowards U)
  , ((modm .|. controlMask .|. shiftMask , xK_Right), sendMessage $ ShrinkFrom R)
  , ((modm .|. controlMask .|. shiftMask , xK_Left), sendMessage $ ShrinkFrom L)
  , ((modm .|. controlMask .|. shiftMask , xK_Down), sendMessage $ ShrinkFrom D)
  , ((modm .|. controlMask .|. shiftMask , xK_Up), sendMessage $ ShrinkFrom U)

    -- Minimize
  --  , ((modm,               xK_m), withFocused minimizeWindow)
  --  , ((modm .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)

    -- LAYOUT
  , ((modm .|. shiftMask, xK_t), sendMessage NextLayout)

    -- WORKSPACE
  , ((modm, xK_1), sequence_ [toggleOrView "navegando", spawn "notify-send \"navegando\""])
  , ((modm, xK_2), sequence_ [toggleOrView "desarrollo [1]"  , spawn "notify-send \"desarrollo [1]\""  ])
  , ((modm, xK_3), sequence_ [toggleOrView "desarrollo [2]"  , spawn "notify-send \"desarrollo [2]\""  ])
  , ((modm, xK_4), sequence_ [toggleOrView "español"  , spawn "notify-send \"español\""  ])
  , ((modm, xK_5), sequence_ [toggleOrView "diseño"  , spawn "notify-send \"diseño\""  ])
  , ((modm, xK_6), sequence_ [toggleOrView "mensajes"   , spawn "notify-send \"mensajes\""   ])
  , ((modm, xK_7), sequence_ [toggleOrView "notas"   , spawn "notify-send \"notas\""   ])
  , ((modm, xK_8), sequence_ [toggleOrView "sistema"   , spawn "notify-send \"sistema\""   ])
  , ((modm, xK_9), sequence_ [toggleOrView "otro"   , spawn "notify-send \"otro\""   ])

  -- SESSION
  , ((0, xF86XK_Sleep), spawn "light-locker-command --activate")

  ]
