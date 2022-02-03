-- import Graphics.X11.ExtraTypes.XF86
import           XMonad
import           XMonad.Config.Desktop
import           XMonad.Config.Kde
-- import           XMonad.Config.Xfce

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
import           XMonad.Layout.NoBorders        ( hasBorder )
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
    $ kdeConfig { modMask            = mod4Mask
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
                                     -- plasma section
                                     , [className =? c --> doFloat <+> hasBorder False | c <- myPlasmaFloatsByClass ]
                                     , [title     =? t --> doFloat <+> hasBorder False | t <- myPlasmaFloatsByTitle ]
                                     , [(className =? "plasmashell" <&&> checkSkipTaskbar) -->  doIgnore <+> hasBorder False ]
                                     -- , [(title     =? t <&&> checkSkipTaskbar) -->  doFloat <+> hasBorder False | t <- myPlasmaFloatsByTitle ]
                                     ]
  where
    myFloatsByClass       = [ "Tilda", "Toplevel", "Sxiv", "copyq"
                            , "Evolution-alarm-notify"
                            -- , "plasmashell"                                  -- KDE
                            , "Pavucontrol"                                  -- utilities
                            , "Variety", "Xmessage" ]                        -- system
    myFloatsByTitle       = [ "Breathing", "Dictionary"                      -- utilities
                            , "Panel Preferences", "Whisker Menu" ]          -- XFCE
    myCenterFloatsByClass = [ "ckb-next"
                            , "Solaar"                                       -- device config
                            , "Xfce4-appearance-settings", "Xfce4-appfinder" -- XFCE
                            , "Xfce4-panel", "Xfce4-settings-manager"
                            , "Zeal" ]
    myFullFloatsByClass   = [ "ksmserver","vncviewer", "Vncviewer" ]
    myPlasmaFloatsByClass = ["Plasma", "krunner", "Klipper", "Plasmoidviewer"]
    myPlasmaFloatsByTitle = ["Desktop - Plasma",  "plasma-desktop", "win7"]
    myHomescreenApps      = ["ICE-SSB-clockify", "ICE-SSB-goalify", "ICE-SSB-todoist",
                             "Clockify", "todoist"]

checkSkipTaskbar :: Query Bool
checkSkipTaskbar = isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR"
-- checkSkipTaskbar = isInProperty "WM_PROTOCOLS" "WM_TAKE_FOCUS"
