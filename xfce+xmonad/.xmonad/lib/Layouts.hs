module Layouts
  ( myLayouts ) where

import XMonad.Layout


import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Circle
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Roledex
import XMonad.Layout.SimpleFloat
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Layout.Decoration
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

myLayouts = N.windowNavigation
  $ avoidStruts
  $ smartBorders
  $ smartSpacingWithEdge 5
  $ ( emptyBSP
   ||| mouseResizableTile
   ||| simpleFloat
   ||| simplestFloat
   ||| threeCol
   ||| threeMid
   ||| full
   ||| Circle
   ||| spiral (6/7)
   ||| Roledex
    )
  where
    smSpace = smartSpacingWithEdge 5
    lgSpace = smartSpacingWithEdge 35
    xlSpace = smartSpacingWithEdge 75

    full     = named "full" $ noBorders Full
    threeCol = named "threeCol" $ ThreeCol 1 (3/100) (1/2)
    threeMid = named "threeMid" $ ThreeColMid 1 (3/100) (1/2)

    smBSP    = smSpace $ emptyBSP
    smMouse  = smSpace $ mouseResizableTile
