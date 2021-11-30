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
import           XMonad.Hooks.Minimize
import           XMonad.Hooks.PositionStoreHooks
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
import           Colors                         ( myActiveColor, myInactiveColor )
import           Config                         -- ( myThemeWithButtons )
import           Layouts                        ( myLayouts )
import           Scratchpads                    ( myScratchpadsHook )
import           Topics                         

main :: IO ()
main = do
  checkTopicConfig myTopics myTopicConfig
  xmonad
    $ navigation2DP
      def
      ("<Up>", "<Left>", "<Down>", "<Right>")
      [ ("M-",   windowGo  )
      , ("M-S-", windowSwap)]
        False
    $ docks
    $ xfceConfig { modMask            = mod4Mask
                 , focusFollowsMouse  = True
                 , borderWidth        = 3
                 , normalBorderColor  = myInactiveColor
                 , focusedBorderColor = myActiveColor
                 , workspaces         = myTopics
                 , keys               = myKeys
                 , mouseBindings      = myMouseBindings
                 , layoutHook         = myLayouts
                 , handleEventHook    = myHandleEventHook
                 , manageHook         = myManageHook <+> myScratchpadsHook <+> positionStoreManageHook Nothing <+> manageHook desktopConfig -- def
                 , terminal           = myTerminal
                 }

myHandleEventHook = minimizeEventHook <+> positionStoreEventHook

myManageHook = composeAll . concat $ [ [isDialog       --> doCenterFloat]
                                     , [isFullscreen   --> doFullFloat]
                                     , [className =? c --> doFloat               | c <- myFloatsByClass]
                                     , [title     =? t --> doFloat               | t <- myFloatsByTitle]
                                     , [className =? c --> doCenterFloat         | c <- myCenterFloatsByClass]
                                     , [className =? c --> doFullFloat           | c <- myFullFloatsByClass]
                                     , [className =? c --> doF (W.shift "I hoy") | c <- myHomescreenApps]
                                     ]
  where
    myFloatsByClass       = [ "Tilda", "Toplevel", "Sxiv", "copyq"
                            , "Pavucontrol"                                  -- utilities
                            , "Klipper", "Kmix", "krunner"                   -- KDE
                            , "Plasma", "plasmashell", "Plasmoidviewer"
                            , "Variety", "Xmessage" ]                        -- system
    myFloatsByTitle       = [ "Breathing", "Dictionary"                      -- utilities
                            , "Panel Preferences", "Whisker Menu"            -- XFCE
                            , "plasma-desktop", "win7" ]                     -- KDE
    myCenterFloatsByClass = [ "ckb-next" -- "Planner",
                            , "Solaar"                                       -- device config
                            , "systemsettings"                               -- KDE
                            , "Xfce4-appearance-settings", "Xfce4-appfinder" -- XFCE
                            , "Xfce4-panel", "Xfce4-settings-manager"
                            , "Zeal" ]
    myFullFloatsByClass   = [ "ksmserver","vncviewer", "Vncviewer" ]
    myHomescreenApps      = ["ICE-SSB-clockify", "ICE-SSB-goalify", "ICE-SSB-todoist",
                             "Clockify", "todoist"]
