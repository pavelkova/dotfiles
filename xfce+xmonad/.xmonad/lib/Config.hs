module Config
  ( myTerminal
  , myXPConfig
  , spawnEmacs) where

import XMonad
import XMonad.Prompt

import Colors

-- myTerminal   = "alacritty"
myTerminal   = "konsole"

myXPConfig :: XPConfig
myXPConfig = def
  { fgColor = myForegroundColor
  , bgColor = myBackgroundColor
  , font = "xft:Victor Mono Medium-10"
  , defaultText = ""
  , height = 50
  , position = Bottom
  , promptBorderWidth = 2
  -- , searchPredicate = fuzzyMatch
  }

-- application functions
spawnEmacs :: String -> X ()
spawnEmacs toOpen = spawn ("emacsclient -a '' -c " ++ toOpen)
