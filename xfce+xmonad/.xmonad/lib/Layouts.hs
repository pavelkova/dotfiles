module Layouts
  ( myLayouts ) where

-- import           XMonad hiding ( (|||) )
import           XMonad.Layout hiding ( (|||) )
import           XMonad.Hooks.ManageDocks

import           XMonad.Actions.MouseResize

import           XMonad.Layout.Accordion
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Circle
import           XMonad.Layout.Cross
import           XMonad.Layout.LayoutCombinators -- hiding ( (|||) )
import           XMonad.Layout.MouseResizableTile
import           XMonad.Layout.Roledex
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.SimplestFloat
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns
import           XMonad.Layout.ZoomRow

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
  $ mySpacing 5
  $ ( basic
    ||| accord
    ||| circ
    ||| cross
    ||| full
    ||| rolex
    ||| simpFl
    ||| smBSP
    ||| smMouse
    ||| threeCol
    ||| threeMid
    ||| xlBSP
    ||| zoomR
    )
  where
    -- named layouts
    accord      = named "accord"   $ Accordion
    basic       = named "basic"    $ emptyBSP
    circ        = named "circ"     $ Circle
    cross       = named "cross"    $ simpleCross
    full        = named "full"     $ noBorders Full
    rolex       = named "rolex"    $ Roledex
    simpFl      = named "simpFl"   $ simplestFloat
    threeCol    = named "threeCol" $ ThreeCol 1 (3/100) (1/2)
    threeMid    = named "threeMid" $ ThreeColMid 1 (3/100) (1/2)
    zoomR       = named "zoomR"    $ zoomRow
    -- spacing formula
    --                       smartBorder  screenBorder     screenBorderEnabled  windowBorder     windowBorderEnabled
    mySpacing x = spacingRaw True         (Border 0 x x x) True                 (Border x x x x) True
    -- standard spacings
    smSpace     = mySpacing 10
    lgSpace     = mySpacing 25
    xlSpace     = mySpacing 55
    -- layouts with standard spacings
    smBSP       = named "smBSP" $ smSpace $ emptyBSP
    xlBSP       = named "xlBSP" $ xlSpace $ emptyBSP
    smMouse     = named "smMouse" $ smSpace $ mouseResizableTile
