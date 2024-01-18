{-# LANGUAGE OverloadedStrings #-}

import YurifetchLib
import qualified Data.ByteString.Lazy as BL

main :: IO ()
main = do
        testCase <- BL.readFile "index.php.json"
        let a = parsePosts testCase
        print a
