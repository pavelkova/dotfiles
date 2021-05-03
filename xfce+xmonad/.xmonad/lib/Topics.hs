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


myTopics :: [Topic]
myTopics =
  [ "hoy"
  , "navegar"
  , "soliloquy"
  , "vidal"
  , "la torre"
  , "notas"
  , "correo"
  , "aprendizaje"
  , "español"
  , "sistema"
  ]

myTopicConfig :: TopicConfig
myTopicConfig = def
  { topicDirs = M.fromList $
    [ ("hoy",         "~/Media/org")
    , ("navegar",     "~/Downloads")
    , ("soliloquy",   "~/Code/Current/soliloquy")
    , ("vidal",       "~/Code/Current/vidal")
    , ("la torre",    "~/Media/org")
    , ("notas",       "~/Media/org")
    , ("correo",      "~/")
    , ("aprendizaje", "~/Code/Courses")
    , ("español",     "~/Media/org")
    , ("sistema",     "~/")
    ]
  , defaultTopicAction = const $ spawnShell -- >*> 3
  , defaultTopic       = "hoy"
  , topicActions       = M.fromList $
    [ ("hoy",         -- spawnEmacs "-e '(org-roam-dailies-today)'" >>
                      spawn "ice-firefox https://todoist.com/app/#start" >>
                      spawn "ice-firefox https://clockify.me/tracker" >>
                      spawn "ice-firefox https://app.goalifyapp.com/home/personal/dashboard?tab=goals")
    , ("navegar",     spawn "firefox")
    , ("soliloquy",   spawnShell >>
                      spawnEmacsInTopic "index.org" >>
                      spawn "firefox")
    , ("vidal",       spawnShell >>
                      spawnEmacsInTopic "index.org" >>
                      spawn "firefox")
    , ("la torre",    spawn "manuskript" >>
                      spawnEmacsInTopic "la_torre.org")
    , ("notas",       spawnEmacs "-e '(org-journal-new-entry \"**\" (current-time))'" >>
                      spawn "ghostwriter")
    , ("correo",      spawn "thunderbird")
    , ("aprendizaje", spawnEmacsInTopic "index.org")

    , ("español",     spawnEmacsInTopic "cien_años_de_soledad.org")
    , ("sistema",     runInTerm "" "gotop")
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
