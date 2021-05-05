module Bindings
  ( myKeys
  , myMouseBindings) where

import           Data.Default
import qualified Data.Map as M -- For keybindings.
import           Data.Maybe
import           Graphics.X11.ExtraTypes.XF86

import           XMonad
import qualified XMonad.StackSet as W

import qualified XMonad.Actions.FlexibleResize as Flex
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
  , ("M-<Space>",   spawn "rofi -show combi")
  , ("M-M3-=",      spawn "rofi -modi calc -show")
  , ("M-M3-k",      spawn "~/.local/bin/rofi/rofi-hotkeys")
  , ("M-M3-l",      layoutPrompt myXPConfig)
  , ("M-M3-s",      spawn "~/.local/bin/rofi/rofi-web-search")
  , ("M-M3-p",      spawn "rofi-pass")
  , ("M-M3-w",      windowMultiPrompt myXPConfig [(Goto, allWindows), (Goto, wsWindows)])
  , ("M-M3-x",      xmonadPrompt myXPConfig)
  , ("M-S-;",       shellPrompt myXPConfig)
    -- layout
    -- "M-<arrow>" Go and "M-S-<arrow>" Swap bindings from Navigation2D
  , ("M-C-<Right>",   sendMessage $ ExpandTowards R)
  , ("M-C-<Left>",    sendMessage $ ExpandTowards L)
  , ("M-C-<Up>",      sendMessage $ ExpandTowards U)
  , ("M-C-<Down>",    sendMessage $ ExpandTowards D)
  , ("M-,",           onPrevNeighbour def W.shift)
  , ("M-.",           onNextNeighbour def W.shift)
  , ("M-C-,",         onPrevNeighbour def W.view)
  , ("M-C-.",         onNextNeighbour def W.view)
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
  , ("M-c S-t",     sendMessage $ NextLayout)
  , ("M-c t",       withFocused $ windows . W.sink )
  , ("M-c x",       withFocused (sendMessage . maximizeRestore))
  , ("M-c z",       withFocused $ minimizeWindow)
  , ("M-c S-z",     withLastMinimized maximizeWindowAndFocus)
  , ("M-c ,",       sendMessage (IncMasterN 1))
  , ("M-c .",       sendMessage (IncMasterN (-1)))

  -- workspaces / topics
  , ("M-M3-[",      promptedGoto)

  , ("M-M3-]",      promptedShift)
  , ("M-S-.",       currentTopicAction myTopicConfig)
  ] ++
  -- [ (otherModMasks ++ "M-" ++ [key], action tag)
  -- | (tag, key)  <- zip myTopics "1234567890"
  -- , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
  --                              , ("S-", windows . W.shift)]
  -- ] ++
  [ ("M-" ++ otherModMasks ++ [key], windows (action tag))
  | (tag, key)  <- zip myTopics "1234567890"
  , (otherModMasks, action) <- [ ("",   viewOnScreen 0)
                               , ("C-", viewOnScreen 1)
                               , ("S-", W.shift)]
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
      ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- set the window to floating mode and move by dragging
    , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) -- set the window to floating mode and resize by dragging
    ]
