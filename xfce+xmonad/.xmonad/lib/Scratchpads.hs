module Scratchpads
  ( myScratchpads,
    myScratchpadsHook ) where

import          XMonad
import          XMonad.StackSet as W
import          XMonad.Util.NamedScratchpad

myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "tilda" "cool-retro-term" (className =? "cool-retro-term") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))]

myScratchpadsHook = namedScratchpadManageHook myScratchpads
