{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}


module YurifetchLib (Posts, Post, Attributes, attributes, parsePosts, getPosts, post) where

import Data.Aeson
import Data.ByteString
import qualified Data.ByteString.Lazy as Data.ByteString.Lazy.Internal
import qualified Data.Text as T
import GHC.Generics
import Network.HTTP.Simple

data Posts = Posts {
  attributes :: !Attributes 
    , post :: ![Post]} deriving (Generic, Show)

data Post = Post
  { file_url :: !T.Text,
    tags :: !T.Text,
    rating :: !T.Text
  }
  deriving (Generic, Show, FromJSON)

data Attributes = Attributes {
        limit :: !Int , 
        offset :: !Int , 
        count :: !Int 
                             } 
                             deriving (Generic, Show, FromJSON)

instance FromJSON Posts where 
        parseJSON = withObject "Posts" $ \v -> Posts
          <$> v .: "@attributes"
          <*> v .: "post"

getPosts :: Response ByteString -> Data.ByteString.Lazy.Internal.ByteString
getPosts response = fromStrict $ getResponseBody response

parsePosts :: Data.ByteString.Lazy.Internal.ByteString -> Maybe Posts
parsePosts = decode
