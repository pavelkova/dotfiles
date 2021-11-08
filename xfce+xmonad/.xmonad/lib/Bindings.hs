module Bindings
  ( myKeys
  , myMouseBindings) where

import           Data.Default
import qualified Data.Map as M -- For keybindings.
import           Data.Maybe
import           Graphics.X11.ExtraTypes.XF86

import           XMonad hiding ( (|||) )
import qualified XMonad.StackSet as W

-- import           XMonad.Actions.AfterDrag
-- import qualified XMonad.Actions.FlexibleResize as Flex
import           XMonad.Actions.FloatKeys
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.Minimize
import           XMonad.Actions.OnScreen
import           XMonad.Actions.PerWorkspaceKeys
import           XMonad.Actions.PhysicalScreens
import           XMonad.Actions.MouseResize
import           XMonad.Actions.TopicSpace
import           XMonad.Actions.WindowMenu

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.LayoutCombinators
import           XMonad.Layout.Maximize
import           XMonad.Layout.MouseResizableTile
import           XMonad.Layout.Spacing
import           XMonad.Layout.ZoomRow
-- import qualified XMonad.Layout.WindowNavigation as N

import           XMonad.Prompt
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
  [ ("M-<Return>",    spawn $ XMonad.terminal conf)
  , ("C-M-t",         spawn $ XMonad.terminal conf)
  , ("M-<F12>",       spawn "~/.local/bin/dictate start")
  , ("M-S-<F12>",     spawn "~/.local/bin/dictate stop")
  , ("M-M3-<Return>", namedScratchpadAction myScratchpads "retroTerm")
  , ("M-M3-<Tab>",    namedScratchpadAction myScratchpads "findOrgRoam")
  , ("M-M3-<Space>",  namedScratchpadAction myScratchpads "captureOrgRoam")
  , ("M-M3-a",        namedScratchpadAction myScratchpads "orgAgenda")
  , ("M-M3-m",        namedScratchpadAction myScratchpads "minitube")
  , ("M-M3-t",        namedScratchpadAction myScratchpads "orgTodo")
    -- emacs
  , ("M-e",         spawnEmacs "")
  , ("M-x a",       spawnEmacs "-e '(org-agenda-list)'")
  , ("M-x <Space>", spawnEmacs "-e '(org-roam-dailies-capture-today)'")
  , ("M-x t",       spawnEmacs "-e '(org-todo-list)'")
  , ("M-<Tab>",     spawnEmacs "-e '(org-roam-dailies-find-today)'")
  -- , ("M-<Tab>",     spawn "~/.local/bin/orgtoday")

  -- rofi
  , ("M-<Space>",           spawn "rofi -show combi")
  , ("M-M3-=",              spawn "rofi -modi calc -show")
  , ("M-<XF86Calculator>",  spawn "rofi -modi calc -show") -- alt
  , ("M-M3-b",              spawn "rofi-bluetooth")
  , ("M-M3-c",              spawn "~/.local/bin/rofi/rofi-copyq")
  , ("M-M3-d",              spawn "~/.local/bin/rofi/rofi-systemd")
  , ("M-M3-e",              spawn "~/.local/bin/rofi/rofi-emacs")
  , ("M-M3-f",              spawn "rofi -modi file-browser-extended -show")
  , ("M-M3-k",              spawn "~/.local/bin/rofi/rofi-hotkeys")
  , ("M-M3-p",              spawn "rofi-pass")
  , ("M-M3-s",              spawn "~/.local/bin/rofi/rofi-web-search")
  , ("M-M3-t",              spawn "rofi-translate")
  , ("M-M3-x",              spawn "~/.local/bin/rofi/rofi-tmux")
  , ("M-M3-z",              spawn "rofi-zeal")
  , ("M-S-;",               shellPrompt myXPConfig)
  -- , ("M-M3-w",              windowMultiPrompt myXPConfig [(Goto, allWindows), (Goto, wsWindows)])
  -- , ("M-M3-x",              xmonadPrompt myXPConfig)

  -- workspaces / topics
  , ("M-S-.",           currentTopicAction myTopicConfig)
    -- layout
  , ("C-M1-<Tab>",      sendMessage $ NextLayout)
  , ("M-l S-=",         incScreenWindowSpacing 5)
  , ("M-l =",           incScreenWindowSpacing 10)
  , ("M-l -",           decScreenWindowSpacing 5)
  , ("M-l S--",         decScreenWindowSpacing 10)
  , ("M-l a",           sendMessage $ JumpToLayout "accord")
  , ("M-l b",           sendMessage $ JumpToLayout "basic")
  , ("M-l c",           sendMessage $ JumpToLayout "cross")
  , ("M-l f",           sendMessage $ JumpToLayout "simpFl")
  , ("M-l i",           sendMessage $ JumpToLayout "spir")
  , ("M-l l",           sendMessage $ JumpToLayout "full")
  , ("M-l m",           sendMessage $ JumpToLayout "smMouse")
  , ("M-l o",           sendMessage $ JumpToLayout "circ")
  , ("M-l p",           sendMessage $ JumpToLayout "saveFL")
  , ("M-l r",           sendMessage $ JumpToLayout "row")
  , ("M-l S-r",         sendMessage $ JumpToLayout "rolex")
  , ("M-l s",           sendMessage $ JumpToLayout "smBSP")
  , ("M-l x",           sendMessage $ JumpToLayout "xlBSP")
  , ("M-l z",           sendMessage $ JumpToLayout "zoomR")
  , ("M-l 3",           sendMessage $ JumpToLayout "threeMid")
  , ("M-l S-3",         sendMessage $ JumpToLayout "threeCol")
    -- "M-<arrow>" Go and "M-S-<arrow>" Swap bindings from Navigation2D
  , ("M-C-<Right>",     sendMessage $ ExpandTowards R)
  , ("M-C-<Left>",      sendMessage $ ExpandTowards L)
  , ("M-C-<Up>",        sendMessage $ ExpandTowards U)
  , ("M-C-<Down>",      sendMessage $ ExpandTowards D)
  -- , ("M-C-<Right>",     bindOn [ ("", sendMessage $ ExpandTowards R)
  --                              , ("", withFocused $ snapGrow R Nothing)])
  -- , ("M-C-<Left>",      bindOn [("", sendMessage $ ExpandTowards L)])
  -- , ("M-C-<Up>",        bindOn [("", sendMessage $ ExpandTowards U)])
  -- , ("M-C-<Down>",      bindOn [("", sendMessage $ ExpandTowards D)])
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
  -- window management in zoomRow layout
  , ("M-S-=",           sendMessage zoomIn)
  , ("M--",             sendMessage zoomOut)
  , ("M-z",             sendMessage zoomReset)
  , ("M-S-z",           sendMessage ZoomFullToggle)
  -- view or shift to other screen
  , ("M-<KP_Prior>",    onPrevNeighbour def W.shift)
  , ("M-<KP_Next>",     onNextNeighbour def W.shift)
  , ("M-C-<KP_Prior>",  onPrevNeighbour def W.view)
  , ("M-C-<KP_Next>",   onNextNeighbour def W.view)
  , ("M-S-s",           spawn "~/.local/bin/switch_primary_monitor.py")
  ---- alts
  , ("M-<KP_9>",        onPrevNeighbour def W.shift)
  , ("M-<KP_3>",        onNextNeighbour def W.shift)
  , ("M-C-<KP_9>",      onPrevNeighbour def W.view)
  , ("M-C-<KP_3>",      onNextNeighbour def W.view)

  -- windows
  , ("M-w",         kill)
  , ("M-c <Space>", windowMenu)
  , ("M-c =",       sendMessage $ Equalize)
  , ("M-c S-=",     sendMessage $ Balance)
  , ("M-c f",       withFocused $ float)
  , ("M-c n",       sendMessage $ SplitShift Next)
  , ("M-c p",       sendMessage $ SplitShift Prev)
  , ("M-c r",       sendMessage $ Rotate)
  , ("M-c <Left>",  sendMessage $ RotateL)
  , ("M-c <Right>", sendMessage $ RotateR)
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
    -- , ((modMask,                               button8), (\w -> spawn "nerd-dictation begin"))
    -- , ((modMask,                               button9), (\w -> spawn "nerd-dictation end"))
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
