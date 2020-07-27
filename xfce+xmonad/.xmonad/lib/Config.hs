module Config
  ( myTerminal
  -- , myWorkspaces
  , myXPConfig
  , spawnEmacs) where

import XMonad
import XMonad.Prompt

myTerminal   = "alacritty"

myXPConfig = def
  { fgColor = "#ffffff"
  , bgColor = "#000000"
  , promptBorderWidth = 2
  -- , position = Center
  , height = 30
  }

-- application functions
spawnEmacs :: String -> X ()
spawnEmacs toOpen = spawn ("emacsclient -a '' -c " ++ toOpen)
