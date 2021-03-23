module Scratchpads
  ( myScratchpads,
    myScratchpadsHook ) where

import          XMonad
import          XMonad.StackSet as W
import          XMonad.Util.NamedScratchpad

import          Config

orgRoamToday = "emacsclient -a '' -c -e '(org-roam-dailies-today)' --frame-parameteres='(quote (name . \"orgRoamToday\"))'"

myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "tilda" "cool-retro-term" (className =? "cool-retro-term") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))
                , NS "orgRoamToday" orgRoamToday (resource =? "orgRoamToday") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))
                , NS "MellowPlayer" "MellowPlayer" (className =? "MellowPlayer3") (customFloating $ W.RationalRect (1/3) (1/3) (1/3) (1/3))]

myScratchpadsHook = namedScratchpadManageHook myScratchpads
