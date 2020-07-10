-- import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Config.Xfce

import           System.Exit
import qualified System.IO

-- import qualified XMonad.StackSet as W

-- prompts
import           XMonad.Prompt
import           XMonad.Prompt.Shell

-- hooks
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook

-- actions
-- import           XMonad.Actions.CycleWS
import           XMonad.Actions.Navigation2D

-- utils
import           XMonad.Util.EZConfig
import           XMonad.Util.Run
import           XMonad.Util.Scratchpad

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Named                (named)
import           XMonad.Layout.SimpleDecoration

-- import           XMonad.Layout.ToggleLayouts
-- import qualified XMonad.Layout.WindowNavigation as N

-- local modules
import           Layouts (myLayouts)
import           Keys    (myKeys)
import           Config

main = xmonad $ navigation2D def
                             (xK_Up, xK_Left, xK_Down, xK_Right)
                             [(mod4Mask,               windowGo  ),
                              (mod4Mask .|. shiftMask, windowSwap)]
                             False
                             $ docks $ xfceConfig
  { modMask           = mod4Mask
  , focusFollowsMouse = True
  , borderWidth       = 0
  , workspaces        = myWorkspaces
  , keys              = myKeys
  , layoutHook        = myLayouts
  , manageHook        = myManageHook <+> manageHook defaultConfig
  , terminal          = myTerminal
  }

myManageHook = composeAll
  [ className  =? "Xmessage"        --> doFloat
  , className  =? "xfce4-appfinder" --> doFloat
  , isDialog                        --> doCenterFloat
  , isFullscreen                    --> doFullFloat
  , manageDocks
  ]

-- myKeys = \conf -> mkKeymap conf $
--     -- programs
--   [ ("M-<Return>",  spawn $ XMonad.terminal conf)
--   , ("M-e",         spawn "emacsclient -a '' -c")

--     -- rofi
--   , ("M-<Space>",   spawn "rofi -show combi")
--   , ("M-=",         spawn "rofi -modi calc -show")

--     -- layout
--   , ("M-<Right>",     sendMessage $ N.Go R)
--   , ("M-<Left>",      sendMessage $ N.Go L)
--   , ("M-<Up>",        sendMessage $ N.Go U)
--   , ("M-<Down>",      sendMessage $ N.Go D)
--   , ("M-S-<Right>",   sendMessage $ N.Swap R)
--   , ("M-S-<Left>",    sendMessage $ N.Swap L)
--   , ("M-S-<Up>",      sendMessage $ N.Swap U)
--   , ("M-S-<Down>",    sendMessage $ N.Swap D)
--   , ("M-C-<Right>",   sendMessage $ ExpandTowards R)
--   , ("M-C-<Left>",    sendMessage $ ExpandTowards L)
--   , ("M-C-<Up>",      sendMessage $ ExpandTowards U)
--   , ("M-C-<Down>",    sendMessage $ ExpandTowards D)
--   , ("M-C-S-<Right>", sendMessage $ ShrinkFrom R)
--   , ("M-C-S-<Left>",  sendMessage $ ShrinkFrom L)
--   , ("M-C-S-<Up>",    sendMessage $ ShrinkFrom U)
--   , ("M-C-S-<Down>",  sendMessage $ ShrinkFrom D)
--   , ("M-S-t",         sendMessage NextLayout)

--   -- windows
--   , ("M-w",         kill)
--   -- , ("M-n",         withFocused minimizeWindow)
--   -- , ("M-S-n",       sendMessage RestoreNextMinimized)

--   -- workspaces
--   , ("M-1",         sequence_ [toggleOrView "i"
--                               , spawn "notify-send 'i'"])
--   , ("M-2",         sequence_ [toggleOrView "ii"
--                               , spawn "notify-send 'ii'"])
--   , ("M-3",         sequence_ [toggleOrView "iii"
--                               , spawn "notify-send 'iii'"])
--   , ("M-4",         sequence_ [toggleOrView "iv"
--                               , spawn "notify-send 'iv'"])
--   , ("M-5",         sequence_ [toggleOrView "v"
--                               , spawn "notify-send 'v'"])
--   , ("M-6",         sequence_ [toggleOrView "vi"
--                               , spawn "notify-send 'vi'"])
--   , ("M-7",         sequence_ [toggleOrView "vii"
--                               , spawn "notify-send 'vii'"])
--   , ("M-8",         sequence_ [toggleOrView "viii"
--                               , spawn "notify-send 'viii'"])
--   , ("M-9",         sequence_ [toggleOrView "ix"
--                               , spawn "notify-send 'ix'"])
--   -- sys
--   -- , ("M-q"          recompile True >> restart "xmonad" True)
--   ]
