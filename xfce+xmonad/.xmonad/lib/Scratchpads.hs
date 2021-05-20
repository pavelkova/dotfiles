module Scratchpads
  ( myScratchpads,
    myScratchpadsHook ) where

import          XMonad
import          XMonad.StackSet as W
import          XMonad.Util.NamedScratchpad

import          Config

orgRoam x      = "emacsclient -a '' -c -e '(org-roam-dailies-" ++ x ++ "-today)' --frame-parameteres='(quote (name . \"" ++ x ++ "OrgRoam\"))'"
captureOrgRoam = orgRoam "capture"
findOrgRoam    = orgRoam "find"

myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "retroTerm" "retroTerm" (className =? "cool-retro-term") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))
                , NS "captureOrgRoam" captureOrgRoam (resource =? "captureOrgRoam") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))
                , NS "findOrgRoam" findOrgRoam (resource =? "findOrgRoam") (customFloating $ W.RationalRect (1/3) (0/1) (1/3) (1/3))
                , NS "MellowPlayer" "MellowPlayer" (className =? "MellowPlayer3") (customFloating $ W.RationalRect (1/3) (1/3) (1/3) (1/3))]

myScratchpadsHook = namedScratchpadManageHook myScratchpads
