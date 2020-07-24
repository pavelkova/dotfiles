module Keys
  ( myKeys ) where

import           XMonad
import           XMonad.Util.EZConfig
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Maximize
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet as W
-- import qualified XMonad.Layout.WindowNavigation as N

import           XMonad.Actions.FloatKeys
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.Minimize
import           XMonad.Actions.WindowMenu

import qualified Data.Map as M -- For keybindings.
import           Data.Maybe

import           Graphics.X11.ExtraTypes.XF86

import           Config ( myWorkspaces )

myKeys = \conf -> mkKeymap conf $
  -- keep some defaults
  [ -- ("M-S-q"),    spawn xfce4-session-logout or io (exitWith ExitSuccess)
    ("M-,",         sendMessage (IncMasterN 1))
  , ("M-.",         sendMessage (IncMasterN (-1)))
    -- programs
  , ("M-<Return>",  spawn $ XMonad.terminal conf)

  -- emacs
  , ("M-e",         spawn "emacsclient -a '' -c")
  , ("M-x a",       spawn "emacsclient -a '' -c -e '(org-agenda-list)'")
  , ("M-x c",       spawn "emacsclient -a '' -c -e '(org-capture)'")
  , ("M-x t",       spawn "emacsclient -a '' -c -e '(org-todo-list)'")
  , ("M-M3-r",      spawn "emacsclient -a '' -c -e '(org-roam-dailies-today)'")
    -- rofi
  , ("M-<Space>",   spawn "rofi -show combi")
  , ("M-=",         spawn "rofi -modi calc -show")
  , ("M-M3-p",      spawn "rofi-pass")
  , ("M-M3-s",      spawn "~/.local/bin/rofi/rofi-web-search")

    -- layout
    -- "M-<arrow>" Go and "M-S-<arrow>" Swap bindings from Navigation2D
  , ("M-C-<Right>",   sendMessage $ ExpandTowards R)
  , ("M-C-<Left>",    sendMessage $ ExpandTowards L)
  , ("M-C-<Up>",      sendMessage $ ExpandTowards U)
  , ("M-C-<Down>",    sendMessage $ ExpandTowards D)
  -- , ("M-C-S-<Right>", sendMessage $ ShrinkFrom R)
  -- , ("M-C-S-<Left>",  sendMessage $ ShrinkFrom L)
  -- , ("M-C-S-<Up>",    sendMessage $ ShrinkFrom U)
  -- , ("M-C-S-<Down>",  sendMessage $ ShrinkFrom D)
  , ("M-C-S-<Left>",  withFocused (keysResizeWindow (-50,0) (0,0)))
  , ("M-C-S-<Right>", withFocused (keysResizeWindow (50,0) (0,0)))
  , ("M-C-S-<Up>",    withFocused (keysResizeWindow (0,-50) (0,0)))
  , ("M-C-S-<Down>",  withFocused (keysResizeWindow (0,50) (0,0)))
  , ("M-S-t",         sendMessage NextLayout)

  -- windows
  , ("M-w",         kill)
  , ("M-c <Space>", windowMenu)
  , ("M-c f",       withFocused $ float)
  , ("M-c t",       withFocused $ windows . W.sink )
  , ("M-c z",       withFocused $ minimizeWindow)
  , ("M-c S-z",     withLastMinimized maximizeWindowAndFocus)
  , ("M-c x",       withFocused (sendMessage . maximizeRestore))
  ] ++
  [ (otherModMasks ++ "M-" ++ [key], action tag)
  | (tag, key)  <- zip myWorkspaces "123456789"
  , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
                               , ("S-", windows . W.shift)]
  ]
