module Bindings
  ( projects ) where

import XMonad.Actions.DynamicProjects

projects :: [Project]
projects =
  [ Project { projectName      = "scratch"
            , projectDirectory = "~/"
            , projectStartHook = Nothing
            }

  , Project { projectName      = "dgar"
            , projectDirectory = "~/Code/Current/dgar/"
            , projectStartHook = Just $ do spawn "emacs -a '' -c ~/Code/Current/dgar/index.org"
                                           spawnInShell "cd ~/Code/Current/dgar"
            }
  ]
