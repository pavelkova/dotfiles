-- import Graphics.X11.ExtraTypes.XF86
import           XMonad
import           XMonad.Config.Xfce

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
-- import           XMonad.Actions.DynamicProjects
import           XMonad.Actions.Navigation2D
import           XMonad.Actions.TopicSpace

-- utils
import           XMonad.Util.EZConfig
import           XMonad.Util.Run
import           XMonad.Util.Scratchpad

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Named            ( named )
import           XMonad.Layout.SimpleDecoration


-- local modules
import           Bindings                       ( myKeys, myMouseBindings )
import           Colors                         ( myActiveBorderColor, myInactiveBorderColor )
import           Config
import           Layouts                        ( myLayouts )
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
                 , borderWidth        = 2
                 , normalBorderColor  = myInactiveBorderColor
                 , focusedBorderColor = myActiveBorderColor
                 , workspaces         = myTopics
                 , keys               = myKeys
                 , mouseBindings      = myMouseBindings
                 , layoutHook         = myLayouts
                 , manageHook         = myManageHook <+> manageHook defaultConfig
                 , terminal           = myTerminal
                 }

myManageHook = composeAll
  [ className =? "Xmessage" --> doFloat
  , className =? "xfce4-appfinder" --> doFloat
  , isDialog --> doCenterFloat
  , isFullscreen --> doFullFloat
  , manageDocks
  ]
