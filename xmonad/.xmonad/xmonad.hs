import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Config.Xfce

import           System.Exit
import qualified System.IO

import qualified XMonad.StackSet as W

-- prompts
import           XMonad.Prompt
-- import           XMonad.Prompt.ConfirmPrompt
import           XMonad.Prompt.Shell

-- hooks
import           XMonad.Hooks.DynamicLog
-- import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook

-- actions
import           XMonad.Actions.CycleWS
-- import           XMonad.Actions.WindowGo

-- utils
import           XMonad.Util.EZConfig
import           XMonad.Util.Run
import           XMonad.Util.Scratchpad

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Circle
import           XMonad.Layout.MouseResizableTile
import           XMonad.Layout.Named                (named)
import           XMonad.Layout.NoBorders            (noBorders, smartBorders)
-- import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Roledex
import           XMonad.Layout.SimpleDecoration
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.SimplestFloat
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral
import           XMonad.Layout.ThreeColumns
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.Layout.WindowNavigation as N

myLayouts = N.windowNavigation
  $ avoidStruts
  $ smartBorders
  $ smartSpacingWithEdge 5
  $ ( emptyBSP
   ||| mouseResizableTile
   ||| simpleFloat
   ||| simplestFloat
   ||| threeCol
   ||| threeMid
   ||| full
   ||| Circle
   ||| spiral (6/7)
   ||| Roledex
    )
  where
    full     = named "full" $ noBorders Full
    threeCol = named "threeCol" $ ThreeCol 1 (3/100) (1/2)
    threeMid = named "threeMid" $ ThreeColMid 1 (3/100) (1/2)

main = xmonad $ docks $ xfceConfig
  { modMask           = mod4Mask
  , focusFollowsMouse = True
  , borderWidth       = 1
  , workspaces        = myWorkspaces
  , keys              = myKeys
  , layoutHook        = myLayouts
  , manageHook        = myManageHook <+> manageHook defaultConfig
  , terminal          = "alacritty"
  }

myWorkspaces = ["navegando", "desarrollo [1]", "desarrollo [2]", "español", "diseño", "mensajes", "notas", "sistema", "otro"]

myManageHook = composeAll
  [ className  =? "Xmessage"        --> doFloat
  , className  =? "xfce4-appfinder" --> doFloat
  , isDialog                        --> doCenterFloat
  , isFullscreen                    --> doFullFloat
  , manageDocks
  ]

myKeys = \conf -> mkKeymap conf $
    -- programs
  [ ("M-<Return>",  spawn $ XMonad.terminal conf)
  , ("M-e",         spawn "emacsclient -a '' -c")

    -- rofi
  , ("M-<Space>",   spawn "rofi -show combi")
  , ("M-=",         spawn "rofi -modi calc -show")

    -- layout
  , ("M-<Right>",     sendMessage $ N.Go R)
  , ("M-<Left>",      sendMessage $ N.Go L)
  , ("M-<Up>",        sendMessage $ N.Go U)
  , ("M-<Down>",      sendMessage $ N.Go D)
  , ("M-S-<Right>",   sendMessage $ N.Swap R)
  , ("M-S-<Left>",    sendMessage $ N.Swap L)
  , ("M-S-<Up>",      sendMessage $ N.Swap U)
  , ("M-S-<Down>",    sendMessage $ N.Swap D)
  , ("M-C-<Right>",   sendMessage $ ExpandTowards R)
  , ("M-C-<Left>",    sendMessage $ ExpandTowards L)
  , ("M-C-<Up>",      sendMessage $ ExpandTowards U)
  , ("M-C-<Down>",    sendMessage $ ExpandTowards D)
  , ("M-C-S-<Right>", sendMessage $ ShrinkFrom R)
  , ("M-C-S-<Left>",  sendMessage $ ShrinkFrom L)
  , ("M-C-S-<Up>",    sendMessage $ ShrinkFrom U)
  , ("M-C-S-<Down>",  sendMessage $ ShrinkFrom D)
  , ("M-S-t",         sendMessage NextLayout)

  -- windows
  , ("M-w",         kill)
  -- , ("M-n",         withFocused minimizeWindow)
  -- , ("M-S-n",       sendMessage RestoreNextMinimized)

  -- workspaces
  , ("M-1",         sequence_ [toggleOrView "navegando"
                              , spawn "notify-send 'navegando'"])
  , ("M-2",         sequence_ [toggleOrView "desarrollo [1]"
                              , spawn "notify-send 'desarrollo [1]'"])
  , ("M-3",         sequence_ [toggleOrView "desarrollo [2]"
                              , spawn "notify-send 'desarrollo [2]'"])
  , ("M-4",         sequence_ [toggleOrView "español"
                              , spawn "notify-send 'español'"])
  , ("M-5",         sequence_ [toggleOrView "diseño"
                              , spawn "notify-send 'diseño'"])
  , ("M-6",         sequence_ [toggleOrView "mensajes"
                              , spawn "notify-send 'mensajes'"])
  , ("M-7",         sequence_ [toggleOrView "notas"
                              , spawn "notify-send 'notas'"])
  , ("M-8",         sequence_ [toggleOrView "sistema"
                              , spawn "notify-send 'sistema'"])
  , ("M-9",         sequence_ [toggleOrView "otro"
                              , spawn "notify-send 'otro'"])
  -- sys
  -- , ("M-q"          recompile True >> restart "xmonad" True)
  ]
