module Config
  ( myTerminal
  , myXPConfig
  , myThemeWithButtons
  , spawnEmacs) where

import           XMonad
import           XMonad.Prompt

import           XMonad.Layout.Decoration
import           XMonad.Layout.DecorationAddons

import           XMonad.Util.Font

import           Colors

-- myTerminal   = "alacritty"
myTerminal   = "konsole"

myXPConfig :: XPConfig
myXPConfig = def
  { fgColor = myForegroundColor
  , bgColor = myBackgroundColor
  -- , fgHLight = my
  -- , bgHLight = my
  , font = "xft:Victor Mono Medium-10"
  , defaultText = ""
  , height = 250
  , position = Bottom
  , promptBorderWidth = 2
  -- , searchPredicate = fuzzyMatch
  }

myThemeWithButtons :: Theme
myThemeWithButtons  = def
  { activeColor       = myActiveColor
  , inactiveColor     = myInactiveColor
  , urgentColor       = myForegroundColor
  , decoHeight        = 5
  , windowTitleAddons = [ (" (M)", AlignLeft)
                        , ("_"   , AlignRightOffset 48)
                        , ("[]"  , AlignRightOffset 25)
                        , ("X"   , AlignRightOffset 10)
                        ]
  }
-- application functions
spawnEmacs :: String -> X ()
spawnEmacs toOpen = spawn ("emacsclient -a '' -c " ++ toOpen)
