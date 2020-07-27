module  Projects
  ( projects
  )
where

import           XMonad
import           XMonad.Actions.DynamicProjects
import           XMonad.Util.Run

projects :: [Project]
projects =
  [ Project { projectName      = "---"
            , projectDirectory = "~/"
            , projectStartHook = Nothing
            }
  , Project
    { projectName      = "dgar"
    , projectDirectory = "~/Code/Current/dgar/"
    , projectStartHook = Just $ do
                           spawn "emacsclient -a '' -c ~/Code/Current/dgar/index.org"
                           runInTerm "" "cd ~/Code/Current/dgar"
    }
  , Project
    { projectName      = "la torre"
    , projectDirectory = "~/Media/org/escritura/ficciones/"
    , projectStartHook = Just $ do
                           spawn "emacsclient -a '' -c ~/Media/org/escritura/ficciones/la_torre.org"
                           spawn "manuskript"
    }
  ]
