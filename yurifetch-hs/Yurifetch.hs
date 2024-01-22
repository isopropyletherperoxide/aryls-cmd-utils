{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use newtype instead of data" #-}

module Yurifetch (main) where

import Network.HTTP.Simple
import System.Exit (die)
import Text.Show.Pretty
import YurifetchLib

main :: IO ()
main = do
  let url = "https://gelbooru.com/index.php?page=dapi&s=post&q=index&tags=yuri&json=1"
  response <- httpBS url
  print response
  let fetchedPosts = getPosts response
  let parsedPosts = parsePosts fetchedPosts
  case parsedPosts of
    Just postList -> do
      pPrint $ attributes postList
      pPrint $ head $ post postList 
    Nothing -> do
      die "Error while decoding JSON!"
