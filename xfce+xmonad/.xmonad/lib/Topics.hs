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
  , "dgar"
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
    , ("dgar",        "~/Code/Current/dgar")
    , ("vidal",       "~/Code/Current/vidal")
    , ("la torre",    "~/Media/org/escritura/ficciones")
    , ("notas",       "~/Media/org")
    , ("correo",      "~/")
    , ("aprendizaje", "~/Media/org/aprendizaje")
    , ("español",     "~/Media/org/aprendizaje/español")
    , ("sistema",     "~/")
    ]
  , defaultTopicAction = const $ spawnShell -- >*> 3
  , defaultTopic       = "hoy"
  , topicActions       = M.fromList $
    [ ("hoy",         spawnEmacs "-e '(org-roam-dailies)'")
    , ("navegar",     spawn "firefox")
    , ("dgar",        spawnShell >>
        spawnEmacsInTopic "index.org" >>
        spawn "firefox")
    , ("vidal",       spawnShell >>
        spawnEmacsInTopic "index.org" >>
        spawn "firefox")
    , ("la torre",    spawnEmacsInTopic "la_torre.org")
    , ("notas",       spawnEmacsInTopic "")
    , ("correo",      spawn "thunderbird")
    , ("aprendizaje", spawnEmacsInTopic "index.org")
    , ("español",     spawnEmacsInTopic "cien_años_de_soledad.org")
    , ("sistema",     runInTerm "" "gotop")
    ]
  }


spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
-- spawnShellIn dir = spawn $ "urxvt '(cd ''" ++ dir ++ "'' && " ++ myShell ++ " )'"
spawnShellIn dir = spawn $ myTerminal ++ " --working-directory " ++ dir

spawnEmacsInTopic endpoint = currentTopicDir myTopicConfig >>= spawnEmacsIn endpoint

spawnEmacsIn :: String -> String -> X ()
spawnEmacsIn dir endpoint = spawn $ "emacs -a '' -c " ++ dir ++ "/" ++ endpoint

goto :: Topic -> X ()
goto = switchTopic myTopicConfig

promptedGoto :: X ()
promptedGoto = workspacePrompt myXPConfig goto

promptedShift :: X ()
promptedShift = workspacePrompt myXPConfig $ windows . W.shift
