module Scratchpads
  ( myScratchpads,
    myScratchpadsHook ) where

import          XMonad
import          XMonad.StackSet as W
import          XMonad.Util.NamedScratchpad

import          Config

orgRoam x      = "emacsclient -a '' -c -e '(org-roam-dailies-" ++ x ++ "-today)' -F '((name . \"" ++ x ++ "OrgRoam\"))'"
captureOrgRoam = orgRoam "capture"
-- findOrgRoam    = orgRoam "find"
findOrgRoam   = "~/.local/bin/orgtoday"

floatRect h w = customFloating $ W.RationalRect l t w h where
  t = (1 - h) / 2
  l = (1 - w) / 2

myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "retroTerm" "retroTerm" (className =? "cool-retro-term") (floatRect 0.3 0.3)
                , NS "captureOrgRoam" captureOrgRoam (title =? "captureOrgRoam") (floatRect 0.8 0.6)
                , NS "findOrgRoam" findOrgRoam (title =? "findOrgRoam") (floatRect 0.8 0.6)
                , NS "minitube" "minitube" (className =? "Minitube") (floatRect 0.5 0.4)]

myScratchpadsHook = namedScratchpadManageHook myScratchpads
