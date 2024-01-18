{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module YurifetchLib (Posts, Post, parsePosts, getPosts) where

import Data.Aeson
import Data.ByteString
import qualified Data.ByteString.Lazy as Data.ByteString.Lazy.Internal
import qualified Data.Text as T
import GHC.Generics
import Network.HTTP.Simple

newtype Posts = Posts {post :: [Post]} deriving (Generic, Show, FromJSON)

data Post = Post
  { file_url :: T.Text,
    tags :: T.Text,
    rating :: T.Text
  }
  deriving (Generic, Show, FromJSON)

getPosts :: Response ByteString -> Data.ByteString.Lazy.Internal.ByteString
getPosts response = fromStrict $ getResponseBody response

parsePosts :: Data.ByteString.Lazy.Internal.ByteString -> Maybe Posts
parsePosts = decode
