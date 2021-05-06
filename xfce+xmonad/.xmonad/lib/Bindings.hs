module Bindings
  ( myKeys
  , myMouseBindings) where

import           Data.Default
import qualified Data.Map as M -- For keybindings.
import           Data.Maybe
import           Graphics.X11.ExtraTypes.XF86

import           XMonad
import qualified XMonad.StackSet as W

-- import           XMonad.Actions.AfterDrag
-- import qualified XMonad.Actions.FlexibleResize as Flex
import           XMonad.Actions.FloatKeys
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.Minimize
import           XMonad.Actions.OnScreen
import           XMonad.Actions.PhysicalScreens
-- import           XMonad.Actions.MouseResize
import           XMonad.Actions.TopicSpace
import           XMonad.Actions.WindowMenu

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Maximize
-- import           XMonad.Layout.MultiToggle
-- import qualified XMonad.Layout.WindowNavigation as N

import           XMonad.Prompt
import           XMonad.Prompt.Layout
import           XMonad.Prompt.Shell
import           XMonad.Prompt.Window
import           XMonad.Prompt.Workspace
import           XMonad.Prompt.XMonad

import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad

import           Config
import           Layouts         (myLayouts)
import           Scratchpads     (myScratchpads)
import           Topics


myKeys = \conf -> mkKeymap conf $
  [ ("M-<Return>",  spawn $ XMonad.terminal conf)
    -- emacs
  , ("M-e",         spawnEmacs "")
  , ("M-x a",       spawnEmacs "-e '(org-agenda-list)'")
  , ("M-x c",       spawnEmacs "-e '(org-capture)'")
  , ("M-x t",       spawnEmacs "-e '(org-todo-list)'")
  , ("M-<Tab>",     spawnEmacs "-e '(org-roam-dailies-today)'")
    -- rofi
  , ("M-<Space>",           spawn "rofi -show combi")
  , ("M-M3-=",              spawn "rofi -modi calc -show")
  , ("M-<XF86Calculator>",  spawn "rofi -modi calc -show") -- alt
  , ("M-M3-k",              spawn "~/.local/bin/rofi/rofi-hotkeys")
  , ("M-M3-l",              layoutPrompt myXPConfig)
  , ("M-M3-p",              spawn "rofi-pass")
  , ("M-M3-s",              spawn "~/.local/bin/rofi/rofi-web-search")
  , ("M-M3-w",              windowMultiPrompt myXPConfig [(Goto, allWindows), (Goto, wsWindows)])
  , ("M-M3-x",              xmonadPrompt myXPConfig)
  , ("M-S-;",               shellPrompt myXPConfig)
  -- workspaces / topics
  , ("M-S-.",         currentTopicAction myTopicConfig)
    -- layout
  , ("C-M1-<Tab>",    sendMessage $ NextLayout)
    -- "M-<arrow>" Go and "M-S-<arrow>" Swap bindings from Navigation2D
  , ("M-C-<Right>",   sendMessage $ ExpandTowards R)
  , ("M-C-<Left>",    sendMessage $ ExpandTowards L)
  , ("M-C-<Up>",      sendMessage $ ExpandTowards U)
  , ("M-C-<Down>",    sendMessage $ ExpandTowards D)
  
  -- snap floating windows to size
  , ("M-S-<KP_Right>",  withFocused $ snapMove R Nothing)
  , ("M-S-<KP_Left>",   withFocused $ snapMove L Nothing)
  , ("M-S-<KP_Up>",     withFocused $ snapMove U Nothing)
  , ("M-S-<KP_Down>",   withFocused $ snapMove D Nothing)
  , ("M-C-<KP_Right>",  withFocused $ snapGrow R Nothing)
  , ("M-C-<KP_Left>",   withFocused $ snapShrink R Nothing)
  , ("M-C-<KP_Up>",     withFocused $ snapGrow D Nothing)
  , ("M-C-<KP_Down>",   withFocused $ snapShrink D Nothing)
  ---- alts
  , ("M-S-<KP_6>",      withFocused $ snapMove R Nothing)
  , ("M-S-<KP_4>",      withFocused $ snapMove L Nothing)
  , ("M-S-<KP_8>",      withFocused $ snapMove U Nothing)
  , ("M-S-<KP_2>",      withFocused $ snapMove D Nothing)
  , ("M-C-<KP_6>",      withFocused $ snapGrow R Nothing)
  , ("M-C-<KP_4>",      withFocused $ snapShrink R Nothing)
  , ("M-C-<KP_8>",      withFocused $ snapGrow D Nothing)
  , ("M-C-<KP_2>",      withFocused $ snapShrink D Nothing)

  -- view or shift to other screen
  , ("M-<KP_Prior>",   onPrevNeighbour def W.shift)
  , ("M-<KP_Next>",    onNextNeighbour def W.shift)
  , ("M-C-<KP_Prior>", onPrevNeighbour def W.view)
  , ("M-C-<KP_Next>",  onNextNeighbour def W.view)
  ---- alts
  , ("M-<KP_9>",       onPrevNeighbour def W.shift)
  , ("M-<KP_3>",       onNextNeighbour def W.shift)
  , ("M-C-<KP_9>",     onPrevNeighbour def W.view)
  , ("M-C-<KP_3>",     onNextNeighbour def W.view)
  
  -- , ("M-C-S-<Right>", sendMessage $ ShrinkFrom R)
  -- , ("M-C-S-<Left>",  sendMessage $ ShrinkFrom L)
  -- , ("M-C-S-<Up>",    sendMessage $ ShrinkFrom U)
  -- , ("M-C-S-<Down>",  sendMessage $ ShrinkFrom D)
  -- , ("M-C-S-<Left>",  withFocused (keysResizeWindow (-50,0) (0,0)))
  -- , ("M-C-S-<Right>", withFocused (keysResizeWindow (50,0) (0,0)))
  -- , ("M-C-S-<Up>",    withFocused (keysResizeWindow (0,-50) (0,0)))
  -- , ("M-C-S-<Down>",  withFocused (keysResizeWindow (0,50) (0,0)))
  -- , ("M-c 1",         sendMessage (Toggle "smBSP"))
  -- , ("M-c 2",         sendMessage (Toggle "xlBSP"))

  -- windows
  , ("M-w",         kill)
  , ("M-c <Space>", windowMenu)
  , ("M-c =",       sendMessage $ Equalize)
  , ("M-c S-=",     sendMessage $ Balance)
  , ("M-c f",       withFocused $ float)
  , ("M-c r",       sendMessage $ Rotate)
  , ("M-c t",       withFocused $ windows . W.sink )
  , ("M-c x",       withFocused (sendMessage . maximizeRestore))
  , ("M-c z",       withFocused $ minimizeWindow)
  , ("M-c S-z",     withLastMinimized maximizeWindowAndFocus)
  , ("M-c ,",       sendMessage (IncMasterN 1))
  , ("M-c .",       sendMessage (IncMasterN (-1)))
  ] ++
  [ ("M-" ++ otherModMasks ++ [key], windows (action tag))
  | (tag, key)  <- zip myTopics "1234567890"
  , (otherModMasks, action) <- [ ("",   viewOnScreen 0)
                               , ("C-", viewOnScreen 1)
                               , ("S-", W.shift)]
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ -- set the window to floating mode and move by dragging
      -- ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
      -- set the window to floating mode and resize by dragging
    -- , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w))
    -- float snap mouse bindings
      ((modMask,                               button1), (\w -> focus w >> mouseMoveWindow w >>
                                                           ifClick (snapMagicMove (Just 50) (Just 50) w)))
    , ((modMask .|. shiftMask,                 button1), (\w -> focus w >> mouseMoveWindow w >>
                                                           ifClick (snapMagicResize [L,R,U,D] (Just 50) (Just 50) w)))
    , ((modMask,                               button3), (\w -> focus w >> mouseResizeWindow w >>
                                                           ifClick (snapMagicResize [R,D] (Just 50) (Just 50) w)))
    , ((modMask .|. controlMask,               button1), (\w -> focus w >> mouseMoveWindow w >>
                                                           afterDrag (snapMagicMove (Just 50) (Just 50) w)))
    , ((modMask .|. controlMask .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w >>
                                                           afterDrag (snapMagicResize [L,R,U,D] (Just 50) (Just 50) w)))
    , ((modMask .|. controlMask,               button3), (\w -> focus w >> mouseResizeWindow w >>
                                                           afterDrag (snapMagicResize [R,D] (Just 50) (Just 50) w)))
    ]
