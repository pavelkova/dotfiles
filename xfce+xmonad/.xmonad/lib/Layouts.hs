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

-- import           XMonad.Layout.Decoration
import           XMonad.Layout.Maximize
import           XMonad.Layout.Minimize
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
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
  $ mySpacing 5
  -- start certain workspaces with specific layouts
  -- $ onWorkspace "I hoy" threeCol
  -- $ onWorkspace "VII cor" threeMid
  $ ( basic
    ||| accord
    ||| circ
    ||| cross
    ||| full
    ||| long
    ||| rolex
    ||| row
    ||| simpFl
    ||| smBSP
    ||| smMouse
    ||| spir
    ||| threeCol
    ||| threeMid
    ||| xlBSP
    ||| zoomR
    )
  where
    -- named layouts
    basic       = named "basic"    $ emptyBSP
    accord      = named "accord"   $ Accordion
    circ        = named "circ"     $ Circle
    cross       = named "cross"    $ simpleCross
    full        = named "full"     $ noBorders Full
    long        = named "long"     $ Tall 1 (3/100) (3/5)
    rolex       = named "rolex"    $ Roledex
    row         = named "row"      $ Mirror long
    simpFl      = named "simpFl"   $ simplestFloat
    -- spir        = named "spir"     $ spiralWithDir East CW (6/7)
    spir        = named "spir"     $ spiral (6/7)
    threeCol    = named "threeCol" $ ThreeCol 1 (3/100) (1/3)
    threeMid    = named "threeMid" $ ThreeColMid 1 (3/100) (3/8)
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
