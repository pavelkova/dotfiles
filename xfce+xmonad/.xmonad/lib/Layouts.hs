module Layouts
  ( myLayouts ) where

import           XMonad.Layout
import           XMonad.Hooks.ManageDocks

import           XMonad.Actions.MouseResize

import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Circle
import           XMonad.Layout.MouseResizableTile
import           XMonad.Layout.Roledex
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.SimplestFloat
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns

import           XMonad.Layout.Decoration
import           XMonad.Layout.Maximize
import           XMonad.Layout.Minimize
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.WindowArranger

import qualified XMonad.Layout.WindowNavigation as N

myLayouts = N.windowNavigation
  $ mouseResize
  $ windowArrange
  $ maximize
  $ minimize
  $ avoidStruts
  $ smartBorders
  -- $ buttonDeco shrinkText defaultThemeWithButtons
  $ smartSpacingWithEdge 5
  $ ( emptyBSP
   -- ||| smBSP
   -- ||| xlBSP
   ||| mouseResizableTile
   -- ||| simpleFloat
   -- ||| simplestFloat
   ||| threeCol
   ||| threeMid
   ||| full
   ||| Circle
   ||| spiral (6/7)
   ||| Roledex
    )
  where
    smSpace = smartSpacingWithEdge 10
    lgSpace = smartSpacingWithEdge 25
    xlSpace = smartSpacingWithEdge 55

    full     = named "full" $ noBorders Full
    threeCol = named "threeCol" $ ThreeCol 1 (3/100) (1/2)
    threeMid = named "threeMid" $ ThreeColMid 1 (3/100) (1/2)

    smBSP    = smSpace $ emptyBSP
    xlBSP    = xlSpace $ emptyBSP
    smMouse  = smSpace $ mouseResizableTile
