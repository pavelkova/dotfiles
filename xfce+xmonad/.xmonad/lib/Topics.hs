module Topics
  ( myTopics
  , myTopicConfig
  , promptedGoto
  , promptedShift) where

import qualified Data.Map as M

import           XMonad

import           XMonad.Actions.TopicSpace

import           XMonad.Prompt
import           XMonad.Prompt.Workspace

import qualified XMonad.StackSet as W

import           XMonad.Util.Run

import           Config


-- myTopics :: [Topic]
-- myTopics =
--   [ "hoy"
--   , "navegar"
--   , "soliloquy"
--   , "vidal"
--   , "la torre"
--   , "notas"
--   , "correo"
--   , "aprendizaje"
--   , "español"
--   , "sistema"
--   ]

-- myTopicConfig :: TopicConfig
-- myTopicConfig = def
--   { topicDirs = M.fromList $
--     [ ("hoy",         "~/Org")
--     , ("navegar",     "~/Descargas")
--     , ("soliloquy",   "~/Code/Current/soliloquy")
--     , ("vidal",       "~/Code/Current/vidal")
--     , ("la torre",    "~/Org")
--     , ("notas",       "~/Org")
--     , ("correo",      "~/")
--     , ("aprendizaje", "~/Code/Courses")
--     , ("español",     "~/Org")
--     , ("sistema",     "~/")
--     ]
--   , defaultTopicAction = const $ spawnShell -- >*> 3
--   , defaultTopic       = "hoy"
--   , topicActions       = M.fromList $
--     [ ("hoy",         -- spawnEmacs "-e '(org-roam-dailies-today)'" >>
--                       spawn "ice-firefox https://todoist.com/app/#start" >>
--                       spawn "ice-firefox https://clockify.me/tracker" >>
--                       spawn "ice-firefox https://app.goalifyapp.com/home/personal/dashboard?tab=goals")
--     , ("navegar",     spawn "firefox")
--     , ("soliloquy",   spawnShell >>
--                       spawnEmacsInTopic "index.org" >>
--                       spawn "firefox")
--     , ("vidal",       spawnShell >>
--                       spawnEmacsInTopic "index.org" >>
--                       spawn "firefox")
--     , ("la torre",    spawn "manuskript" >>
--                       spawnEmacsInTopic "la_torre.org")
--     , ("notas",       spawnEmacs "-e '(org-journal-new-entry \"**\" (current-time))'" >>
--                       spawn "ghostwriter")
--     , ("correo",      spawn "thunderbird")
--     , ("aprendizaje", spawnEmacsInTopic "index.org")

--     , ("español",     spawnEmacsInTopic "cien_años_de_soledad.org")
--     , ("sistema",     runInTerm "" "gotop")
--     ]
--   }
myTopics :: [Topic]
myTopics =
  [ "I hoy"
  , "II nav"
  , "III sol"
  , "IV vid"
  , "V aug"
  , "VI not"
  , "VII cor"
  , "VIII apr"
  , "IX esp"
  , "X sis"
  ]

myTopicConfig :: TopicConfig
myTopicConfig = def
  { topicDirs = M.fromList $
    [ ("I hoy",    "~/Org")
    , ("II nav",   "~/Descargas")
    , ("III sol",  "~/Code/Current/soliloquy")
    , ("IV vid",   "~/Code/Current/vidal")
    , ("V aug",    "~/Org")
    , ("VI not",   "~/Org")
    , ("VII cor",  "~/")
    , ("VIII apr", "~/Code/Courses")
    , ("IX esp",   "~/Org")
    , ("X sis",    "~/")
    ]
  , defaultTopicAction = const $ spawnShell -- >*> 3
  , defaultTopic       = "hoy"
  , topicActions       = M.fromList $
    [ ("I hoy",    spawn "ice-firefox https://todoist.com/app/#start" >>
                   spawn "ice-firefox https://clockify.me/tracker" >>
                   spawn "ice-firefox https://app.goalifyapp.com/home/personal/dashboard?tab=goals")
    , ("II nav",   spawn "firefox")
    , ("III sol",  spawnShell >>
                     spawnEmacsInTopic "README.org" >>
                     spawn "firefox")
    , ("IV vid",   spawnShell >>
                     spawnEmacsInTopic "README.org" >>
                     spawn "firefox")
    , ("V aug",    spawn "manuskript" >>
                     spawnEmacsInTopic "la_torre.org")
    , ("VI not",   spawnEmacs "-e '(org-roam-dailies-today)'" >>
                     spawn "ghostwriter")
    , ("VII cor",  spawn "thunderbird")
    , ("VIII apr", spawnEmacsInTopic "index.org")

    , ("IX esp",   spawnEmacsInTopic "cien_años_de_soledad.org")
    , ("X sis",     runInTerm "" "gotop")
    ]
  }


spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
spawnShellIn dir = spawn $ myTerminal ++ " --working-directory " ++ dir

spawnEmacsInTopic :: String -> X ()
spawnEmacsInTopic endpoint = currentTopicDir myTopicConfig >>= spawnEmacsIn endpoint

spawnEmacsIn :: String -> String -> X ()
spawnEmacsIn endpoint dir = spawn $ "emacsclient -a '' -c " ++ dir ++ "/" ++ endpoint

goto :: Topic -> X ()
goto = switchTopic myTopicConfig

promptedGoto :: X ()
promptedGoto = workspacePrompt def goto

promptedShift :: X ()
promptedShift = workspacePrompt def $ windows . W.shift
