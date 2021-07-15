-- import Graphics.X11.ExtraTypes.XF86
import           XMonad
import           XMonad.Config.Desktop
-- import           XMonad.Config.Kde
import           XMonad.Config.Xfce

import           System.Exit
import qualified System.IO

import qualified XMonad.StackSet as W

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
-- import           XMonad.Actions.DynamicProjects
import           XMonad.Actions.Navigation2D
import           XMonad.Actions.TopicSpace

-- utils
import           XMonad.Util.EZConfig
import           XMonad.Util.Run
-- import           XMonad.Util.NamedScratchpad

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Named            ( named )
import           XMonad.Layout.SimpleDecoration


-- local modules
import           Bindings                       ( myKeys, myMouseBindings )
import           Colors                         ( myActiveBorderColor, myInactiveBorderColor )
import           Config
import           Layouts                        ( myLayouts )
import           Scratchpads                    ( myScratchpadsHook )
import           Topics                         

main :: IO ()
main = do
  checkTopicConfig myTopics myTopicConfig
  xmonad
    $ navigation2D
        def
        (xK_Up, xK_Left, xK_Down, xK_Right)
        [(mod4Mask, windowGo), (mod4Mask .|. shiftMask, windowSwap)]
        False
    $ docks
    $ xfceConfig { modMask            = mod4Mask
                 , focusFollowsMouse  = True
                 , borderWidth        = 3
                 , normalBorderColor  = myInactiveBorderColor
                 , focusedBorderColor = myActiveBorderColor
                 , workspaces         = myTopics
                 , keys               = myKeys
                 , mouseBindings      = myMouseBindings
                 , layoutHook         = myLayouts
                 , manageHook         = myBaseHook <+> myManageHook <+> myScratchpadsHook <+> manageHook desktopConfig -- def
                 , terminal           = myTerminal
                 }
-- myManageHook = composeAll [ className =? "Clockify"                        --> doFloat
--                           , className =? "ckb-next"                        --> doCenterFloat
--                           , className =? "copyq"                           --> doCenterFloat
--                           , className =? "ICE-SSB-nts"                     --> doFloat
--                           , className =? "Tilda"                           --> doFloat
--                           , className =? "Sxiv"                            --> doFloat
--                           , className =? "Solaar"                          --> doCenterFloat
--                           , className =? "systemsettings"                  --> doCenterFloat -- KDE
--                           , className =? "todoist"                         --> doFloat
--                           , className =? "Variety"                         --> doFloat
--                           , className =? "vncviewer"                       --> doFullFloat
--                           , className =? "Vncviewer"                       --> doFullFloat
--                           , className =? "Xmessage"                        --> doFloat
--                           , className =? "Xfce4-appearance-settings"       --> doCenterFloat
--                           , className =? "Xfce4-appFinder"                 --> doCenterFloat
--                           , className =? "Xfce4-settings-manager"          --> doCenterFloat
--                           , isDialog                                       --> doCenterFloat
--                           , isFullscreen                                   --> doFullFloat
--                           , manageDocks
--                           ]

myBaseHook = composeAll [ isDialog     --> doCenterFloat
                        , isFullscreen --> doFullFloat]
myManageHook = composeAll . concat $ [ [className =? c --> doFloat               | c <- myFloatsByClass]
                                     , [title     =? t --> doFloat               | t <- myFloatsByTitle]
                                     , [className =? c --> doCenterFloat         | c <- myCenterFloatsByClass]
                                     , [className =? c --> doFullFloat           | c <- myFullFloatsByClass]
                                     , [className =? c --> doF (W.shift "I hoy") | c <- myHomescreenApps]
                                     ]
  where
    myFloatsByClass       = ["copyq", "Tilda", "Toplevel", "Sxiv",           -- utilities
                             "Klipper", "Kmix", "krunner",                   -- KDE
                             "Plasma", "plasmashell", "Plasmoidviewer",
                             "Variety", "Xmessage"]                          -- system
    myFloatsByTitle       = [ "Breathing",                                   -- utilities
                              "Panel Preferences"                            -- XFCE
                            , "plasma-desktop", "win7"]                      -- KDE
    myCenterFloatsByClass = ["ckb-next", -- "Planner",
                             "Solaar",                                       -- device config
                             "systemsettings",                               -- KDE
                             "Xfce4-appearance-settings", "Xfce4-appFinder", -- XFCE
                             "Xfce4-panel", "Xfce4-settings-manager"]
    myFullFloatsByClass   = ["ksmserver","vncviewer", "Vncviewer"]
    myHomescreenApps      = ["ICE-SSB-clockify", "ICE-SSB-goalify", "ICE-SSB-todoist",
                             "Clockify", "todoist"]
