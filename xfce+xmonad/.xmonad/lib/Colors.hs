module Colors where

-- XMonad modules
import XMonad
import XMonad.Prompt
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Decoration
import XMonad.Layout.ImageButtonDecoration
import XMonad.Util.Image
import XMonad.Util.Loggers
import XMonad.Util.WorkspaceCompare

wpgTheme =
  newTheme { themeName        = "wpgTheme"
           , themeAuthor      = "egp"
           , themeDescription = "generate custom color themes with wpg"
           , theme            = def { activeColor         = "{color8}"
                                    , inactiveColor       = "{color0}"
                                    , urgentColor         = "{color1}"
                                    , activeBorderColor   = "{color8}"
                                    , inactiveBorderColor = "{color0}"
                                    , urgentBorderColor   = "{color1}"
                                    , activeTextColor     = "{color15}"
                                    , inactiveTextColor   = "{color7}"
                                    , urgentTextColor     = "{color0}"
                                    , fontName            = "xft:Cantarell:regular:size=10"
                                    , decoHeight          = 15
                                    }
           }
