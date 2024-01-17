{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use <&>" #-}

module Main (main) where

import Control.Monad (when)
import qualified Data.Text as T
import qualified Data.Text.IO as I
import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.Format
import Data.Time.LocalTime
import System.Environment.Blank (getArgs)
import System.Exit (die)

date :: IO (Integer, Int, Int)
date = getZonedTime >>= return . toGregorian . utctDay . zonedTimeToUTC

newdate :: IO Day 
newdate = getZonedTime >>= return .  utctDay . zonedTimeToUTC

main :: IO ()
main = do
  args <- getArgs
  when (null args) $ die "Not enough arguments!"
  dateVal <- newdate
  wotdContent <- deleteLastLines "/home/aryl/Dropbox/uwu/Meta/Word of the day.md"
  let wotd = T.append (neoDateFormat dateVal) (T.pack $ head args)
  let newfile = T.append wotdContent (T.append wotd "\n\n#meta")
  --  I.writeFile "/home/aryl/Dropbox/uwu/Meta/Word of the day.md" newfile
  I.writeFile "/home/aryl/WOTDTEST" newfile
  print $ T.append "Today is.... " (neoDateFormat dateVal)
  print $ "Today's word of the day is: " ++ head args

dateFormat :: (Integer, Int, Int) -> T.Text
dateFormat (a, b, c) = T.pack (day ++ "." ++ month ++ "." ++ drop 2 year ++ ": ")
  where
    day = padNum c
    month = padNum b
    year = show a

neoDateFormat :: (FormatTime t) => t -> T.Text
neoDateFormat a = T.pack $ formatTime defaultTimeLocale "%d.%m.%y: " a

padNum :: Int -> String
padNum a
  | a < 10 = "0" ++ show a
  | otherwise = show a

deleteLastLines :: FilePath -> IO T.Text
deleteLastLines a = do
  file <- I.readFile a
  let b = dropEnd 2 $ T.lines file
  return $ T.unlines b

dropEnd :: Int -> [a] -> [a]
dropEnd n xs = zipWith const xs (drop n xs)
